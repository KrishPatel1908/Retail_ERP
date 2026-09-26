import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v11 — removes the deferred multi-warehouse feature.
///
/// The single-location build never populated warehouses: the `warehouse_id`
/// columns on `inventory_transaction` and `current_stock` were always NULL and
/// the `warehouse` table was always empty. This step rebuilds both tables
/// without their `warehouse_id` column (preserving every existing row) and then
/// drops the obsolete `warehouse` table and its unique index.
///
/// Rebuilds follow the project's proven raw-SQL pattern (create `*_new`, copy
/// data, drop old, rename, recreate indexes). Foreign-key enforcement is off
/// during migrations, so rebuilding the referencing tables before dropping
/// `warehouse` is safe. Every step is guarded so the migration is a no-op on
/// older schemas (pre-v9) that never had these tables.
const MigrationStep upgradeToV11 = _upgradeToV11;

Future<void> _upgradeToV11(Migrator migrator, AppDatabase database) async {
  // Step 1: Rebuild inventory_transaction without warehouse_id.
  if (await _tableExists(database, 'inventory_transaction')) {
    for (final index in [
      'idx_inv_txn_product_variant',
      'idx_inv_txn_type',
      'idx_inv_txn_date',
      'idx_inv_txn_purchase',
    ]) {
      await database.customStatement('DROP INDEX IF EXISTS $index');
    }

    await database.customStatement(
      'DROP TABLE IF EXISTS inventory_transaction_new',
    );
    await database.customStatement('''
      CREATE TABLE inventory_transaction_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        transaction_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        purchase_id INTEGER REFERENCES purchase(id),
        transaction_date INTEGER NOT NULL,
        reference_number TEXT,
        notes TEXT,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    await database.customStatement(
      'INSERT INTO inventory_transaction_new '
      '(id, product_id, variant_id, transaction_type, quantity, purchase_id, '
      'transaction_date, reference_number, notes, created_at) '
      'SELECT id, product_id, variant_id, transaction_type, quantity, purchase_id, '
      'transaction_date, reference_number, notes, created_at '
      'FROM inventory_transaction',
    );

    await database.customStatement('DROP TABLE inventory_transaction');
    await database.customStatement(
      'ALTER TABLE inventory_transaction_new RENAME TO inventory_transaction',
    );

    await database.customStatement(
      'CREATE INDEX idx_inv_txn_product_variant '
      'ON inventory_transaction (product_id, variant_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_inv_txn_type ON inventory_transaction (transaction_type)',
    );
    await database.customStatement(
      'CREATE INDEX idx_inv_txn_date ON inventory_transaction (transaction_date)',
    );
    await database.customStatement(
      'CREATE INDEX idx_inv_txn_purchase ON inventory_transaction (purchase_id)',
    );
  }

  // Step 2: Rebuild current_stock without warehouse_id.
  //
  // The new table drops the inline UNIQUE(product_id, variant_id) constraint in
  // favour of a unique index, matching the fresh-create schema so upgraded and
  // freshly-created databases converge on an identical shape.
  if (await _tableExists(database, 'current_stock')) {
    await database.customStatement(
      'DROP INDEX IF EXISTS idx_stock_product_variant',
    );

    await database.customStatement('DROP TABLE IF EXISTS current_stock_new');
    await database.customStatement('''
      CREATE TABLE current_stock_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        quantity INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    await database.customStatement(
      'INSERT INTO current_stock_new '
      '(id, product_id, variant_id, quantity, updated_at) '
      'SELECT id, product_id, variant_id, quantity, updated_at '
      'FROM current_stock',
    );

    await database.customStatement('DROP TABLE current_stock');
    await database.customStatement(
      'ALTER TABLE current_stock_new RENAME TO current_stock',
    );

    await database.customStatement(
      'CREATE UNIQUE INDEX idx_stock_product_variant '
      'ON current_stock (product_id, variant_id)',
    );
  }

  // Step 3: Drop the obsolete warehouse table and its index.
  await database.customStatement(
    'DROP INDEX IF EXISTS idx_warehouse_name_nocase_unique',
  );
  await database.customStatement('DROP TABLE IF EXISTS warehouse');
}

Future<bool> _tableExists(AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = '$tableName'",
      )
      .get();
  return rows.isNotEmpty;
}
