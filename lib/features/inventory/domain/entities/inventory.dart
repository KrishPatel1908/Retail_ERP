/// Domain models of the Inventory module.
///
/// The presentation layer only ever sees these classes; Drift row types are
/// mapped inside the repository.
library;

/// Stock status derived from the current quantity and the product's
/// minimum stock threshold.
enum StockStatus { inStock, lowStock, outOfStock }

extension StockStatusX on StockStatus {
  String get label => switch (this) {
    StockStatus.inStock => 'In Stock',
    StockStatus.lowStock => 'Low Stock',
    StockStatus.outOfStock => 'Out of Stock',
  };

  /// The db value used by the stock-status filter.
  String get dbValue => switch (this) {
    StockStatus.inStock => 'IN_STOCK',
    StockStatus.lowStock => 'LOW_STOCK',
    StockStatus.outOfStock => 'OUT_OF_STOCK',
  };
}

/// One stock row in the Inventory list: exactly one sellable item — a
/// product without variants, or one variant of a product. Variants are
/// never combined into a single row.
class InventoryItemEntity {
  const InventoryItemEntity({
    required this.productId,
    required this.productCode,
    required this.productName,
    this.variantId,
    this.variantName,
    this.barcode,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    required this.unitId,
    this.unitName,
    this.unitSymbol,
    required this.currentStock,
    this.minimumStock = 0,
    this.purchasePrice,
    this.sellingPrice,
    this.mrp,
    required this.updatedAt,
  });

  final int productId;
  final String productCode;
  final String productName;

  /// Null for products without variants — displayed as an em dash.
  final int? variantId;
  final String? variantName;

  /// Variant barcode when set, otherwise the product barcode.
  final String? barcode;

  final int? categoryId;
  final String? categoryName;
  final int? brandId;
  final String? brandName;

  final int unitId;
  final String? unitName;
  final String? unitSymbol;

  /// Current on-hand quantity from `current_stock`.
  final int currentStock;

  /// Low-stock threshold inherited from the parent product.
  final int minimumStock;

  /// Per-unit prices in paise; the variant overrides when present.
  final int? purchasePrice;
  final int? sellingPrice;
  final int? mrp;

  final DateTime updatedAt;

  /// Stable identity of the stock row.
  String get key => '$productId:${variantId ?? 'base'}';

  /// Human-readable item name: the variant name for variant rows,
  /// otherwise the product name.
  String get displayName => variantName ?? productName;

  StockStatus get status {
    if (currentStock <= 0) return StockStatus.outOfStock;
    if (minimumStock > 0 && currentStock <= minimumStock) {
      return StockStatus.lowStock;
    }
    return StockStatus.inStock;
  }
}

/// One entry of a product/variant's stock movement history.
class StockMovementEntity {
  const StockMovementEntity({
    required this.id,
    required this.productId,
    this.variantId,
    this.transactionType,
    required this.quantity,
    this.previousQuantity,
    this.newQuantity,
    this.referenceNumber,
    this.transactionDate,
    this.note,
    this.productName,
    this.variantName,
    this.barcode,
    this.unitName,
    this.unitSymbol,
  });

  final int id;
  final int productId;
  final int? variantId;

  /// PURCHASE, PURCHASE_RETURN, STOCK_ADJUSTMENT, PURCHASE_ADJUSTMENT, SALE.
  final String? transactionType;

  /// Signed movement: positive = stock in, negative = stock out.
  final int quantity;

  /// Stock before the movement. Null for legacy rows created before the
  /// column existed.
  final int? previousQuantity;

  /// Stock after the movement. Null for legacy rows.
  final int? newQuantity;

  final String? referenceNumber;
  final DateTime? transactionDate;
  final String? note;

  // Display fields resolved via joins.
  final String? productName;
  final String? variantName;
  final String? barcode;
  final String? unitName;
  final String? unitSymbol;

  bool get isIn => quantity > 0;
  bool get isOut => quantity < 0;

  /// The display label for the transaction type.
  String get typeLabel => switch (transactionType) {
    'PURCHASE' => 'Purchase',
    'PURCHASE_RETURN' => 'Purchase Return',
    'STOCK_ADJUSTMENT' => 'Stock Adjustment',
    'PURCHASE_ADJUSTMENT' => 'Purchase Adjustment',
    'SALE' => 'Sale',
    'SALE_RETURN' => 'Sales Return',
    _ => transactionType ?? '—',
  };
}

/// A selectable product/variant option used by the Stock Adjustment form.
class StockAdjustmentOption {
  const StockAdjustmentOption({
    required this.productId,
    required this.itemName,
    this.variantId,
    this.variantName,
    this.barcode,
    required this.currentStock,
    required this.unitName,
  });

  final int productId;
  final int? variantId;

  /// The sellable name: variant name when present, else product name.
  final String itemName;
  final String? variantName;
  final String? barcode;
  final int currentStock;
  final String unitName;

  String get key => '$productId:${variantId ?? 'base'}';
}
