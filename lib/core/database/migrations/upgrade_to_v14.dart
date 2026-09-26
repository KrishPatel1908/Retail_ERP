import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v14 — adds purchase_return and purchase_return_item tables.
///
/// Purchase returns are stored in dedicated tables rather than reusing the
/// purchase table with an isReturn flag. This enables a cleaner workflow with
/// view/revert/delete actions without an edit feature.
const MigrationStep upgradeToV14 = _upgradeToV14;

Future<void> _upgradeToV14(Migrator migrator, AppDatabase database) async {
  if (await _tableExists(database, 'purchase_return')) return;

  await database.customStatement('''
    CREATE TABLE purchase_return (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      return_number TEXT NOT NULL UNIQUE,
      original_purchase_id INTEGER NOT NULL REFERENCES purchase(id),
      supplier_id INTEGER NOT NULL REFERENCES supplier(id),
      return_date INTEGER NOT NULL,
      original_purchase_number TEXT,
      original_invoice_number TEXT,
      subtotal INTEGER NOT NULL DEFAULT 0,
      discount INTEGER NOT NULL DEFAULT 0,
      tax INTEGER NOT NULL DEFAULT 0,
      total INTEGER NOT NULL DEFAULT 0,
      notes TEXT,
      status TEXT NOT NULL DEFAULT 'COMPLETED',
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
      updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
    )
  ''');
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_number '
    'ON purchase_return (return_number)',
  );
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_supplier '
    'ON purchase_return (supplier_id)',
  );
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_date '
    'ON purchase_return (return_date)',
  );
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_original_purchase '
    'ON purchase_return (original_purchase_id)',
  );

  await database.customStatement('''
    CREATE TABLE purchase_return_item (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      purchase_return_id INTEGER NOT NULL REFERENCES purchase_return(id),
      purchase_item_id INTEGER NOT NULL REFERENCES purchase_item(id),
      return_quantity INTEGER NOT NULL,
      purchase_price INTEGER NOT NULL,
      discount INTEGER NOT NULL DEFAULT 0,
      tax_rate REAL NOT NULL DEFAULT 0,
      tax_amount INTEGER NOT NULL DEFAULT 0,
      line_total INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
    )
  ''');
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_item_return '
    'ON purchase_return_item (purchase_return_id)',
  );
  await database.customStatement(
    'CREATE INDEX idx_purchase_return_item_purchase_item '
    'ON purchase_return_item (purchase_item_id)',
  );
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
