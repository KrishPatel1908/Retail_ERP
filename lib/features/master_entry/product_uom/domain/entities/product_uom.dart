/// A product-specific conversion rule (approved blueprint §4.2).
///
/// Semantics: `1 toUnit = conversionFactor × fromUnit` for the given
/// product — e.g. for product Banana: from Dozen, to Piece, factor 12
/// means "1 Dozen = 12 Piece". Several conversions per product are allowed
/// as long as (product, from unit, to unit, factor) is unique.
///
/// Exactly one conversion per product may be the [isDefault] one (enforced
/// by the `idx_product_uom_one_default` partial unique index and by the
/// repository, which clears the previous default when a new one is set).
///
/// This module prepares the architecture for Product Master; no UI is wired
/// to it yet.
class ProductUom {
  const ProductUom({
    required this.id,
    required this.productId,
    required this.fromUnitId,
    required this.toUnitId,
    required this.conversionFactor,
    required this.isDefault,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  final int productId;

  final int fromUnitId;

  final int toUnitId;

  /// How many [toUnitId] one [fromUnitId] equals for this product.
  final double conversionFactor;

  /// Whether this is the product's default conversion.
  final bool isDefault;

  final String? description;

  final bool isActive;

  final DateTime createdAt;

  final DateTime updatedAt;
}
