/// Represents a sellable product or variant available for POS sale.
class SellableItem {
  const SellableItem({
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    this.barcode,
    required this.sellingPrice,
    this.mrp,
    required this.unitId,
    required this.unitName,
    required this.unitSymbol,
    this.taxCategoryId,
    this.taxCategoryName,
    this.taxRate = 0.0,
    required this.availableStock,
    this.categoryId,
    this.categoryName,
    this.isActive = true,
  });

  final int productId;
  final int? variantId;
  final String productName;
  final String? variantName;
  final String? barcode;

  /// Selling price in paise.
  final int sellingPrice;

  /// MRP in paise (if available).
  final int? mrp;

  final int unitId;
  final String unitName;
  final String unitSymbol;

  final int? taxCategoryId;
  final String? taxCategoryName;

  /// Total tax rate percentage (e.g. 18.0 for 18%).
  final double taxRate;

  /// Current on-hand stock quantity.
  final int availableStock;

  final int? categoryId;
  final String? categoryName;

  final bool isActive;

  String get itemKey => '$productId:${variantId ?? 'base'}';

  String get displayName => (variantName != null && variantName!.trim().isNotEmpty)
      ? '$productName ($variantName)'
      : productName;

  bool get isOutOfStock => availableStock <= 0;

  SellableItem copyWith({
    int? productId,
    int? variantId,
    String? productName,
    String? variantName,
    String? barcode,
    int? sellingPrice,
    int? mrp,
    int? unitId,
    String? unitName,
    String? unitSymbol,
    int? taxCategoryId,
    String? taxCategoryName,
    double? taxRate,
    int? availableStock,
    int? categoryId,
    String? categoryName,
    bool? isActive,
  }) {
    return SellableItem(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      barcode: barcode ?? this.barcode,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
      unitSymbol: unitSymbol ?? this.unitSymbol,
      taxCategoryId: taxCategoryId ?? this.taxCategoryId,
      taxCategoryName: taxCategoryName ?? this.taxCategoryName,
      taxRate: taxRate ?? this.taxRate,
      availableStock: availableStock ?? this.availableStock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isActive: isActive ?? this.isActive,
    );
  }
}
