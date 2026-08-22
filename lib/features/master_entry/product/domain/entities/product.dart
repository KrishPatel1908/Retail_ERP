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
    this.taxTypeId,
    this.taxTypeName,
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

  final int? taxTypeId;
  final String? taxTypeName;

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

  /// Optional expiry date for this specific variant.
  final DateTime? expiryDate;

  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
