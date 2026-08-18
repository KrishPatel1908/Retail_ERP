import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v3 — removes the HSN master table and `product.hsn_id`.
const MigrationStep upgradeToV3 = _upgradeToV3;

Future<void> _upgradeToV3(Migrator migrator, AppDatabase database) async {
  final productExists = await _tableExists(database, 'product');
  if (productExists && await _columnExists(database, 'product', 'hsn_id')) {
    await database.customStatement('DROP INDEX IF EXISTS idx_product_hsn');
    await database.customStatement('ALTER TABLE product DROP COLUMN hsn_id');
  }

  await database.customStatement('DROP TABLE IF EXISTS hsn_master');
}

Future<bool> _tableExists(AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
        variables: [Variable<String>(tableName)],
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
      .customSelect("SELECT name FROM pragma_table_info('$tableName')")
      .get();
  return rows.any((row) => row.read<String>('name') == columnName);
}
