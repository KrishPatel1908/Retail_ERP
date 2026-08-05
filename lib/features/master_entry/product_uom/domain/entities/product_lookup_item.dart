/// Lightweight product item for dropdown pickers.
class ProductLookupItem {
  const ProductLookupItem({
    required this.id,
    required this.productCode,
    required this.productName,
  });

  final int id;
  final String productCode;
  final String productName;
}
