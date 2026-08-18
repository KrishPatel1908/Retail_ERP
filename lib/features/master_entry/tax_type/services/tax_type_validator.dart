/// Pure validation rules for the tax type form.
///
/// Values are trimmed before they are checked; the same rules apply to both
/// the create and edit flows. Returns `null` when the value is valid.
abstract final class TaxTypeValidator {
  static const int maxNameLength = 100;

  static const int maxDescriptionLength = 500;

  static String? validateName(String value) {
    final name = value.trim();
    if (name.isEmpty) {
      return 'Tax type name is required.';
    }
    if (name.length > maxNameLength) {
      return 'Tax type name must be $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? validateDescription(String value) {
    if (value.trim().length > maxDescriptionLength) {
      return 'Description must be $maxDescriptionLength characters or fewer.';
    }
    return null;
  }
}
