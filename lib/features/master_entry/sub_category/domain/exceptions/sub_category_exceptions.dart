/// Thrown when a sub-category with the same name (case-insensitive) already
/// exists under the specified category.
class SubCategoryAlreadyExistsException implements Exception {
  const SubCategoryAlreadyExistsException(this.name, [this.categoryName]);

  final String name;
  final String? categoryName;

  String get message => categoryName != null
      ? 'A sub-category named "$name" already exists under category "$categoryName".'
      : 'A sub-category named "$name" already exists under this category.';

  @override
  String toString() => 'SubCategoryAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a sub-category that no longer exists.
class SubCategoryNotFoundException implements Exception {
  const SubCategoryNotFoundException(this.id);

  final int id;

  String get message => 'Sub-category with id $id was not found.';

  @override
  String toString() => 'SubCategoryNotFoundException: $message';
}

/// Thrown when a delete is rejected because other records (e.g. products)
/// still reference the sub-category.
class SubCategoryInUseException implements Exception {
  const SubCategoryInUseException();

  String get message =>
      'This Sub Category is currently used by products and cannot be deleted.';

  @override
  String toString() => 'SubCategoryInUseException: $message';
}
