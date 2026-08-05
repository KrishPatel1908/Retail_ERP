import 'package:drift/drift.dart';

import '../app_database.dart';
import 'database_indexes.dart';
import 'migration_step.dart';

/// Schema v2 — the measurement-system redesign.
///
/// 1. `uom_conversion` gains an optional `description` column, and the old
///    family-base relationships (`base_unit_id` / `factor_to_base`) are
///    backfilled into it before the columns are dropped — so a v1 database
///    keeps "1 Dozen = 12 Piece" style conversions after upgrading.
/// 2. `unit` is rebuilt without `unit_code`, `base_unit_id` and
///    `factor_to_base` and with a new `description` column. The old CHECK
///    constraints reference the dropped columns, so the table must be
///    recreated rather than altered.
/// 3. `product_uom` is rebuilt to `(product_id, from_unit_id, to_unit_id,
///    conversion_factor, is_default, description, ...)`. Old rows are
///    discarded — Product Master is not implemented yet, so the table is
///    guaranteed empty in every existing database.
/// 4. Indexes for the rebuilt tables are recreated from the shared
///    [DatabaseIndexes] registry.
///
/// Note: upgraders keep their units and conversions but do not receive the
/// seed data added in v2 (Area/Time units and the new reference
/// conversions) — the seeder only runs on fresh creates.
const MigrationStep upgradeToV2 = _upgradeToV2;

Future<void> _upgradeToV2(Migrator migrator, AppDatabase database) async {
  // 1. Conversions gain an optional description; preserve the old
  //    family-base relationships as explicit conversion rows first.
  await migrator.addColumn(
    database.uomConversions,
    database.uomConversions.description,
  );
  await database.customStatement(
    'INSERT OR IGNORE INTO uom_conversion '
    '(from_unit_id, to_unit_id, conversion_factor, created_at, updated_at) '
    'SELECT id, base_unit_id, factor_to_base, created_at, updated_at '
    'FROM unit WHERE base_unit_id IS NOT NULL',
  );

  // 2. Rebuild the unit table.
  await database.customStatement(
    'CREATE TABLE unit_v2 ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'unit_name TEXT NOT NULL, '
    'unit_symbol TEXT NOT NULL, '
    "unit_family TEXT NOT NULL DEFAULT 'GENERAL', "
    'description TEXT, '
    'is_active INTEGER NOT NULL DEFAULT 1, '
    "created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')), "
    "updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')))",
  );
  await database.customStatement(
    'INSERT INTO unit_v2 (id, unit_name, unit_symbol, unit_family, '
    'description, is_active, created_at, updated_at) '
    'SELECT id, unit_name, unit_symbol, unit_family, NULL, is_active, '
    'created_at, updated_at FROM unit',
  );
  await database.customStatement('DROP TABLE unit');
  await database.customStatement('ALTER TABLE unit_v2 RENAME TO unit');

  // 3. Rebuild the product_uom table with its final shape.
  await database.customStatement('DROP TABLE product_uom');
  await database.customStatement(
    'CREATE TABLE product_uom ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'product_id INTEGER NOT NULL REFERENCES product (id), '
    'from_unit_id INTEGER NOT NULL REFERENCES unit (id), '
    'to_unit_id INTEGER NOT NULL REFERENCES unit (id), '
    'conversion_factor REAL NOT NULL, '
    'is_default INTEGER NOT NULL DEFAULT 0, '
    'description TEXT, '
    'is_active INTEGER NOT NULL DEFAULT 1, '
    "created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')), "
    "updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')), "
    'CONSTRAINT product_uom_unique UNIQUE '
    '(product_id, from_unit_id, to_unit_id, conversion_factor), '
    'CHECK (from_unit_id <> to_unit_id), '
    'CHECK (conversion_factor > 0))',
  );

  // 4. Recreate the indexes for the rebuilt tables (idempotent).
  await DatabaseIndexes.createForTables(database, {'unit', 'product_uom'});
}
