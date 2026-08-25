/// Which field caused a duplicate constraint violation.
enum ProductDuplicateField {
  productCode('productCode'),
  productName('productName'),
  variantName('variantName'),
  barcode('barcode');

  const ProductDuplicateField(this.formField);

  /// Key used in the form-level error map.
  final String formField;
}

/// Thrown when creating or updating a product with a code or barcode that already exists.
class ProductDuplicateException implements Exception {
  const ProductDuplicateException(this.field);

  final ProductDuplicateField field;

  String get message => switch (field) {
    ProductDuplicateField.productCode =>
      'A product with this code already exists.',
    ProductDuplicateField.productName =>
      'A product with this name already exists.',
    ProductDuplicateField.variantName =>
      'This variant already exists for this product.',
    ProductDuplicateField.barcode =>
      'A product or variant with this barcode already exists.',
  };
}

/// Thrown when a product is not found by its id.
class ProductNotFoundException implements Exception {
  const ProductNotFoundException(this.id);

  final int id;

  String get message => 'Product with id $id was not found.';
}

/// Thrown when a variant is not found by its id.
class ProductVariantNotFoundException implements Exception {
  const ProductVariantNotFoundException(this.id);

  final int id;

  String get message => 'Product variant with id $id was not found.';
}

/// Thrown when attempting to delete a product that is referenced by
/// transactions (sales invoices, etc.).
class ProductInUseException implements Exception {
  const ProductInUseException();

  String get message =>
      'This product is referenced by transactions and cannot be deleted.';
}
