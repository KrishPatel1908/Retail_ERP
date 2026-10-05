export 'package:retail_erp/features/inventory/domain/services/stock_service.dart'
    show InsufficientStockException, AmbiguousBarcodeException;

/// Thrown when a requested sale ID cannot be found.
class SaleNotFoundException implements Exception {
  const SaleNotFoundException(this.id);

  final int id;

  @override
  String toString() => 'SaleNotFoundException: Sale with ID $id was not found.';
}

/// Thrown when a sale payload or operation fails validation.
class SalesValidationException implements Exception {
  const SalesValidationException(this.message);

  final String message;

  @override
  String toString() => 'SalesValidationException: $message';
}
