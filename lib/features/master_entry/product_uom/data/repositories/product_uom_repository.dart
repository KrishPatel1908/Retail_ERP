import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/product_lookup_item.dart';
import '../../domain/entities/product_uom.dart';
import '../../domain/entities/product_uom_display.dart';
import '../../domain/exceptions/product_uom_exceptions.dart';

/// Data access for product-specific conversions.
class ProductUomRepository {
  ProductUomRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// Fetches all active products from the existing `products` table in the DB.
  /// No mock or sample data is used.
  Future<List<ProductLookupItem>> getAllProducts() async {
    final rows = await (_database.select(
      _database.products,
    )..orderBy([(t) => OrderingTerm.asc(t.productName)])).get();

    return rows
        .map(
          (p) => ProductLookupItem(
            id: p.id,
            productCode: p.productCode,
            productName: p.productName,
          ),
        )
        .toList();
  }

  /// All product conversions with joined product and unit details.
  Future<List<ProductUomDisplay>> getAllConversions() async {
    final fromUnits = _database.alias(_database.units, 'from_units');
    final toUnits = _database.alias(_database.units, 'to_units');

    final query =
        _database.select(_database.productUoms).join([
          innerJoin(
            _database.products,
            _database.products.id.equalsExp(_database.productUoms.productId),
          ),
          innerJoin(
            fromUnits,
            fromUnits.id.equalsExp(_database.productUoms.fromUnitId),
          ),
          innerJoin(
            toUnits,
            toUnits.id.equalsExp(_database.productUoms.toUnitId),
          ),
        ])
          ..orderBy([
            OrderingTerm.asc(_database.products.productName),
            OrderingTerm.desc(_database.productUoms.isDefault),
            OrderingTerm.asc(_database.productUoms.id),
          ]);

    final rows = await query.get();
    return rows.map((row) {
      final uom = row.readTable(_database.productUoms);
      final prod = row.readTable(_database.products);
      final fromU = row.readTable(fromUnits);
      final toU = row.readTable(toUnits);
      return ProductUomDisplay(
        id: uom.id,
        productId: uom.productId,
        productName: prod.productName,
        fromUnitId: uom.fromUnitId,
        fromUnitName: fromU.unitName,
        fromUnitSymbol: fromU.unitSymbol,
        toUnitId: uom.toUnitId,
        toUnitName: toU.unitName,
        toUnitSymbol: toU.unitSymbol,
        conversionFactor: uom.conversionFactor,
        isDefault: uom.isDefault,
        description: uom.description,
        isActive: uom.isActive,
        createdAt: uom.createdAt,
        updatedAt: uom.updatedAt,
      );
    }).toList();
  }

  /// Case-insensitive search across product name, units, and description.
  Future<List<ProductUomDisplay>> searchConversions(String queryText) async {
    if (queryText.trim().isEmpty) return getAllConversions();

    final term = '%${queryText.trim().toLowerCase()}%';
    final fromUnits = _database.alias(_database.units, 'from_units');
    final toUnits = _database.alias(_database.units, 'to_units');

    final query =
        _database.select(_database.productUoms).join([
          innerJoin(
            _database.products,
            _database.products.id.equalsExp(_database.productUoms.productId),
          ),
          innerJoin(
            fromUnits,
            fromUnits.id.equalsExp(_database.productUoms.fromUnitId),
          ),
          innerJoin(
            toUnits,
            toUnits.id.equalsExp(_database.productUoms.toUnitId),
          ),
        ])
          ..where(
            _database.products.productName.lower().like(term) |
                fromUnits.unitName.lower().like(term) |
                fromUnits.unitSymbol.lower().like(term) |
                toUnits.unitName.lower().like(term) |
                toUnits.unitSymbol.lower().like(term) |
                _database.productUoms.description.lower().like(term),
          )
          ..orderBy([
            OrderingTerm.asc(_database.products.productName),
            OrderingTerm.desc(_database.productUoms.isDefault),
            OrderingTerm.asc(_database.productUoms.id),
          ]);

    final rows = await query.get();
    return rows.map((row) {
      final uom = row.readTable(_database.productUoms);
      final prod = row.readTable(_database.products);
      final fromU = row.readTable(fromUnits);
      final toU = row.readTable(toUnits);
      return ProductUomDisplay(
        id: uom.id,
        productId: uom.productId,
        productName: prod.productName,
        fromUnitId: uom.fromUnitId,
        fromUnitName: fromU.unitName,
        fromUnitSymbol: fromU.unitSymbol,
        toUnitId: uom.toUnitId,
        toUnitName: toU.unitName,
        toUnitSymbol: toU.unitSymbol,
        conversionFactor: uom.conversionFactor,
        isDefault: uom.isDefault,
        description: uom.description,
        isActive: uom.isActive,
        createdAt: uom.createdAt,
        updatedAt: uom.updatedAt,
      );
    }).toList();
  }

  /// All conversions of one product, defaults first, then by id.
  Future<List<ProductUom>> getForProduct(int productId) async {
    final rows =
        await (_database.select(_database.productUoms)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isDefault),
            (t) => OrderingTerm.asc(t.id),
          ])).get();
    return rows.map(_toEntity).toList();
  }

  /// Checks if exact duplicate (product, from unit, to unit, factor) exists.
  Future<bool> existsConversion(
    int productId,
    int fromUnitId,
    int toUnitId,
    double conversionFactor, {
    int? excludeId,
  }) async {
    final row =
        await (_database.select(_database.productUoms)..where((t) {
          var matches =
              t.productId.equals(productId) &
              t.fromUnitId.equals(fromUnitId) &
              t.toUnitId.equals(toUnitId) &
              t.conversionFactor.equals(conversionFactor);
          if (excludeId != null) {
            matches = matches & t.id.isNotValue(excludeId);
          }
          return matches;
        })).getSingleOrNull();
    return row != null;
  }

  /// Creates a conversion. The first conversion for a product automatically
  /// becomes the default.
  Future<ProductUom> createConversion({
    required int productId,
    required int fromUnitId,
    required int toUnitId,
    required double conversionFactor,
    String? description,
    bool isDefault = false,
  }) async {
    _validate(fromUnitId, toUnitId, conversionFactor);

    if (await existsConversion(
      productId,
      fromUnitId,
      toUnitId,
      conversionFactor,
    )) {
      throw const ProductUomAlreadyExistsException();
    }

    try {
      final id = await _database.transaction(() async {
        final existing =
            await (_database.select(_database.productUoms)
              ..where((t) => t.productId.equals(productId))).get();
        final isFirst = existing.isEmpty;
        final shouldBeDefault = isDefault || isFirst;

        if (shouldBeDefault && existing.isNotEmpty) {
          await (_database.update(_database.productUoms)
            ..where((t) => t.productId.equals(productId))).write(
            const db.ProductUomsCompanion(isDefault: Value(false)),
          );
        }

        return _database.into(_database.productUoms).insert(
          db.ProductUomsCompanion.insert(
            productId: productId,
            fromUnitId: fromUnitId,
            toUnitId: toUnitId,
            conversionFactor: conversionFactor,
            isDefault: Value(shouldBeDefault),
            description: Value(_normalizeDescription(description)),
          ),
        );
      });
      return _toEntity(await _getById(id));
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const ProductUomAlreadyExistsException();
      }
      throw DatabaseOperationException(
        'Failed to create product conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates a conversion.
  Future<ProductUom> updateConversion(
    int id, {
    int? productId,
    int? fromUnitId,
    int? toUnitId,
    double? conversionFactor,
    String? description,
    bool? isDefault,
  }) async {
    final row = await _getByIdOrNull(id);
    if (row == null) throw ProductUomNotFoundException(id);

    final resolvedProduct = productId ?? row.productId;
    final resolvedFrom = fromUnitId ?? row.fromUnitId;
    final resolvedTo = toUnitId ?? row.toUnitId;
    final resolvedFactor = conversionFactor ?? row.conversionFactor;
    final resolvedIsDefault = isDefault ?? row.isDefault;
    _validate(resolvedFrom, resolvedTo, resolvedFactor);

    if (await existsConversion(
      resolvedProduct,
      resolvedFrom,
      resolvedTo,
      resolvedFactor,
      excludeId: id,
    )) {
      throw const ProductUomAlreadyExistsException();
    }

    try {
      await _database.transaction(() async {
        if (resolvedIsDefault && !row.isDefault) {
          await (_database.update(_database.productUoms)
            ..where((t) => t.productId.equals(resolvedProduct))).write(
            const db.ProductUomsCompanion(isDefault: Value(false)),
          );
        }

        await (_database.update(_database.productUoms)
          ..where((t) => t.id.equals(id))).write(
          db.ProductUomsCompanion(
            productId: Value(resolvedProduct),
            fromUnitId: Value(resolvedFrom),
            toUnitId: Value(resolvedTo),
            conversionFactor: Value(resolvedFactor),
            isDefault: Value(resolvedIsDefault),
            description: Value(_normalizeDescription(description)),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });
      return _toEntity(await _getById(id));
    } on ProductUomNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const ProductUomAlreadyExistsException();
      }
      throw DatabaseOperationException(
        'Failed to update product conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Deletes a conversion. If the deleted conversion was the default,
  /// automatically assigns default to the oldest remaining conversion for that product.
  Future<void> deleteConversion(int id) async {
    final row = await _getByIdOrNull(id);
    if (row == null) return;

    try {
      await _database.transaction(() async {
        await (_database.delete(_database.productUoms)
          ..where((t) => t.id.equals(id))).go();

        if (row.isDefault) {
          final remaining =
              await (_database.select(_database.productUoms)
                ..where((t) => t.productId.equals(row.productId))
                ..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

          if (remaining.isNotEmpty) {
            final oldest = remaining.first;
            await (_database.update(_database.productUoms)
              ..where((t) => t.id.equals(oldest.id))).write(
              const db.ProductUomsCompanion(isDefault: Value(true)),
            );
          }
        }
      });
    } on Exception catch (error, stackTrace) {
      throw DatabaseOperationException(
        'Failed to delete product conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Marks conversion as default, clearing previous default for the product.
  Future<void> setDefault(int id) async {
    final row = await _getByIdOrNull(id);
    if (row == null) throw ProductUomNotFoundException(id);

    await _database.transaction(() async {
      await (_database.update(_database.productUoms)
        ..where((t) => t.productId.equals(row.productId))).write(
        const db.ProductUomsCompanion(isDefault: Value(false)),
      );
      await (_database.update(_database.productUoms)
        ..where((t) => t.id.equals(id))).write(
        db.ProductUomsCompanion(
          isDefault: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Resolves factor for product.
  Future<double?> resolveFactor(
    int productId,
    int fromUnitId,
    int toUnitId,
  ) async {
    if (fromUnitId == toUnitId) return 1.0;

    final forward =
        await (_database.select(_database.productUoms)..where(
          (t) =>
              t.productId.equals(productId) &
              t.fromUnitId.equals(fromUnitId) &
              t.toUnitId.equals(toUnitId),
        )).getSingleOrNull();
    if (forward != null) return forward.conversionFactor;

    final reverse =
        await (_database.select(_database.productUoms)..where(
          (t) =>
              t.productId.equals(productId) &
              t.fromUnitId.equals(toUnitId) &
              t.toUnitId.equals(fromUnitId),
        )).getSingleOrNull();
    if (reverse != null) return 1 / reverse.conversionFactor;

    return null;
  }

  void _validate(int fromUnitId, int toUnitId, double conversionFactor) {
    if (fromUnitId == toUnitId) {
      throw ArgumentError('From and to units must be different.');
    }
    if (conversionFactor <= 0) {
      throw ArgumentError('Conversion factor must be greater than zero.');
    }
  }

  String? _normalizeDescription(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<db.ProductUom?> _getByIdOrNull(int id) async {
    return (_database.select(_database.productUoms)
      ..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<db.ProductUom> _getById(int id) async {
    final row = await _getByIdOrNull(id);
    if (row == null) throw ProductUomNotFoundException(id);
    return row;
  }

  ProductUom _toEntity(db.ProductUom row) {
    return ProductUom(
      id: row.id,
      productId: row.productId,
      fromUnitId: row.fromUnitId,
      toUnitId: row.toUnitId,
      conversionFactor: row.conversionFactor,
      isDefault: row.isDefault,
      description: row.description,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static const int _sqliteConstraintUnique = 2067;

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
}
