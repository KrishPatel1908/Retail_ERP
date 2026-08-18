/// Thrown when a tax type with the same name (case-insensitive) already
/// exists in the database.
class TaxTypeAlreadyExistsException implements Exception {
  const TaxTypeAlreadyExistsException(this.name);

  final String name;

  String get message => 'A tax type named "$name" already exists.';

  @override
  String toString() => 'TaxTypeAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a tax type that no longer exists.
class TaxTypeNotFoundException implements Exception {
  const TaxTypeNotFoundException(this.id);

  final int id;

  String get message => 'Tax type with id $id was not found.';

  @override
  String toString() => 'TaxTypeNotFoundException: $message';
}

/// Thrown when a delete is rejected because other records (e.g. tax category
/// rates or products) still reference the tax type.
class TaxTypeInUseException implements Exception {
  const TaxTypeInUseException();

  String get message =>
      'This tax type is currently in use and cannot be deleted.';

  @override
  String toString() => 'TaxTypeInUseException: $message';
}
