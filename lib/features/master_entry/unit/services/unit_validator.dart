/// Pure validation rules for the unit form.
///
/// Values are trimmed before they are checked; the same rules apply to both
/// the create and edit flows. Returns `null` when the value is valid.
abstract final class UnitValidator {
  static const int maxNameLength = 100;

  static const int maxSymbolLength = 20;

  static const int maxDescriptionLength = 500;

  static String? validateName(String value) {
    final name = value.trim();
    if (name.isEmpty) {
      return 'Unit name is required.';
    }
    if (name.length > maxNameLength) {
      return 'Unit name must be $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? validateSymbol(String value) {
    final symbol = value.trim();
    if (symbol.isEmpty) {
      return 'Unit symbol is required.';
    }
    if (symbol.length > maxSymbolLength) {
      return 'Unit symbol must be $maxSymbolLength characters or fewer.';
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
