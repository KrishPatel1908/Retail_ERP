import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v13 — append-only financial history for purchases.
///
/// Existing purchases are seeded with one opening event, which represents the
/// latest persisted state. Later edits append deltas rather than modifying it.
const MigrationStep upgradeToV13 = _upgradeToV13;

Future<void> _upgradeToV13(Migrator migrator, AppDatabase database) async {
  if (await _tableExists(database, 'purchase_transaction')) return;

  await database.customStatement('''
    CREATE TABLE purchase_transaction (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      purchase_id INTEGER NOT NULL REFERENCES purchase(id) ON DELETE CASCADE,
      supplier_id INTEGER NOT NULL REFERENCES supplier(id),
      credit INTEGER NOT NULL DEFAULT 0,
      debit INTEGER NOT NULL DEFAULT 0,
      running_total INTEGER NOT NULL,
      transaction_date INTEGER NOT NULL,
      note TEXT,
      created_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
    )
  ''');
  await database.customStatement(
    'CREATE INDEX idx_purchase_transaction_purchase_date '
    'ON purchase_transaction (purchase_id, transaction_date)',
  );
  await database.customStatement(
    'CREATE INDEX idx_purchase_transaction_supplier_date '
    'ON purchase_transaction (supplier_id, transaction_date)',
  );

  // A pre-v13 database has only the latest purchase state. Preserve that
  // state as one opening event; previous detail cannot be inferred safely.
  await database.customStatement('''
    INSERT INTO purchase_transaction
      (purchase_id, supplier_id, credit, debit, running_total,
       transaction_date, note)
    SELECT id, supplier_id, total, paid_amount, paid_amount - total,
           purchase_date, notes
    FROM purchase
    WHERE is_return = 0
  ''');
}

Future<bool> _tableExists(AppDatabase database, String name) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
        variables: [Variable<String>(name)],
      )
      .get();
  return rows.isNotEmpty;
}
