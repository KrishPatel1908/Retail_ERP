import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/brand.dart';
import '../../domain/exceptions/brand_exceptions.dart';

/// Data access for product brands.
///
/// The single entry point the presentation layer uses to read and write
/// brands. Drift types never leak past this class: callers receive and
/// return [Brand] domain entities only.
class BrandRepository {
  BrandRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All brands, ordered case-insensitively by name, with dynamically
  /// calculated product counts.
  Future<List<Brand>> getAllBrands() async {
    final countExpr = _database.products.id.count();
    final query = _database.select(_database.brands).join([
      leftOuterJoin(
        _database.products,
        _database.products.brandId.equalsExp(_database.brands.id),
      ),
    ])
      ..addColumns([countExpr])
      ..groupBy([_database.brands.id])
      ..orderBy([OrderingTerm.asc(_database.brands.brandName.lower())]);

    final rows = await query.get();
    return rows.map((row) {
      final brandRow = row.readTable(_database.brands);
      final count = row.read(countExpr) ?? 0;
      return _toEntity(brandRow, productCount: count);
    }).toList();
  }

  /// Case-insensitive search by name or description. An empty query returns all
  /// brands.
  Future<List<Brand>> searchBrands(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllBrands();
    }

    final countExpr = _database.products.id.count();
    final joinedQuery = _database.select(_database.brands).join([
      leftOuterJoin(
        _database.products,
        _database.products.brandId.equalsExp(_database.brands.id),
      ),
    ])
      ..where(
        _database.brands.brandName.lower().contains(normalized) |
            (_database.brands.description.isNotNull() &
                _database.brands.description.lower().contains(normalized)),
      )
      ..addColumns([countExpr])
      ..groupBy([_database.brands.id])
      ..orderBy([OrderingTerm.asc(_database.brands.brandName.lower())]);

    final rows = await joinedQuery.get();
    return rows.map((row) {
      final brandRow = row.readTable(_database.brands);
      final count = row.read(countExpr) ?? 0;
      return _toEntity(brandRow, productCount: count);
    }).toList();
  }

  /// Whether a brand with this name (case-insensitive) exists.
  ///
  /// [excludeId] ignores a single brand, used when checking name
  /// uniqueness during an edit.
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final normalized = name.trim().toLowerCase();
    final row =
        await (_database.select(_database.brands)..where((t) {
              final matches = t.brandName.lower().equals(normalized);
              if (excludeId == null) {
                return matches;
              }
              return matches & t.id.isNotValue(excludeId);
            }))
            .getSingleOrNull();
    return row != null;
  }

  /// Creates a brand and returns the stored entity.
  ///
  /// Throws [BrandAlreadyExistsException] when the name is already taken.
  Future<Brand> createBrand({
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName)) {
      throw BrandAlreadyExistsException(trimmedName);
    }

    try {
      final id = await _database.into(_database.brands).insert(
        db.BrandsCompanion.insert(
          brandCode: 'BRD_${DateTime.now().microsecondsSinceEpoch}',
          brandName: trimmedName,
          description: Value(trimmedDescription),
        ),
      );
      return _toEntity(await _getById(id), productCount: 0);
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName)) {
        throw BrandAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to create brand.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing brand and returns the updated entity.
  ///
  /// Throws [BrandAlreadyExistsException] when the new name collides with
  /// another brand, and [BrandNotFoundException] when the brand no
  /// longer exists.
  Future<Brand> updateBrand(
    int id, {
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, excludeId: id)) {
      throw BrandAlreadyExistsException(trimmedName);
    }

    try {
      final updatedRows =
          await (_database.update(
            _database.brands,
          )..where((t) => t.id.equals(id))).write(
            db.BrandsCompanion(
              brandName: Value(trimmedName),
              description: Value(trimmedDescription),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw BrandNotFoundException(id);
      }
      final count = await _getProductCountForBrand(id);
      return _toEntity(await _getById(id), productCount: count);
    } on BrandNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw BrandAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to update brand.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a brand.
  ///
  /// Throws [BrandInUseException] when one or more products reference the
  /// brand.
  Future<void> deleteBrand(int id) async {
    final count = await _getProductCountForBrand(id);
    if (count > 0) {
      throw const BrandInUseException();
    }

    try {
      await (_database.delete(
        _database.brands,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const BrandInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete brand.',
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

  Future<db.Brand> _getById(int id) async {
    final row = await (_database.select(
      _database.brands,
    )..where((t) => t.id.equals(id))).getSingle();
    return row;
  }

  Future<int> _getProductCountForBrand(int brandId) async {
    final rows = await (_database.select(_database.products)
      ..where((t) => t.brandId.equals(brandId))).get();
    return rows.length;
  }

  Brand _toEntity(db.Brand row, {int productCount = 0}) {
    return Brand(
      id: row.id,
      brandName: row.brandName,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      productCount: productCount,
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
