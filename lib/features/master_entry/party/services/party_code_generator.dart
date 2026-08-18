import 'package:retail_erp/core/database/app_database.dart' as db;

/// Generates sequential, human-readable party codes.
///
/// Codes follow the `CUS00001` / `SUP00001` pattern and are derived from the
/// highest existing numeric suffix, so codes never collide with manually
/// entered codes that use a different format. The generator must run inside
/// the same transaction as the row insert (the repositories do this) so two
/// rapid creates can never compute the same code; the unique column
/// constraint is the final safety net.
abstract final class PartyCodeGenerator {
  /// Zero-padded numeric width, e.g. `CUS00001`.
  static const int suffixLength = 5;

  /// Returns the next code, e.g. `CUS00001`, for the given [table]/[column]
  /// pair and [prefix]. The identifiers are internal constants only.
  static Future<String> nextCode(
    db.AppDatabase database, {
    required String table,
    required String column,
    required String prefix,
  }) async {
    final row = await database
        .customSelect(
          "SELECT COALESCE(MAX(CAST(SUBSTR($column, ${prefix.length + 1}) "
          'AS INTEGER)), 0) + 1 AS next '
          "FROM $table WHERE $column LIKE '$prefix%'",
        )
        .getSingle();
    final next = row.read<int>('next');
    return '$prefix${next.toString().padLeft(suffixLength, '0')}';
  }
}
