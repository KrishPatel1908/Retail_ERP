import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';

import '../../domain/entities/inventory.dart';

/// Filters for the inventory list. All set filters combine with AND, and the
/// whole predicate is evaluated database-side.
class InventoryFilters {
  const InventoryFilters({
    this.categoryId,
    this.brandId,
    this.stockStatus,
  });

  final int? categoryId;
  final int? brandId;
  final StockStatus? stockStatus;
}

/// One page of the inventory list.
class InventoryPage {
  const InventoryPage({required this.items, required this.totalCount});

  final List<InventoryItemEntity> items;
  final int totalCount;
}

/// One page of a product/variant's stock movement history.
class StockMovementPage {
  const StockMovementPage({required this.items, required this.totalCount});

  final List<StockMovementEntity> items;
  final int totalCount;
}

/// Data access for the Inventory module.
///
/// Reads the materialized `current_stock` cache maintained by [StockService]
/// and records adjustments through it. Never mutates stock directly: every
/// change must go through [StockService] so a movement is always written
/// atomically with the quantity change.
class InventoryRepository {
  InventoryRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database,
      _stockService = StockService(database: database);

  final db.AppDatabase _database;
  final StockService _stockService;

  // ──────────────────── LISTING ────────────────────

  /// Returns one page of stock rows matching [query] and [filters].
  ///
  /// One joined query (stock → product LEFT JOIN variant → category/brand/
  /// unit) so every stocked product/variant pair appears exactly once, with
  /// database-side filtering, sorting and pagination.
  Future<InventoryPage> fetchPage({
    String query = '',
    InventoryFilters filters = const InventoryFilters(),
    bool sortAscending = true,
    int page = 1,
    int pageSize = 25,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final predicate = _buildItemPredicate(
      normalizedQuery: query.trim().toLowerCase(),
      filters: filters,
    );

    final productNameOrder = _database.products.productName.lower();
    final variantNameOrder = _database.productVariants.variantName.lower();

    // Count query over the same joins.
    final countExpr = _database.products.id.count();
    final countQuery = _database.selectOnly(_database.products).join([
      leftOuterJoin(
        _database.productVariants,
        _database.productVariants.productId.equalsExp(_database.products.id),
      ),
      leftOuterJoin(
        _database.currentStocks,
        _database.currentStocks.productId.equalsExp(_database.products.id) &
            (
              (_database.productVariants.id.isNotNull() &
                  _database.currentStocks.variantId.equalsExp(
                    _database.productVariants.id,
                  )) |
              (_database.productVariants.id.isNull() &
                  (_database.currentStocks.variantId.isNull() |
                      _database.currentStocks.variantId.equals(0)))
            ),
      ),
      leftOuterJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.products.categoryId),
      ),
      leftOuterJoin(
        _database.brands,
        _database.brands.id.equalsExp(_database.products.brandId),
      ),
      innerJoin(
        _database.units,
        _database.units.id.equalsExp(_database.products.unitId),
      ),
    ]);
    countQuery.addColumns([countExpr]);
    if (predicate != null) countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    // Page query.
    final rowsQuery = _selectStockRows()
      ..orderBy([
        sortAscending
            ? OrderingTerm.asc(productNameOrder)
            : OrderingTerm.desc(productNameOrder),
        sortAscending
            ? OrderingTerm.asc(variantNameOrder)
            : OrderingTerm.desc(variantNameOrder),
      ]);
    if (predicate != null) rowsQuery.where(predicate);
    rowsQuery.limit(pageSize, offset: (effectivePage - 1) * pageSize);

    final rows = await rowsQuery.get();
    return InventoryPage(
      items: [for (final row in rows) _stockItemFromRow(row)],
      totalCount: total,
    );
  }

  /// Distinct categories (filter dropdown).
  Future<List<({int id, String name})>> distinctCategories() async {
    final rows = await (_database.select(_database.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.categoryName.lower())]))
        .get();
    return [for (final r in rows) (id: r.id, name: r.categoryName)];
  }

  /// Distinct brands (filter dropdown).
  Future<List<({int id, String name})>> distinctBrands() async {
    final rows = await (_database.select(_database.brands)
          ..orderBy([(t) => OrderingTerm.asc(t.brandName.lower())]))
        .get();
    return [for (final r in rows) (id: r.id, name: r.brandName)];
  }

  /// Selectable items for the Stock Adjustment form: one option per stocked
  /// product/variant, loaded in a single joined query, optionally filtered
  /// by name or barcode.
  Future<List<StockAdjustmentOption>> adjustmentOptions({
    String query = '',
  }) async {
    final normalized = query.trim().toLowerCase();
    final stock = _database.currentStocks;
    final product = _database.products;
    final variant = _database.productVariants;
    final unit = _database.units;

    final rowsQuery = _database.select(product).join([
      leftOuterJoin(variant, variant.productId.equalsExp(product.id)),
      leftOuterJoin(
        stock,
        stock.productId.equalsExp(product.id) &
            (
              (variant.id.isNotNull() & stock.variantId.equalsExp(variant.id)) |
              (variant.id.isNull() &
                  (stock.variantId.isNull() | stock.variantId.equals(0)))
            ),
      ),
      innerJoin(unit, unit.id.equalsExp(product.unitId)),
    ]);

    Expression<bool> predicate = product.isActive.equals(true) &
        (variant.id.isNull() | variant.isActive.equals(true));

    if (normalized.isNotEmpty) {
      predicate = predicate &
          (product.productName.lower().contains(normalized) |
              variant.variantName.lower().contains(normalized) |
              product.barcode.lower().contains(normalized) |
              variant.barcode.lower().contains(normalized));
    }
    rowsQuery.where(predicate);
    rowsQuery.orderBy([
      OrderingTerm.asc(product.productName.lower()),
      OrderingTerm.asc(variant.variantName.lower()),
    ]);

    final rows = await rowsQuery.get();
    return [
      for (final row in rows)
        () {
          final s = row.readTableOrNull(stock);
          final p = row.readTable(product);
          final v = row.readTableOrNull(variant);
          final u = row.readTable(unit);
          return StockAdjustmentOption(
            productId: p.id,
            variantId: v?.id,
            itemName: v?.variantName ?? p.productName,
            variantName: v?.variantName,
            barcode: v?.barcode ?? p.barcode,
            currentStock: s?.quantity ?? 0,
            unitName: u.unitName,
          );
        }(),
    ];
  }

  // ──────────────────── STOCK MOVEMENT HISTORY ────────────────────

  /// One page of the movement history for a product/variant, newest first.
  Future<StockMovementPage> fetchMovements({
    required int productId,
    int? variantId,
    int page = 1,
    int pageSize = 25,
  }) async {
    final t = _database.inventoryTransactions;
    final predicate = variantId != null
        ? t.productId.equals(productId) & t.variantId.equals(variantId)
        : t.productId.equals(productId) &
              (t.variantId.isNull() | t.variantId.equals(0));

    final countExpr = t.id.count();
    final countQuery = _database.selectOnly(t)..addColumns([countExpr]);
    countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    final effectivePage = page < 1 ? 1 : page;
    final rows = await (_database.select(t)
          ..where((row) => predicate)
          ..orderBy([
            (row) => OrderingTerm.desc(t.transactionDate),
            (row) => OrderingTerm.desc(t.id),
          ])
          ..limit(pageSize, offset: (effectivePage - 1) * pageSize))
        .get();

    // Resolve the display names once per page, not per row.
    final product = await (_database.select(_database.products)
          ..where((u) => u.id.equals(productId)))
        .getSingleOrNull();
    final variant = variantId == null
        ? null
        : await (_database.select(_database.productVariants)
              ..where((u) => u.id.equals(variantId)))
            .getSingleOrNull();

    return StockMovementPage(
      totalCount: total,
      items: [
        for (final row in rows)
          StockMovementEntity(
            id: row.id,
            productId: row.productId,
            variantId: row.variantId,
            transactionType: row.transactionType,
            quantity: row.quantity,
            previousQuantity: row.previousQuantity,
            newQuantity: row.newQuantity,
            referenceNumber: row.referenceNumber,
            transactionDate: row.transactionDate,
            note: row.notes,
            productName: product?.productName,
            variantName: variant?.variantName,
            barcode: variant?.barcode ?? product?.barcode,
          ),
      ],
    );
  }

  // ──────────────────── STOCK ADJUSTMENT ────────────────────

  /// Records a manual stock adjustment atomically: the movement and the
  /// stock change are written together by [StockService] inside one
  /// transaction.
  ///
  /// Throws [InsufficientStockException] when a decrease would drive the
  /// stock below zero; the transaction rolls back so nothing is partially
  /// written.
  Future<int> createAdjustment({
    required int productId,
    int? variantId,
    required StockAdjustmentDirection direction,
    required int quantity,
    required String reason,
    String? note,
    required DateTime adjustmentDate,
  }) {
    return _database.transaction(() async {
      return _stockService.recordAdjustment(
        productId: productId,
        variantId: variantId,
        direction: direction,
        quantity: quantity,
        reason: reason,
        note: note,
        adjustmentDate: adjustmentDate,
      );
    });
  }

  // ──────────────────── INTERNALS ────────────────────

  JoinedSelectStatement _selectStockRows() {
    final product = _database.products;
    final variant = _database.productVariants;
    final stock = _database.currentStocks;
    final category = _database.categories;
    final brand = _database.brands;
    final unit = _database.units;

    return _database.select(product).join([
      leftOuterJoin(variant, variant.productId.equalsExp(product.id)),
      leftOuterJoin(
        stock,
        stock.productId.equalsExp(product.id) &
            (
              (variant.id.isNotNull() & stock.variantId.equalsExp(variant.id)) |
              (variant.id.isNull() &
                  (stock.variantId.isNull() | stock.variantId.equals(0)))
            ),
      ),
      leftOuterJoin(category, category.id.equalsExp(product.categoryId)),
      leftOuterJoin(brand, brand.id.equalsExp(product.brandId)),
      innerJoin(unit, unit.id.equalsExp(product.unitId)),
    ]);
  }

  InventoryItemEntity _stockItemFromRow(TypedResult row) {
    final stock = row.readTableOrNull(_database.currentStocks);
    final product = row.readTable(_database.products);
    final variant = row.readTableOrNull(_database.productVariants);
    final category = row.readTableOrNull(_database.categories);
    final brand = row.readTableOrNull(_database.brands);
    final unit = row.readTable(_database.units);

    return InventoryItemEntity(
      productId: product.id,
      productCode: product.productCode,
      productName: product.productName,
      variantId: variant?.id,
      variantName: variant?.variantName,
      barcode: variant?.barcode ?? product.barcode,
      categoryId: product.categoryId,
      categoryName: category?.categoryName,
      brandId: product.brandId,
      brandName: brand?.brandName,
      unitId: product.unitId,
      unitName: unit.unitName,
      unitSymbol: unit.unitSymbol,
      currentStock: stock?.quantity ?? 0,
      minimumStock: product.minimumStock,
      purchasePrice: variant?.purchasePrice ?? product.purchasePrice,
      sellingPrice: variant?.sellingPrice ?? product.sellingPrice,
      mrp: variant?.mrp ?? product.mrp,
      updatedAt: stock?.updatedAt ?? variant?.updatedAt ?? product.updatedAt,
    );
  }

  Expression<bool>? _buildItemPredicate({
    required String normalizedQuery,
    required InventoryFilters filters,
  }) {
    final product = _database.products;
    final variant = _database.productVariants;
    final stock = _database.currentStocks;

    Expression<bool> predicate = product.isActive.equals(true) &
        (variant.id.isNull() | variant.isActive.equals(true));

    // Case-insensitive search across product name, variant name, and barcode.
    if (normalizedQuery.isNotEmpty) {
      predicate =
          predicate &
          (product.productName.lower().contains(normalizedQuery) |
              variant.variantName.lower().contains(normalizedQuery) |
              product.barcode.lower().contains(normalizedQuery) |
              variant.barcode.lower().contains(normalizedQuery));
    }

    if (filters.categoryId != null) {
      predicate = predicate & product.categoryId.equals(filters.categoryId!);
    }
    if (filters.brandId != null) {
      predicate = predicate & product.brandId.equals(filters.brandId!);
    }
    if (filters.stockStatus != null) {
      final minimum = product.minimumStock;
      final quantity = coalesce([stock.quantity, const Constant(0)]);
      predicate = switch (filters.stockStatus!) {
        // quantity = 0.
        StockStatus.outOfStock => predicate & quantity.equals(0),
        // 0 < quantity <= minimum, with a threshold configured.
        StockStatus.lowStock =>
          predicate &
              quantity.isBiggerThan(const Constant(0)) &
              minimum.isBiggerThan(const Constant(0)) &
              quantity.isSmallerOrEqual(minimum),
        // quantity > 0 and not low stock.
        StockStatus.inStock =>
          predicate &
              quantity.isBiggerThan(const Constant(0)) &
              (minimum.isSmallerOrEqual(const Constant(0)) |
                  quantity.isBiggerThan(minimum)),
      };
    }

    return predicate;
  }
}
