/// Thrown when a unit with the same name (case-insensitive) already exists
/// in the database.
class UnitAlreadyExistsException implements Exception {
  const UnitAlreadyExistsException(this.name);

  final String name;

  String get message => 'A unit named "$name" already exists.';

  @override
  String toString() => 'UnitAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a unit that no longer exists.
class UnitNotFoundException implements Exception {
  const UnitNotFoundException(this.id);

  final int id;

  String get message => 'Unit with id $id was not found.';

  @override
  String toString() => 'UnitNotFoundException: $message';
}

/// Thrown when a delete is rejected because other records (e.g. global UOM
/// conversions, product UOM conversions or products) still reference the
/// unit.
class UnitInUseException implements Exception {
  const UnitInUseException();

  String get message => 'This unit is in use by conversions or products and cannot be deleted.';

  @override
  String toString() => 'UnitInUseException: $message';
}
