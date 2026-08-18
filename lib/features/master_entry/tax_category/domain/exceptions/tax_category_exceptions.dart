/// Thrown when attempting to create or update a tax category with a name
/// that already exists in the database.
class TaxCategoryAlreadyExistsException implements Exception {
  const TaxCategoryAlreadyExistsException(this.name);

  final String name;

  String get message => 'A tax category named "$name" already exists.';

  @override
  String toString() => message;
}

/// Thrown when attempting to update or delete a tax category that no longer
/// exists in the database.
class TaxCategoryNotFoundException implements Exception {
  const TaxCategoryNotFoundException(this.id);

  final int id;

  String get message => 'Tax category with id $id was not found.';

  @override
  String toString() => message;
}

/// Thrown when attempting to delete a tax category that is assigned to one or
/// more products in the database.
class TaxCategoryInUseException implements Exception {
  const TaxCategoryInUseException([
    this.message =
        'Cannot delete tax category because it is assigned to one or more products.',
  ]);

  final String message;

  @override
  String toString() => message;
}
