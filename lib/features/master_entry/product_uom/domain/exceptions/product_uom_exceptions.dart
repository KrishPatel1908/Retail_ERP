/// Thrown when an exact duplicate conversion — same product, same from
/// unit, same to unit and same factor — already exists.
class ProductUomAlreadyExistsException implements Exception {
  const ProductUomAlreadyExistsException();

  String get message =>
      'An identical conversion already exists for this product.';

  @override
  String toString() => 'ProductUomAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a conversion that no longer
/// exists.
class ProductUomNotFoundException implements Exception {
  const ProductUomNotFoundException(this.id);

  final int id;

  String get message => 'Product conversion with id $id was not found.';

  @override
  String toString() => 'ProductUomNotFoundException: $message';
}
