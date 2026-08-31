import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v12 — wire Product Master to Tax Categories.
///
/// Products now reference a [TaxCategories] row (`tax_category_id`) instead of
/// an atomic Tax Type, so the Product Master can pick a tax profile (e.g.
/// "GST 18%") whose configured total % feeds Purchase Entry automatically.
///
/// It also repairs the seeded `tax_category_rate` reference data. The original
/// seed stored every GST category with an IGST component alongside equal
/// CGST+SGST components (e.g. GST 18% = 9 + 9 + 18), which made
/// "sum of components" double-count (36% instead of 18%). Removing the IGST
/// row for each seeded category leaves CGST + SGST, whose sum equals the
/// intended total (Tax Free 0, GST 5/12/18/28). Only the seeded reference rows
/// (category ids 1–5 from the seeder) are touched — user-created categories
/// already store the correct CGST+SGST shape.
const MigrationStep upgradeToV12 = _upgradeToV12;

Future<void> _upgradeToV12(Migrator migrator, AppDatabase database) async {
  // Step 1: Add the tax_category_id column to product.
  if (await _tableExists(database, 'product')) {
    final hasColumn = await _columnExists(
      database,
      'product',
      'tax_category_id',
    );
    if (!hasColumn) {
      await migrator.addColumn(
        database.products,
        database.products.taxCategoryId,
      );
    }
  }

  // Step 2: Repair the seeded tax_category_rate reference rows so each seeded
  // category's components CGST + SGST sum to its intended total.
  //
  // Seeded categories are ids 1..5; their IGST (tax_type_id = 4) component is
  // redundant because it duplicates the CGST+SGST combined total.
  if (await _tableExists(database, 'tax_category_rate')) {
    await database.customStatement(
      'DELETE FROM tax_category_rate '
      'WHERE tax_category_id BETWEEN 1 AND 5 AND tax_type_id = 4',
    );
  }
}

Future<bool> _tableExists(AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = '$tableName'",
      )
      .get();
  return rows.isNotEmpty;
}

Future<bool> _columnExists(
  AppDatabase database,
  String tableName,
  String columnName,
) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM pragma_table_info('$tableName') "
        "WHERE name = '$columnName'",
      )
      .get();
  return rows.isNotEmpty;
}
