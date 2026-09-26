import '../domain/entities/tax_category_component.dart';

/// Validation logic for Tax Category master fields and business rules.
class TaxCategoryValidator {
  TaxCategoryValidator._();

  /// Maximum character limit for tax category name.
  static const int maxNameLength = 100;

  /// Maximum character limit for description.
  static const int maxDescriptionLength = 500;

  /// Validates tax category name.
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Tax Category Name is required.';
    }
    final trimmed = name.trim();
    if (trimmed.length > maxNameLength) {
      return 'Tax Category Name cannot exceed $maxNameLength characters.';
    }
    return null;
  }

  /// Validates optional description.
  static String? validateDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return null;
    }
    final trimmed = description.trim();
    if (trimmed.length > maxDescriptionLength) {
      return 'Description cannot exceed $maxDescriptionLength characters.';
    }
    return null;
  }

  /// Validates a list of tax category components.
  static String? validateComponents(List<TaxCategoryComponent> components) {
    if (components.isEmpty) {
      return 'At least one Tax Component is required.';
    }

    final seenTaxTypeIds = <int>{};
    for (final component in components) {
      if (component.taxTypeId <= 0) {
        return 'Please select a valid Tax Type for all components.';
      }
      if (seenTaxTypeIds.contains(component.taxTypeId)) {
        return 'Duplicate Tax Type "${component.taxTypeName}" inside the same Tax Category is not allowed.';
      }
      seenTaxTypeIds.add(component.taxTypeId);

      if (component.percentage < 0) {
        return 'Percentage cannot be negative.';
      }
    }

    final totalPercentage = components.fold(
      0.0,
      (sum, c) => sum + c.percentage,
    );
    if (totalPercentage < 0 || totalPercentage > 100) {
      return 'Total tax percentage must be between 0% and 100%.';
    }

    return null;
  }

  /// Validates individual percentage value input.
  static String? validatePercentage(double? percentage) {
    if (percentage == null) {
      return 'Percentage is required.';
    }
    if (percentage < 0) {
      return 'Percentage cannot be negative.';
    }
    if (percentage > 100) {
      return 'Percentage cannot exceed 100%.';
    }
    return null;
  }
}
