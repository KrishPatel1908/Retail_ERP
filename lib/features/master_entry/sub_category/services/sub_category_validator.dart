/// Pure validation rules for the sub-category form.
///
/// Values are trimmed before they are checked; the same rules apply to both
/// the create and edit flows. Returns `null` when the value is valid.
abstract final class SubCategoryValidator {
  static const int maxNameLength = 100;
  static const int maxCodeLength = 50;
  static const int maxDescriptionLength = 500;

  static String? validateCategory(int? categoryId) {
    if (categoryId == null || categoryId <= 0) {
      return 'Category is required.';
    }
    return null;
  }

  static String? validateName(String value) {
    final name = value.trim();
    if (name.isEmpty) {
      return 'Sub Category name is required.';
    }
    if (name.length > maxNameLength) {
      return 'Sub Category name must be $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? validateCode(String? value) {
    if (value == null) return null;
    final code = value.trim();
    if (code.isNotEmpty && code.length > maxCodeLength) {
      return 'Code must be $maxCodeLength characters or fewer.';
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
