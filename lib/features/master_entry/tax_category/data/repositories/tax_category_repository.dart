import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/tax_category.dart';
import '../../domain/entities/tax_category_component.dart';
import '../../domain/exceptions/tax_category_exceptions.dart';

/// Data access for tax categories.
///
/// The single entry point the presentation layer uses to read and write
/// tax categories. Drift types never leak past this class: callers receive and
/// return [TaxCategory] domain entities only.
class TaxCategoryRepository {
  TaxCategoryRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All tax categories, ordered case-insensitively by name.
  Future<List<TaxCategory>> getAllTaxCategories() async {
    final catRows = await (_database.select(_database.taxCategories)
      ..orderBy([(t) => OrderingTerm.asc(t.taxCategoryName.lower())])).get();

    return _mapCategoriesWithComponents(catRows);
  }

  /// Case-insensitive search by name or description. An empty query returns all
  /// tax categories.
  Future<List<TaxCategory>> searchTaxCategories(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllTaxCategories();
    }

    final catRows = await (_database.select(_database.taxCategories)
      ..where(
        (t) =>
            t.taxCategoryName.lower().contains(normalized) |
            (t.description.isNotNull() &
                t.description.lower().contains(normalized)),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.taxCategoryName.lower())])).get();

    return _mapCategoriesWithComponents(catRows);
  }

  /// Gets a tax category by its unique [id], or null if not found.
  Future<TaxCategory?> getById(int id) async {
    final catRow = await (_database.select(_database.taxCategories)
      ..where((t) => t.id.equals(id))).getSingleOrNull();

    if (catRow == null) return null;

    final categories = await _mapCategoriesWithComponents([catRow]);
    return categories.firstOrNull;
  }

  /// Whether a tax category with this name (case-insensitive) exists.
  ///
  /// [excludeId] ignores a single tax category, used when checking name
  /// uniqueness during an edit.
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final normalized = name.trim().toLowerCase();
    final row = await (_database.select(_database.taxCategories)..where((t) {
          final matches = t.taxCategoryName.lower().equals(normalized);
          if (excludeId == null) {
            return matches;
          }
          return matches & t.id.isNotValue(excludeId);
        })).getSingleOrNull();
    return row != null;
  }

  /// Creates a tax category with components and returns the stored entity.
  ///
  /// Throws [TaxCategoryAlreadyExistsException] when the name is already taken.
  Future<TaxCategory> createTaxCategory({
    required String name,
    String? description,
    required List<TaxCategoryComponent> components,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName)) {
      throw TaxCategoryAlreadyExistsException(trimmedName);
    }

    try {
      final createdId = await _database.transaction(() async {
        final id = await _database.into(_database.taxCategories).insert(
          db.TaxCategoriesCompanion.insert(
            taxCategoryCode: 'TC_${DateTime.now().microsecondsSinceEpoch}',
            taxCategoryName: trimmedName,
            description: Value(trimmedDescription),
          ),
        );

        for (final comp in components) {
          await _database.into(_database.taxCategoryRates).insert(
            db.TaxCategoryRatesCompanion.insert(
              taxCategoryId: id,
              taxTypeId: comp.taxTypeId,
              ratePercent: comp.percentage,
            ),
          );
        }

        return id;
      });

      final category = await getById(createdId);
      if (category == null) {
        throw TaxCategoryNotFoundException(createdId);
      }
      return category;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName)) {
        throw TaxCategoryAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to create tax category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing tax category and its components, returning the updated entity.
  ///
  /// Throws [TaxCategoryAlreadyExistsException] when the name is taken, and
  /// [TaxCategoryNotFoundException] when the record does not exist.
  Future<TaxCategory> updateTaxCategory(
    int id, {
    required String name,
    String? description,
    required List<TaxCategoryComponent> components,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, excludeId: id)) {
      throw TaxCategoryAlreadyExistsException(trimmedName);
    }

    try {
      await _database.transaction(() async {
        final updatedRows = await (_database.update(_database.taxCategories)
          ..where((t) => t.id.equals(id))).write(
          db.TaxCategoriesCompanion(
            taxCategoryName: Value(trimmedName),
            description: Value(trimmedDescription),
            updatedAt: Value(DateTime.now()),
          ),
        );

        if (updatedRows == 0) {
          throw TaxCategoryNotFoundException(id);
        }

        // Replace rate components
        await (_database.delete(_database.taxCategoryRates)
          ..where((t) => t.taxCategoryId.equals(id))).go();

        for (final comp in components) {
          await _database.into(_database.taxCategoryRates).insert(
            db.TaxCategoryRatesCompanion.insert(
              taxCategoryId: id,
              taxTypeId: comp.taxTypeId,
              ratePercent: comp.percentage,
            ),
          );
        }
      });

      final category = await getById(id);
      if (category == null) {
        throw TaxCategoryNotFoundException(id);
      }
      return category;
    } on TaxCategoryNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw TaxCategoryAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to update tax category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a tax category.
  ///
  /// Throws [TaxCategoryInUseException] when referenced by any product
  /// through a tax type in this category.
  Future<void> deleteTaxCategory(int id) async {
    // Check if any product uses a tax type that belongs to this category.
    final rateQuery = _database.select(_database.taxCategoryRates)
      ..where((t) => t.taxCategoryId.equals(id));
    final rates = await rateQuery.get();
    final taxTypeIds = rates.map((r) => r.taxTypeId).toSet();

    int productCount = 0;
    if (taxTypeIds.isNotEmpty) {
      productCount = await (_database.select(_database.products)
        ..where((t) => t.taxTypeId.isIn(taxTypeIds.toList())))
          .get()
          .then((l) => l.length);
    }

    if (productCount > 0) {
      throw const TaxCategoryInUseException();
    }

    try {
      await _database.transaction(() async {
        await (_database.delete(_database.taxCategoryRates)
          ..where((t) => t.taxCategoryId.equals(id))).go();

        final deletedRows = await (_database.delete(_database.taxCategories)
          ..where((t) => t.id.equals(id))).go();

        if (deletedRows == 0) {
          throw TaxCategoryNotFoundException(id);
        }
      });
    } on TaxCategoryNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const TaxCategoryInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete tax category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  // --- Internals -----------------------------------------------------------

  String? _normalizeDescription(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<List<TaxCategory>> _mapCategoriesWithComponents(
    List<db.TaxCategory> catRows,
  ) async {
    if (catRows.isEmpty) return const [];
    final catIds = catRows.map((c) => c.id).toList();

    final query = _database.select(_database.taxCategoryRates).join([
      innerJoin(
        _database.taxTypes,
        _database.taxTypes.id.equalsExp(_database.taxCategoryRates.taxTypeId),
      ),
    ])..where(_database.taxCategoryRates.taxCategoryId.isIn(catIds));

    final rows = await query.get();
    final map = <int, List<TaxCategoryComponent>>{};

    for (final row in rows) {
      final rate = row.readTable(_database.taxCategoryRates);
      final type = row.readTable(_database.taxTypes);

      map.putIfAbsent(rate.taxCategoryId, () => []).add(
        TaxCategoryComponent(
          taxTypeId: type.id,
          taxTypeName: type.taxTypeName,
          percentage: rate.ratePercent,
        ),
      );
    }

    return catRows.map((c) {
      return TaxCategory(
        id: c.id,
        taxCategoryName: c.taxCategoryName,
        description: c.description,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
        components: map[c.id] ?? const [],
      );
    }).toList();
  }

  static const int _sqliteConstraintUnique = 2067;
  static const int _sqliteConstraintForeignKey = 787;

  SqliteException? _asSqliteException(Object error) {
    return switch (error) {
      SqliteException exception => exception,
      DriftWrappedException(:final cause) when cause is SqliteException =>
        cause,
      _ => null,
    };
  }

  bool _isUniqueViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintUnique;
  }

  bool _isForeignKeyViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintForeignKey;
  }
}
