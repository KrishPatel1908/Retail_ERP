import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v10 — adds purchase_price, mrp, wholesale_price, barcode, and hsn_code
/// to product and product_variant tables.
///
/// Changes:
/// - Adds `purchase_price`, `mrp`, `wholesale_price`, `barcode`, `hsn_code` columns to `product`.
/// - Adds `purchase_price`, `mrp`, `wholesale_price`, `barcode`, `hsn_code` columns to `product_variant`.
/// - Creates indexes for barcode lookups.
const MigrationStep upgradeToV10 = _upgradeToV10;

Future<void> _upgradeToV10(Migrator migrator, AppDatabase database) async {
  // Step 1: Add columns to product table.
  if (await _tableExists(database, 'product')) {
    if (!await _columnExists(database, 'product', 'purchase_price')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN purchase_price INTEGER',
      );
    }
    if (!await _columnExists(database, 'product', 'mrp')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN mrp INTEGER',
      );
    }
    if (!await _columnExists(database, 'product', 'wholesale_price')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN wholesale_price INTEGER',
      );
    }
    if (!await _columnExists(database, 'product', 'barcode')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN barcode TEXT',
      );
    }
    if (!await _columnExists(database, 'product', 'hsn_code')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN hsn_code TEXT',
      );
    }

    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_product_barcode ON product (barcode)',
    );
    await database.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_product_barcode_unique '
      'ON product (barcode) WHERE barcode IS NOT NULL AND barcode != \'\'',
    );
  }

  // Step 2: Add columns to product_variant table.
  if (await _tableExists(database, 'product_variant')) {
    if (!await _columnExists(database, 'product_variant', 'purchase_price')) {
      await database.customStatement(
        'ALTER TABLE product_variant ADD COLUMN purchase_price INTEGER',
      );
    }
    if (!await _columnExists(database, 'product_variant', 'mrp')) {
      await database.customStatement(
        'ALTER TABLE product_variant ADD COLUMN mrp INTEGER',
      );
    }
    if (!await _columnExists(database, 'product_variant', 'wholesale_price')) {
      await database.customStatement(
        'ALTER TABLE product_variant ADD COLUMN wholesale_price INTEGER',
      );
    }
    if (!await _columnExists(database, 'product_variant', 'barcode')) {
      await database.customStatement(
        'ALTER TABLE product_variant ADD COLUMN barcode TEXT',
      );
    }
    if (!await _columnExists(database, 'product_variant', 'hsn_code')) {
      await database.customStatement(
        'ALTER TABLE product_variant ADD COLUMN hsn_code TEXT',
      );
    }

    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_variant_barcode ON product_variant (barcode)',
    );
    await database.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_variant_barcode_unique '
      'ON product_variant (barcode) WHERE barcode IS NOT NULL AND barcode != \'\'',
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
      .customSelect("SELECT name FROM pragma_table_info('$tableName')")
      .get();
  return rows.any((row) => row.read<String>('name') == columnName);
}
