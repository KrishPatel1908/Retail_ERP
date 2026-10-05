import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v16 — adds Sales module tables:
///
/// - `sale` — sales header table recording total, discount, tax, payment status, etc.
/// - `sale_item` — line items with price, unit, discount, and tax snapshots.
/// - `customer_transaction` — immutable customer ledger entries for credit/partial sales.
/// - `inventory_transaction.sale_id` — links stock movements to sales transactions.
const MigrationStep upgradeToV16 = _upgradeToV16;

Future<void> _upgradeToV16(Migrator migrator, AppDatabase database) async {
  if (!await _tableExists(database, 'sale')) {
    await database.customStatement('''
      CREATE TABLE sale (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_number TEXT NOT NULL UNIQUE,
        customer_id INTEGER REFERENCES customer(id),
        sale_date INTEGER NOT NULL,
        subtotal INTEGER NOT NULL DEFAULT 0,
        discount INTEGER NOT NULL DEFAULT 0,
        tax INTEGER NOT NULL DEFAULT 0,
        grand_total INTEGER NOT NULL DEFAULT 0,
        paid_amount INTEGER NOT NULL DEFAULT 0,
        balance_amount INTEGER NOT NULL DEFAULT 0,
        change_amount INTEGER NOT NULL DEFAULT 0,
        payment_status TEXT NOT NULL DEFAULT 'UNPAID',
        payment_method TEXT NOT NULL DEFAULT 'Cash',
        notes TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');
    await database.customStatement(
      'CREATE UNIQUE INDEX idx_sale_number ON sale (sale_number)',
    );
    await database.customStatement(
      'CREATE INDEX idx_sale_customer ON sale (customer_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_sale_date ON sale (sale_date)',
    );
    await database.customStatement(
      'CREATE INDEX idx_sale_customer_date ON sale (customer_id, sale_date)',
    );
  }

  if (!await _tableExists(database, 'sale_item')) {
    await database.customStatement('''
      CREATE TABLE sale_item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER NOT NULL REFERENCES sale(id) ON DELETE CASCADE,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        product_name TEXT NOT NULL,
        variant_name TEXT,
        barcode TEXT,
        unit_id INTEGER NOT NULL REFERENCES unit(id),
        unit_name TEXT NOT NULL,
        quantity REAL NOT NULL DEFAULT 1.0,
        unit_price INTEGER NOT NULL,
        discount INTEGER NOT NULL DEFAULT 0,
        tax_rate REAL NOT NULL DEFAULT 0.0,
        tax_amount INTEGER NOT NULL DEFAULT 0,
        line_total INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');
    await database.customStatement(
      'CREATE INDEX idx_sale_item_sale ON sale_item (sale_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_sale_item_product ON sale_item (product_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_sale_item_variant ON sale_item (variant_id)',
    );
  }

  if (!await _tableExists(database, 'customer_transaction')) {
    await database.customStatement('''
      CREATE TABLE customer_transaction (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER REFERENCES sale(id) ON DELETE CASCADE,
        customer_id INTEGER NOT NULL REFERENCES customer(id),
        debit INTEGER NOT NULL DEFAULT 0,
        credit INTEGER NOT NULL DEFAULT 0,
        running_total INTEGER NOT NULL,
        transaction_date INTEGER NOT NULL,
        note TEXT,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');
    await database.customStatement(
      'CREATE INDEX idx_customer_transaction_sale_date ON customer_transaction (sale_id, transaction_date)',
    );
    await database.customStatement(
      'CREATE INDEX idx_customer_transaction_customer_date ON customer_transaction (customer_id, transaction_date)',
    );
  }

  if (await _tableExists(database, 'inventory_transaction')) {
    final txnColumns = await database
        .customSelect(
          "SELECT name FROM pragma_table_info('inventory_transaction')",
        )
        .get();
    final txnNames = txnColumns
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!txnNames.contains('sale_id')) {
      await database.customStatement(
        'ALTER TABLE inventory_transaction ADD COLUMN sale_id INTEGER REFERENCES sale(id)',
      );
    }
    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_inv_txn_sale ON inventory_transaction (sale_id)',
    );
  }
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
