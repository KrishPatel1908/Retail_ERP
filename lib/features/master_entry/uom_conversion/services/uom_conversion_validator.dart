/// Pure validation rules for the UOM Conversion form.
///
/// The same rules apply to both the create and edit flows. Returns `null`
/// when the value is valid.
abstract final class UomConversionValidator {
  static const int maxDescriptionLength = 500;

  static String? validateFromUnit(int? fromUnitId) {
    if (fromUnitId == null) return 'Please select a From unit.';
    return null;
  }

  static String? validateToUnit(int? toUnitId) {
    if (toUnitId == null) return 'Please select a To unit.';
    return null;
  }

  /// From and To units must not be the same unit.
  static String? validateDifferentUnits(int? fromUnitId, int? toUnitId) {
    if (fromUnitId != null && fromUnitId == toUnitId) {
      return 'From and To units must be different.';
    }
    return null;
  }

  /// The conversion factor must be a number greater than zero (the schema
  /// enforces `conversion_factor > 0`).
  static String? validateFactor(String value) {
    final factor = double.tryParse(value.trim());
    if (factor == null) {
      return 'Enter a valid number for the conversion factor.';
    }
    if (factor <= 0) {
      return 'Conversion factor must be greater than zero.';
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
