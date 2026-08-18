/// The field that collided with an existing customer during a create/update.
enum CustomerDuplicateField {
  gstNumber('gst'),
  email('email');

  const CustomerDuplicateField(this.formField);

  /// Key of the form field the error should be shown under.
  final String formField;
}

/// Thrown when a customer with the same GST number or email already exists.
class CustomerDuplicateException implements Exception {
  const CustomerDuplicateException(this.field);

  final CustomerDuplicateField field;

  String get message => switch (field) {
    CustomerDuplicateField.gstNumber =>
      'A customer with this GST number already exists.',
    CustomerDuplicateField.email =>
      'A customer with this email already exists.',
  };

  @override
  String toString() => 'CustomerDuplicateException: $message';
}

/// Thrown when an update or delete targets a customer that no longer exists.
class CustomerNotFoundException implements Exception {
  const CustomerNotFoundException(this.id);

  final int id;

  String get message => 'Customer with id $id was not found.';

  @override
  String toString() => 'CustomerNotFoundException: $message';
}

/// Thrown when a delete is rejected because the customer is referenced by
/// transactions (invoices, sales, purchases, payments, ledger).
class CustomerInUseException implements Exception {
  const CustomerInUseException();

  String get message =>
      'This record is already used in transactions and cannot be deleted.';

  @override
  String toString() => 'CustomerInUseException: $message';
}
