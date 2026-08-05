/// Thrown when a category with the same name (case-insensitive) already
/// exists in the database.
class CategoryAlreadyExistsException implements Exception {
  const CategoryAlreadyExistsException(this.name);

  final String name;

  String get message => 'A category named "$name" already exists.';

  @override
  String toString() => 'CategoryAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a category that no longer exists.
class CategoryNotFoundException implements Exception {
  const CategoryNotFoundException(this.id);

  final int id;

  String get message => 'Category with id $id was not found.';

  @override
  String toString() => 'CategoryNotFoundException: $message';
}

/// Thrown when a delete is rejected because other records (e.g.
/// sub-categories) still reference the category.
class CategoryInUseException implements Exception {
  const CategoryInUseException();

  String get message => 'This category is in use and cannot be deleted.';

  @override
  String toString() => 'CategoryInUseException: $message';
}
