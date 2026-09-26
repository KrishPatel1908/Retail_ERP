/// Domain model of a product.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code. Monetary values are stored as paise.
class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.productCode,
    required this.productName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.brandId,
    this.brandName,
    required this.unitId,
    this.unitName,
    required this.sellingPrice,
    this.purchasePrice,
    this.mrp,
    this.wholesalePrice,
    this.barcode,
    this.hsnCode,
    this.taxTypeId,
    this.taxTypeName,
    this.taxCategoryId,
    this.taxCategoryName,
    this.minimumStock = 0,
    this.expiryDate,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.variants = const [],
  });

  final int id;
  final String productCode;
  final String productName;

  final int? categoryId;
  final String? categoryName;

  final int? subCategoryId;
  final String? subCategoryName;

  final int? brandId;
  final String? brandName;

  final int unitId;
  final String? unitName;

  /// Selling price in paise.
  final int sellingPrice;

  /// Optional purchase price in paise.
  final int? purchasePrice;

  /// Optional Maximum Retail Price (MRP) in paise.
  final int? mrp;

  /// Optional wholesale price in paise.
  final int? wholesalePrice;

  /// Optional barcode / SKU.
  final String? barcode;

  /// Optional HSN / SAC code.
  final String? hsnCode;

  final int? taxTypeId;
  final String? taxTypeName;

  /// Reference to the Tax Category (e.g. "GST 18%") that governs this product.
  ///
  /// This is the canonical tax source for a product (used by Purchase Entry to
  /// auto-fill the tax rate from the category's configured total).
  final int? taxCategoryId;
  final String? taxCategoryName;

  /// Minimum stock threshold used by the Inventory module's Low Stock status.
  /// Zero disables the low-stock warning. Variants inherit this threshold.
  final int minimumStock;

  /// Optional expiry date for the parent product.
  final DateTime? expiryDate;

  final String? notes;

  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Variants of this product. Populated when fetching product details.
  final List<ProductVariantEntity> variants;

  /// Whether this product has any variants.
  bool get hasVariants => variants.isNotEmpty;

  /// The effective selling price: if there are variants, the first variant's
  /// price is used; otherwise the parent's price.
  int get effectivePrice {
    if (variants.isNotEmpty) return variants.first.sellingPrice;
    return sellingPrice;
  }

  /// A display-friendly price string showing "Multiple" when variants exist
  /// with different prices.
  String get priceDisplay {
    if (variants.isEmpty) return 'sellingPrice';
    if (variants.length == 1) return 'singleVariant';
    final prices = variants.map((v) => v.sellingPrice).toSet();
    if (prices.length == 1) return 'samePrice';
    return 'multiple';
  }
}

/// Domain model of a product variant.
class ProductVariantEntity {
  const ProductVariantEntity({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.sellingPrice,
    this.purchasePrice,
    this.mrp,
    this.wholesalePrice,
    this.barcode,
    this.hsnCode,
    this.expiryDate,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int productId;
  final String variantName;

  /// Selling price in paise.
  final int sellingPrice;

  /// Optional purchase price in paise.
  final int? purchasePrice;

  /// Optional Maximum Retail Price (MRP) in paise.
  final int? mrp;

  /// Optional wholesale price in paise.
  final int? wholesalePrice;

  /// Optional barcode / SKU.
  final String? barcode;

  /// Optional HSN / SAC code.
  final String? hsnCode;

  /// Optional expiry date for this specific variant.
  final DateTime? expiryDate;

  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
