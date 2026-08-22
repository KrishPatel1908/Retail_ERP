import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v7 — rebuilds the `product` table to a simplified design.
///
/// Removes inventory/purchase/warehouse columns and adds tracking flags
/// (track_sales, track_serial, track_batch, track_expiry) and notes.
/// Handles the case where `product_uom` may not yet exist (older test schemas).
const MigrationStep upgradeToV7 = _upgradeToV7;

Future<void> _upgradeToV7(Migrator migrator, AppDatabase database) async {
  if (!await _tableExists(database, 'product')) return;

  final hasProductUom = await _tableExists(database, 'product_uom');

  // Step 1: Drop old indexes on the product table.
  for (final index in [
    'idx_product_name',
    'idx_product_category',
    'idx_product_category_sub_category',
    'idx_product_brand',
    'idx_product_default_warehouse',
    'idx_product_active',
  ]) {
    await database.customStatement('DROP INDEX IF EXISTS $index');
  }

  // Step 2: If product_uom exists, save it and drop it (it references product).
  if (hasProductUom) {
    await database.customStatement('DROP INDEX IF EXISTS idx_product_uom_product');
    await database.customStatement('DROP INDEX IF EXISTS idx_product_uom_from_unit');
    await database.customStatement('DROP INDEX IF EXISTS idx_product_uom_to_unit');
    await database.customStatement('DROP INDEX IF EXISTS idx_product_uom_one_default');

    await database.customStatement('DROP TABLE IF EXISTS product_uom_new');
    await database.customStatement(
      'CREATE TABLE product_uom_new AS SELECT * FROM product_uom',
    );
    await database.customStatement('DROP TABLE product_uom');
  }

  // Step 3: Rebuild the product table with the simplified schema.
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
      track_sales INTEGER NOT NULL DEFAULT 1,
      track_serial INTEGER NOT NULL DEFAULT 0,
      track_batch INTEGER NOT NULL DEFAULT 0,
      track_expiry INTEGER NOT NULL DEFAULT 0,
      description TEXT,
      notes TEXT,
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
      updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
      CHECK (selling_price >= 0)
    )
  ''');

  // Step 4: Recreate product_uom with FK pointing to the new product table.
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

    // Copy data from old product_uom to new.
    await database.customStatement(
      'INSERT INTO product_uom '
      '(id, product_id, from_unit_id, to_unit_id, conversion_factor, '
      'is_default, description, is_active, created_at, updated_at) '
      'SELECT id, product_id, from_unit_id, to_unit_id, conversion_factor, '
      'is_default, description, is_active, created_at, updated_at '
      'FROM product_uom_new',
    );
    await database.customStatement('DROP TABLE product_uom_new');

    // Recreate product_uom indexes.
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

  // Step 5: Recreate product table indexes.
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
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
        variables: [Variable<String>(tableName)],
      )
      .get();
  return rows.isNotEmpty;
}


