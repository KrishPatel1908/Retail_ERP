import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sq;

import 'package:retail_erp/core/database/app_database.dart';

/// Verifies the v14 → v15 migration: minimum_stock on product and the
/// previous/new quantity columns on inventory_transaction.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('v14 → v15 adds minimum_stock and movement quantity columns', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final tempDir = await Directory.systemTemp.createTemp(
      'retail_erp_v15_migration_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final file = File(p.join(tempDir.path, 'RetailERP.db'));

    // Build a minimal v14 database with the two affected tables.
    final v14 = sq.sqlite3.open(file.path);
    v14.execute('PRAGMA user_version = 14');
    v14.execute(
      'CREATE TABLE product ('
      'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      'product_code TEXT NOT NULL UNIQUE, '
      'product_name TEXT NOT NULL, '
      'unit_id INTEGER NOT NULL, '
      'selling_price INTEGER NOT NULL DEFAULT 0, '
      'is_active INTEGER NOT NULL DEFAULT 1, '
      'created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
    );
    v14.execute(
      'CREATE TABLE product_variant ('
      'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      'product_id INTEGER NOT NULL REFERENCES product (id), '
      'variant_name TEXT NOT NULL, '
      'selling_price INTEGER NOT NULL DEFAULT 0, '
      'is_active INTEGER NOT NULL DEFAULT 1, '
      'created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
    );
    v14.execute(
      'CREATE TABLE inventory_transaction ('
      'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      'product_id INTEGER NOT NULL REFERENCES product (id), '
      'variant_id INTEGER REFERENCES product_variant (id), '
      'transaction_type TEXT NOT NULL, '
      'quantity INTEGER NOT NULL, '
      'transaction_date INTEGER NOT NULL, '
      'created_at INTEGER NOT NULL DEFAULT 0)',
    );
    v14.execute(
      "INSERT INTO product (id, product_code, product_name, unit_id, "
      "created_at, updated_at) VALUES (1, 'P1', 'Legacy', 1, 0, 0)",
    );
    v14.execute(
      "INSERT INTO inventory_transaction (id, product_id, transaction_type, "
      "quantity, transaction_date) VALUES (1, 1, 'PURCHASE', 5, 0)",
    );
    v14.close();

    // Open with the current schema so the v15 migration runs.
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    await db.customSelect('SELECT 1').get();

    expect(db.schemaVersion, 16);
    final versionRow =
        (await db.customSelect('PRAGMA user_version').get()).single;
    expect(versionRow.read<int>('user_version'), 16);

    final productColumns =
        (await db
                .customSelect("SELECT name FROM pragma_table_info('product')")
                .get())
            .map((r) => r.read<String>('name'))
            .toSet();
    expect(productColumns, contains('minimum_stock'));

    final txnColumns =
        (await db
                .customSelect(
                  "SELECT name FROM pragma_table_info('inventory_transaction')",
                )
                .get())
            .map((r) => r.read<String>('name'))
            .toSet();
    expect(txnColumns, containsAll(['previous_quantity', 'new_quantity']));

    // The pre-existing product survived and reads the new default (0).
    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals(1))).getSingle();
    expect(product.minimumStock, 0);

    // The pre-existing movement was backfilled with accurate previous/new quantities.
    final movement = await (db.select(
      db.inventoryTransactions,
    )..where((t) => t.id.equals(1))).getSingle();
    expect(movement.quantity, 5);
    expect(movement.previousQuantity, 0);
    expect(movement.newQuantity, 5);
  });

  test('fresh creates include the v15 columns with correct defaults', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.customSelect('SELECT 1').get();

    expect(db.schemaVersion, 16);

    await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            productCode: 'P-1',
            productName: 'Test',
            brandId: const Value(1),
            unitId: 1,
          ),
        );
    final product = await db.select(db.products).getSingle();
    expect(product.minimumStock, 0);
  });
}
