import 'package:retail_erp/core/database/app_database.dart' as db;

/// Generates sequential, human-readable sub-category codes.
///
/// Codes follow the `SUB-####` pattern and are derived from the highest
/// existing numeric suffix, so codes never collide with manually entered
/// codes that use a different format.
class SubCategoryCodeGenerator {
  const SubCategoryCodeGenerator._();

  static const String prefix = 'SUB-';

  static const int _suffixLength = 4;

  /// Returns the next code, e.g. `SUB-0001`.
  static Future<String> nextCode(db.AppDatabase database) async {
    final row = await database
        .customSelect(
          "SELECT COALESCE(MAX(CAST(SUBSTR(sub_category_code, ${prefix.length + 1}) "
          'AS INTEGER)), 0) + 1 AS next '
          "FROM sub_category WHERE sub_category_code LIKE '$prefix%'",
        )
        .getSingle();
    final next = row.read<int>('next');
    return '$prefix${next.toString().padLeft(_suffixLength, '0')}';
  }
}
