/// Validation rules for the product form and variants.
abstract final class ProductValidator {
  static String? validateName(String value) {
    if (value.trim().isEmpty) return 'Product name is required.';
    if (value.trim().length > 200) return 'Product name is too long.';
    return null;
  }

  static String? validateProductCode(String value) {
    if (value.trim().isEmpty) return null; // Optional field
    if (value.trim().length > 30) return 'Product code is too long.';
    return null;
  }

  static String? validateSellingPrice(String value) {
    if (value.trim().isEmpty) return 'Selling price is required.';
    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
    if (parsed == null) return 'Please enter a valid price.';
    if (parsed < 0) return 'Selling price must be 0 or more.';
    return null;
  }

  /// Validates selling price for the parent product.
  static String? validateParentSellingPrice(
    String value, {
    bool hasVariants = false,
  }) {
    return validateSellingPrice(value);
  }

  static String? validateNotes(String value) {
    if (value.trim().isEmpty) return null; // Optional field
    if (value.trim().length > 1000) return 'Notes are too long.';
    return null;
  }

  static String? validateVariantName(String value) {
    if (value.trim().isEmpty) return 'Variant name is required.';
    if (value.trim().length > 200) return 'Variant name is too long.';
    return null;
  }

  static String? validateVariantSellingPrice(String value) {
    if (value.trim().isEmpty) return 'Selling price is required.';
    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
    if (parsed == null) return 'Please enter a valid price.';
    if (parsed < 0) return 'Selling price must be 0 or more.';
    return null;
  }

  /// Validates that variant names are unique within the list.
  static String? validateVariantNamesUnique(List<String> names) {
    final trimmed = names.map((n) => n.trim().toLowerCase()).toList();
    final seen = <String>{};
    for (final name in trimmed) {
      if (name.isEmpty) continue;
      if (!seen.add(name)) {
        return 'Duplicate variant names are not allowed.';
      }
    }
    return null;
  }

  /// Parse a rupee amount string to paise (int).
  static int? parseRupeesToPaise(String input) {
    final normalized = input.trim().replaceAll(',', '');
    if (normalized.isEmpty) return null;
    final match = RegExp(r'^(\d+)(\.(\d{1,2}))?$').firstMatch(normalized);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final decimal = match.group(3);
    final paise = decimal == null ? 0 : int.parse(decimal.padRight(2, '0'));
    return rupees * 100 + paise;
  }

  /// Format paise (int) to a rupee string for display.
  static String formatPaise(int paise) {
    final rupees = paise / 100;
    if (rupees == rupees.roundToDouble()) return rupees.round().toString();
    return rupees.toStringAsFixed(2);
  }

  /// Format paise as currency for the table/detail view.
  static String formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}
