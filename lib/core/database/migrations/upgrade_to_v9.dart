import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v9 — adds Purchase module tables:
/// - `purchase` — purchase header with totals, payment tracking.
/// - `purchase_item` — line items with product, variant, price, tax.
/// - `inventory_transaction` — stock movement history.
/// - `current_stock` — materialized stock levels per product/variant.
const MigrationStep upgradeToV9 = _upgradeToV9;

Future<void> _upgradeToV9(Migrator migrator, AppDatabase database) async {
  // Create purchase table.
  if (!await _tableExists(database, 'purchase')) {
    await database.customStatement('''
      CREATE TABLE purchase (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_number TEXT NOT NULL UNIQUE,
        supplier_id INTEGER NOT NULL REFERENCES supplier(id),
        purchase_date INTEGER NOT NULL,
        invoice_number TEXT,
        subtotal INTEGER NOT NULL DEFAULT 0,
        discount INTEGER NOT NULL DEFAULT 0,
        tax INTEGER NOT NULL DEFAULT 0,
        total INTEGER NOT NULL DEFAULT 0,
        paid_amount INTEGER NOT NULL DEFAULT 0,
        due_amount INTEGER NOT NULL DEFAULT 0,
        payment_status TEXT NOT NULL DEFAULT 'UNPAID',
        payment_method TEXT,
        notes TEXT,
        is_return INTEGER NOT NULL DEFAULT 0,
        original_purchase_id INTEGER,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    await database.customStatement(
      'CREATE INDEX idx_purchase_number ON purchase (purchase_number)',
    );
    await database.customStatement(
      'CREATE INDEX idx_purchase_supplier ON purchase (supplier_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_purchase_date ON purchase (purchase_date)',
    );
    await database.customStatement(
      'CREATE INDEX idx_purchase_supplier_date ON purchase (supplier_id, purchase_date)',
    );
  }

  // Create purchase_item table.
  if (!await _tableExists(database, 'purchase_item')) {
    await database.customStatement('''
      CREATE TABLE purchase_item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_id INTEGER NOT NULL REFERENCES purchase(id) ON DELETE CASCADE,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        quantity INTEGER NOT NULL,
        unit_id INTEGER NOT NULL REFERENCES unit(id),
        purchase_price INTEGER NOT NULL,
        discount INTEGER NOT NULL DEFAULT 0,
        tax_rate REAL NOT NULL DEFAULT 0,
        tax_amount INTEGER NOT NULL DEFAULT 0,
        line_total INTEGER NOT NULL DEFAULT 0,
        returned_quantity INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    await database.customStatement(
      'CREATE INDEX idx_purchase_item_purchase ON purchase_item (purchase_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_purchase_item_product ON purchase_item (product_id)',
    );
    await database.customStatement(
      'CREATE INDEX idx_purchase_item_variant ON purchase_item (variant_id)',
    );
  }

  // Create inventory_transaction table.
  if (!await _tableExists(database, 'inventory_transaction')) {
    await database.customStatement('''
      CREATE TABLE inventory_transaction (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        warehouse_id INTEGER REFERENCES warehouse(id),
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
      'CREATE INDEX idx_inv_txn_product_variant ON inventory_transaction (product_id, variant_id)',
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

  // Create current_stock table.
  if (!await _tableExists(database, 'current_stock')) {
    await database.customStatement('''
      CREATE TABLE current_stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES product(id),
        variant_id INTEGER REFERENCES product_variant(id),
        warehouse_id INTEGER REFERENCES warehouse(id),
        quantity INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        UNIQUE(product_id, variant_id)
      )
    ''');

    await database.customStatement(
      'CREATE INDEX idx_stock_product_variant ON current_stock (product_id, variant_id)',
    );
  }

  // Seed the PURCHASE document number sequence (only if the table exists).
  if (await _tableExists(database, 'document_number_sequence') &&
      !await _sequenceExists(database, 'PURCHASE')) {
    await database.customStatement(
      "INSERT INTO document_number_sequence (document_type, prefix, suffix, last_number, padding) "
      "VALUES ('PURCHASE', 'PUR-', '', 0, 6)",
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

Future<bool> _sequenceExists(
  AppDatabase database,
  String documentType,
) async {
  final rows = await database
      .customSelect(
        "SELECT 1 FROM document_number_sequence WHERE document_type = ?",
        variables: [Variable<String>(documentType)],
      )
      .get();
  return rows.isNotEmpty;
}
