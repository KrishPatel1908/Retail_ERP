/// Thrown when a brand with the same name (case-insensitive) already
/// exists in the database.
class BrandAlreadyExistsException implements Exception {
  const BrandAlreadyExistsException(this.name);

  final String name;

  String get message => 'A brand named "$name" already exists.';

  @override
  String toString() => 'BrandAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a brand that no longer exists.
class BrandNotFoundException implements Exception {
  const BrandNotFoundException(this.id);

  final int id;

  String get message => 'Brand with id $id was not found.';

  @override
  String toString() => 'BrandNotFoundException: $message';
}

/// Thrown when a delete is rejected because one or more products reference
/// the brand.
class BrandInUseException implements Exception {
  const BrandInUseException();

  String get message =>
      'This brand is currently in use by one or more products and cannot be deleted.';

  @override
  String toString() => 'BrandInUseException: $message';
}
