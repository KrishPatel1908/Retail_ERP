import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

export 'package:drift/drift.dart' show Variable;

/// Schema v15 — Inventory groundwork:
///
/// - `product.minimum_stock` — per-product low-stock threshold for the
///   Inventory module's stock status. Variants inherit the threshold from
///   their parent product. Existing products default to 0 (warning off).
/// - `inventory_transaction.previous_quantity` / `new_quantity` — the stock
///   level before/after each movement, as required by the stock movement
///   history. Null for pre-existing rows; those render without the columns.
const MigrationStep upgradeToV15 = _upgradeToV15;

Future<void> _upgradeToV15(Migrator migrator, AppDatabase database) async {
  // Legacy fixture databases (v1–v6) may not have the product table at all;
  // it is created by a later step, so only touch tables that already exist.
  if (await _tableExists(database, 'product')) {
    final productColumns = await database
        .customSelect("SELECT name FROM pragma_table_info('product')")
        .get();
    final productNames = productColumns
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!productNames.contains('minimum_stock')) {
      await database.customStatement(
        'ALTER TABLE product ADD COLUMN minimum_stock INTEGER NOT NULL DEFAULT 0',
      );
    }
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
    if (!txnNames.contains('previous_quantity')) {
      await database.customStatement(
        'ALTER TABLE inventory_transaction ADD COLUMN previous_quantity INTEGER',
      );
    }
    if (!txnNames.contains('new_quantity')) {
      await database.customStatement(
        'ALTER TABLE inventory_transaction ADD COLUMN new_quantity INTEGER',
      );
    }
    await backfillInventoryTransactionQuantities(database);
  }
}

/// Backfills `previous_quantity` and `new_quantity` on pre-existing
/// `inventory_transaction` rows that were written before schema v15.
///
/// Replays transactions chronologically for each product/variant so each
/// movement's previous and new stock levels are accurately persisted in SQLite.
Future<void> backfillInventoryTransactionQuantities(AppDatabase database) async {
  if (!await _tableExists(database, 'inventory_transaction')) return;

  final txnColumns = await database
      .customSelect(
        "SELECT name FROM pragma_table_info('inventory_transaction')",
      )
      .get();
  final txnNames = txnColumns
      .map((row) => row.read<String>('name'))
      .toSet();
  if (!txnNames.contains('previous_quantity') || !txnNames.contains('new_quantity')) {
    return;
  }

  final nullRows = await database.customSelect('''
    SELECT DISTINCT product_id, variant_id 
    FROM inventory_transaction 
    WHERE previous_quantity IS NULL OR new_quantity IS NULL
  ''').get();

  if (nullRows.isEmpty) return;

  for (final pair in nullRows) {
    final productId = pair.read<int>('product_id');
    final variantId = pair.readNullable<int>('variant_id');

    final transactions = variantId != null
        ? await database.customSelect(
            '''
            SELECT id, quantity, previous_quantity, new_quantity
            FROM inventory_transaction
            WHERE product_id = ? AND variant_id = ?
            ORDER BY transaction_date ASC, id ASC
            ''',
            variables: [
              Variable<int>(productId),
              Variable<int>(variantId),
            ],
          ).get()
        : await database.customSelect(
            '''
            SELECT id, quantity, previous_quantity, new_quantity
            FROM inventory_transaction
            WHERE product_id = ? AND (variant_id IS NULL OR variant_id = 0)
            ORDER BY transaction_date ASC, id ASC
            ''',
            variables: [
              Variable<int>(productId),
            ],
          ).get();

    int runningStock = 0;
    for (final txn in transactions) {
      final id = txn.read<int>('id');
      final qty = txn.read<int>('quantity');
      final prev = txn.readNullable<int>('previous_quantity') ?? runningStock;
      final next = txn.readNullable<int>('new_quantity') ?? (prev + qty);

      if (txn.readNullable<int>('previous_quantity') == null ||
          txn.readNullable<int>('new_quantity') == null) {
        await database.customStatement(
          '''
          UPDATE inventory_transaction
          SET previous_quantity = ?, new_quantity = ?
          WHERE id = ?
          ''',
          [prev, next, id],
        );
      }
      runningStock = next;
    }
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
