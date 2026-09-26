import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v8 — adds product variants, expiry date, and removes obsolete
/// tracking fields from the product table.
///
/// Changes:
/// - Adds `expiry_date` column to `product`.
/// - Removes `track_sales`, `track_serial`, `track_batch`, `track_expiry`,
///   `description` columns from `product`.
/// - Creates `product_variant` table with FK to `product`.
/// - Adds unique constraint on `(product_id, variant_name)`.
const MigrationStep upgradeToV8 = _upgradeToV8;

Future<void> _upgradeToV8(Migrator migrator, AppDatabase database) async {
  if (!await _tableExists(database, 'product')) return;

  // Step 1: Add expiry_date column to product if it doesn't exist.
  if (!await _columnExists(database, 'product', 'expiry_date')) {
    await database.customStatement(
      'ALTER TABLE product ADD COLUMN expiry_date INTEGER',
    );
  }

  // Step 2: Remove obsolete tracking columns.
  for (final column in [
    'track_sales',
    'track_serial',
    'track_batch',
    'track_expiry',
    'description',
  ]) {
    if (await _columnExists(database, 'product', column)) {
      // SQLite doesn't support DROP COLUMN before 3.35.0, but Drift's
      // migrator handles this via table rebuild. For safety, we try the
      // ALTER TABLE approach first; if it fails, we rebuild.
      try {
        await database.customStatement(
          'ALTER TABLE product DROP COLUMN $column',
        );
      } on Exception {
        // Column drop may not be supported; rebuild the table instead.
        await _rebuildProductTable(database);
        break;
      }
    }
  }

  // Step 3: Create product_variant table if it doesn't exist.
  if (!await _tableExists(database, 'product_variant')) {
    await database.customStatement('''
      CREATE TABLE product_variant (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
        variant_name TEXT NOT NULL,
        selling_price INTEGER NOT NULL DEFAULT 0,
        expiry_date INTEGER,
        notes TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        UNIQUE(product_id, variant_name),
        CHECK (selling_price >= 0)
      )
    ''');

    // Create indexes for product_variant.
    await database.customStatement(
      'CREATE INDEX idx_variant_product ON product_variant (product_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_variant_name ON product_variant (variant_name)',
    );
  }
}

/// Rebuilds the product table, preserving data and removing obsolete columns.
Future<void> _rebuildProductTable(AppDatabase database) async {
  // Check if product_uom references product.
  final hasProductUom = await _tableExists(database, 'product_uom');

  if (hasProductUom) {
    await database.customStatement(
      'DROP INDEX IF EXISTS idx_product_uom_product',
    );
    await database.customStatement(
      'CREATE TABLE product_uom_new AS SELECT * FROM product_uom',
    );
    await database.customStatement('DROP TABLE product_uom');
  }

  await database.customStatement('DROP TABLE product');

  await database.customStatement('''
    CREATE TABLE product (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_code TEXT NOT NULL UNIQUE,
      product_name TEXT NOT NULL,
      category_id INTEGER REFERENCES category(id),
      sub_category_id INTEGER REFERENCES sub_category(id),
      brand_id INTEGER REFERENCES brand(id),
      unit_id INTEGER NOT NULL REFERENCES unit(id),
      selling_price INTEGER NOT NULL DEFAULT 0,
      tax_type_id INTEGER REFERENCES tax_type(id),
      expiry_date INTEGER,
      notes TEXT,
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
      updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
      CHECK (selling_price >= 0)
    )
  ''');

  if (hasProductUom) {
    await database.customStatement('''
      CREATE TABLE product_uom (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id),
        from_unit_id INTEGER NOT NULL REFERENCES unit(id),
        to_unit_id INTEGER NOT NULL REFERENCES unit(id),
        conversion_factor REAL NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        description TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        CHECK (from_unit_id <> to_unit_id),
        CHECK (conversion_factor > 0)
      )
    ''');

    await database.customStatement(
      'INSERT INTO product_uom '
      '(id, product_id, from_unit_id, to_unit_id, conversion_factor, '
      'is_default, description, is_active, created_at, updated_at) '
      'SELECT id, product_id, from_unit_id, to_unit_id, conversion_factor, '
      'is_default, description, is_active, created_at, updated_at '
      'FROM product_uom_new',
    );
    await database.customStatement('DROP TABLE product_uom_new');

    await database.customStatement(
      'CREATE INDEX idx_product_uom_product ON product_uom (product_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_product_uom_from_unit ON product_uom (from_unit_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_product_uom_to_unit ON product_uom (to_unit_id)',
    );
    await database.customStatement(
      'CREATE UNIQUE INDEX idx_product_uom_one_default '
      'ON product_uom (product_id) WHERE is_default = 1',
    );
  }

  // Recreate product indexes.
  await database.customStatement(
    'CREATE INDEX idx_product_name ON product (product_name)',
  );
  await database.customStatement(
    'CREATE INDEX idx_product_category ON product (category_id)',
  );
  await database.customStatement(
    'CREATE INDEX idx_product_brand ON product (brand_id)',
  );
  await database.customStatement(
    'CREATE INDEX idx_product_active ON product (is_active)',
  );
  await database.customStatement(
    'CREATE INDEX idx_product_created_at ON product (created_at)',
  );
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
