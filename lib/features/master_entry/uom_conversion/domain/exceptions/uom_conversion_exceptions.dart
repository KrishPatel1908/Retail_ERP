/// Thrown when a conversion already exists between the same two units in
/// either direction. The reverse direction is derived automatically, so a
/// second row between the same pair is redundant.
class UomConversionAlreadyExistsException implements Exception {
  const UomConversionAlreadyExistsException();

  String get message =>
      'A conversion between these units already exists.';

  @override
  String toString() => 'UomConversionAlreadyExistsException: $message';
}

/// Thrown when an update or delete targets a conversion that no longer
/// exists.
class UomConversionNotFoundException implements Exception {
  const UomConversionNotFoundException(this.id);

  final int id;

  String get message => 'Conversion with id $id was not found.';

  @override
  String toString() => 'UomConversionNotFoundException: $message';
}
