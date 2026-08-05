/// Pure validation rules for Product UOM Conversions.
abstract final class ProductUomValidator {
  /// Validates that a product is selected.
  static String? validateProduct(int? productId) {
    if (productId == null || productId <= 0) {
      return 'Product is required.';
    }
    return null;
  }

  /// Validates that a From Unit is selected.
  static String? validateFromUnit(int? fromUnitId) {
    if (fromUnitId == null || fromUnitId <= 0) {
      return 'From unit is required.';
    }
    return null;
  }

  /// Validates that a To Unit is selected.
  static String? validateToUnit(int? toUnitId) {
    if (toUnitId == null || toUnitId <= 0) {
      return 'To unit is required.';
    }
    return null;
  }

  /// Validates that From Unit and To Unit are not the same.
  static String? validateDifferentUnits(int? fromUnitId, int? toUnitId) {
    if (fromUnitId != null && toUnitId != null && fromUnitId == toUnitId) {
      return 'From and to units must be different.';
    }
    return null;
  }

  /// Validates the conversion factor text input.
  static String? validateFactor(String? text) {
    final trimmed = text?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Conversion factor is required.';
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return 'Conversion factor must be a valid number.';
    }
    if (parsed <= 0) {
      return 'Conversion factor must be greater than zero.';
    }
    return null;
  }

  /// Validates description length (optional).
  static String? validateDescription(String? text) {
    if (text != null && text.length > 250) {
      return 'Description cannot exceed 250 characters.';
    }
    return null;
  }
}
