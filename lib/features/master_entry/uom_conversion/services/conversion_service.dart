import '../data/repositories/uom_conversion_repository.dart';

/// Thrown when no conversion (product-specific or global) links two units.
class ConversionNotFoundException implements Exception {
  const ConversionNotFoundException();

  String get message => 'No conversion found between selected units.';

  @override
  String toString() => 'ConversionNotFoundException: $message';
}

/// Resolves unit conversions with the approved priority:
///
/// 1. **Product UOM** — a conversion defined for this specific product.
/// 2. **Global UOM** — a universal conversion from [UomConversionRepository].
/// 3. Otherwise throw [ConversionNotFoundException] with a friendly message.
///
/// The product-specific lookup is injected as [productLookup] so this module
/// stays independent of Product Master: when Product Master ships, it will
/// pass its own repository here.
class ConversionService {
  ConversionService({required this.uomRepository, this.productLookup});

  final UomConversionRepository uomRepository;

  /// Prepared seam for Product UOM. Returns the product conversion factor
  /// (both directions), or `null` when the product has no such conversion.
  final Future<double?> Function(
    int productId,
    int fromUnitId,
    int toUnitId,
  )? productLookup;

  /// Converts [quantity] from [fromUnitId] to [toUnitId].
  ///
  /// When [productId] is provided the product-specific conversion is
  /// consulted first. Throws [ConversionNotFoundException] when neither a
  /// product nor a global conversion exists.
  Future<double> convert({
    int? productId,
    required int fromUnitId,
    required int toUnitId,
    required double quantity,
  }) async {
    if (productId != null && productLookup != null) {
      final productFactor = await productLookup!(
        productId,
        fromUnitId,
        toUnitId,
      );
      if (productFactor != null) return quantity * productFactor;
    }

    final globalFactor = await uomRepository.resolveFactor(
      fromUnitId,
      toUnitId,
    );
    if (globalFactor != null) return quantity * globalFactor;

    throw const ConversionNotFoundException();
  }
}
