import 'package:drift/drift.dart';

import '../app_database.dart';
import 'database_indexes.dart';
import 'migration_step.dart';

/// Schema v4 — extends the customer and supplier masters.
///
/// Adds the fields required by the sales/purchase modules:
/// - both tables gain `pan_number`, `address_line2`, `balance_type` and
///   `notes`, and their single `address` column is renamed to
///   `address_line1` (Drift derives the `address_line1` column name from the
///   `addressLine1` getter — no underscore before the digit);
/// - `supplier` additionally gains `contact_person` and `payment_terms`.
///
/// The new lookup indexes (email uniqueness, city/state/created_at) are
/// created from the shared [DatabaseIndexes] registry so fresh creates and
/// upgrades stay in sync.
///
/// Every statement is guarded: the customer/supplier tables only exist in
/// databases created after blueprint v1, and databases that never created
/// them (e.g. the migration test fixtures) must upgrade untouched.
const MigrationStep upgradeToV4 = _upgradeToV4;

/// Columns added to both party tables. `balance_type` is non-null with a
/// default so existing rows upgrade without a rebuild.
const List<({String name, String definition})> _sharedPartyColumns = [
  (name: 'pan_number', definition: 'TEXT'),
  (name: 'address_line2', definition: 'TEXT'),
  (name: 'balance_type', definition: "TEXT NOT NULL DEFAULT 'DEBIT'"),
  (name: 'notes', definition: 'TEXT'),
];

/// Columns that only exist on the supplier table.
const List<({String name, String definition})> _supplierOnlyColumns = [
  (name: 'contact_person', definition: 'TEXT'),
  (name: 'payment_terms', definition: 'TEXT'),
];

Future<void> _upgradeToV4(Migrator migrator, AppDatabase database) async {
  await _extendPartyTable(database, 'customer');
  await _extendPartyTable(database, 'supplier', supplierOnly: true);

  // Recreate the party lookup indexes (idempotent). Only tables that exist
  // are indexed — migration fixtures and older databases that never created
  // the customer/supplier tables must upgrade untouched.
  final existingTables = <String>{
    if (await _tableExists(database, 'customer')) 'customer',
    if (await _tableExists(database, 'supplier')) 'supplier',
  };
  if (existingTables.isNotEmpty) {
    await DatabaseIndexes.createForTables(database, existingTables);
  }
}

Future<void> _extendPartyTable(
  AppDatabase database,
  String table, {
  bool supplierOnly = false,
}) async {
  if (!await _tableExists(database, table)) return;

  // The old single `address` column becomes the first address line.
  if (await _columnExists(database, table, 'address')) {
    await database.customStatement(
      'ALTER TABLE $table RENAME COLUMN address TO address_line1',
    );
  }

  final columns = [
    ..._sharedPartyColumns,
    if (supplierOnly) ..._supplierOnlyColumns,
  ];
  for (final column in columns) {
    if (await _columnExists(database, table, column.name)) continue;
    await database.customStatement(
      'ALTER TABLE $table ADD COLUMN ${column.name} ${column.definition}',
    );
  }
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
