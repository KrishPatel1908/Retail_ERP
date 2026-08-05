import 'package:retail_erp/core/database/app_database.dart' as db;

/// Generates sequential, human-readable category codes.
///
/// Codes follow the `CAT-####` pattern and are derived from the highest
/// existing numeric suffix, so codes never collide with manually entered
/// codes that use a different format.
class CategoryCodeGenerator {
  const CategoryCodeGenerator._();

  static const String prefix = 'CAT-';

  static const int _suffixLength = 4;

  /// Returns the next code, e.g. `CAT-0001`.
  static Future<String> nextCode(db.AppDatabase database) async {
    final row = await database
        .customSelect(
          "SELECT COALESCE(MAX(CAST(SUBSTR(category_code, ${prefix.length + 1}) "
          'AS INTEGER)), 0) + 1 AS next '
          "FROM category WHERE category_code LIKE '$prefix%'",
        )
        .getSingle();
    final next = row.read<int>('next');
    return '$prefix${next.toString().padLeft(_suffixLength, '0')}';
  }
}
