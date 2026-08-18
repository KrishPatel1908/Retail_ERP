/// The field that collided with an existing supplier during a create/update.
enum SupplierDuplicateField {
  gstNumber('gst'),
  email('email');

  const SupplierDuplicateField(this.formField);

  /// Key of the form field the error should be shown under.
  final String formField;
}

/// Thrown when a supplier with the same GST number or email already exists.
class SupplierDuplicateException implements Exception {
  const SupplierDuplicateException(this.field);

  final SupplierDuplicateField field;

  String get message => switch (field) {
    SupplierDuplicateField.gstNumber =>
      'A supplier with this GST number already exists.',
    SupplierDuplicateField.email =>
      'A supplier with this email already exists.',
  };

  @override
  String toString() => 'SupplierDuplicateException: $message';
}

/// Thrown when an update or delete targets a supplier that no longer exists.
class SupplierNotFoundException implements Exception {
  const SupplierNotFoundException(this.id);

  final int id;

  String get message => 'Supplier with id $id was not found.';

  @override
  String toString() => 'SupplierNotFoundException: $message';
}

/// Thrown when a delete is rejected because the supplier is referenced by
/// transactions (purchases, payments, ledger).
class SupplierInUseException implements Exception {
  const SupplierInUseException();

  String get message =>
      'This record is already used in transactions and cannot be deleted.';

  @override
  String toString() => 'SupplierInUseException: $message';
}
