import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/tax_type.dart';
import '../../domain/exceptions/tax_type_exceptions.dart';

/// Data access for tax types.
///
/// The single entry point the presentation layer uses to read and write
/// tax types. Drift types never leak past this class: callers receive and
/// return [TaxType] domain entities only.
class TaxTypeRepository {
  TaxTypeRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All tax types, ordered case-insensitively by name.
  Future<List<TaxType>> getAllTaxTypes() async {
    final rows = await (_database.select(
      _database.taxTypes,
    )..orderBy([(t) => OrderingTerm.asc(t.taxTypeName.lower())])).get();
    return rows.map(_toEntity).toList();
  }

  /// Case-insensitive search by name or description. An empty query returns all
  /// tax types.
  Future<List<TaxType>> searchTaxTypes(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllTaxTypes();
    }

    final rows = await (_database.select(_database.taxTypes)
      ..where(
        (t) =>
            t.taxTypeName.lower().contains(normalized) |
            (t.description.isNotNull() &
                t.description.lower().contains(normalized)),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.taxTypeName.lower())])).get();

    return rows.map(_toEntity).toList();
  }

  /// Whether a tax type with this name (case-insensitive) exists.
  ///
  /// [excludeId] ignores a single tax type, used when checking name
  /// uniqueness during an edit.
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final normalized = name.trim().toLowerCase();
    final row =
        await (_database.select(_database.taxTypes)..where((t) {
              final matches = t.taxTypeName.lower().equals(normalized);
              if (excludeId == null) {
                return matches;
              }
              return matches & t.id.isNotValue(excludeId);
            }))
            .getSingleOrNull();
    return row != null;
  }

  /// Creates a tax type and returns the stored entity.
  ///
  /// Throws [TaxTypeAlreadyExistsException] when the name is already taken.
  Future<TaxType> createTaxType({
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName)) {
      throw TaxTypeAlreadyExistsException(trimmedName);
    }

    try {
      final id = await _database.into(_database.taxTypes).insert(
        db.TaxTypesCompanion.insert(
          taxTypeCode: 'TT_${DateTime.now().microsecondsSinceEpoch}',
          taxTypeName: trimmedName,
          description: Value(trimmedDescription),
        ),
      );
      return _toEntity(await _getById(id));
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName)) {
        throw TaxTypeAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to create tax type.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing tax type and returns the updated entity.
  ///
  /// Throws [TaxTypeAlreadyExistsException] when the new name collides with
  /// another tax type, and [TaxTypeNotFoundException] when the tax type no
  /// longer exists.
  Future<TaxType> updateTaxType(
    int id, {
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, excludeId: id)) {
      throw TaxTypeAlreadyExistsException(trimmedName);
    }

    try {
      final updatedRows =
          await (_database.update(
            _database.taxTypes,
          )..where((t) => t.id.equals(id))).write(
            db.TaxTypesCompanion(
              taxTypeName: Value(trimmedName),
              description: Value(trimmedDescription),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw TaxTypeNotFoundException(id);
      }
      return _toEntity(await _getById(id));
    } on TaxTypeNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw TaxTypeAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to update tax type.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a tax type.
  ///
  /// Throws [TaxTypeInUseException] when referenced by tax category rates or products.
  Future<void> deleteTaxType(int id) async {
    final productCount = await (_database.select(_database.products)
      ..where((t) => t.taxTypeId.equals(id))).get().then((l) => l.length);
    final rateCount = await (_database.select(_database.taxCategoryRates)
      ..where((t) => t.taxTypeId.equals(id))).get().then((l) => l.length);

    if (productCount > 0 || rateCount > 0) {
      throw const TaxTypeInUseException();
    }

    try {
      await (_database.delete(
        _database.taxTypes,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const TaxTypeInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete tax type.',
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

  Future<db.TaxType> _getById(int id) async {
    final row = await (_database.select(
      _database.taxTypes,
    )..where((t) => t.id.equals(id))).getSingle();
    return row;
  }

  TaxType _toEntity(db.TaxType row) {
    return TaxType(
      id: row.id,
      taxTypeName: row.taxTypeName,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// SQLite extended result code for a UNIQUE constraint violation.
  static const int _sqliteConstraintUnique = 2067;

  /// SQLite extended result code for a FOREIGN KEY constraint violation.
  static const int _sqliteConstraintForeignKey = 787;

  /// Extracts the underlying [SqliteException], whether it was thrown
  /// directly or wrapped by Drift.
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
