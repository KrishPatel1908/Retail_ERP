import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v5 — extends customer and supplier masters with bank details,
/// payment due date, and supplier credit limit.
const MigrationStep upgradeToV5 = _upgradeToV5;

const List<({String name, String definition})> _sharedV5Columns = [
  (name: 'payment_due_date', definition: 'DATETIME'),
  (name: 'account_name', definition: 'TEXT'),
  (name: 'account_number', definition: 'TEXT'),
  (name: 'bank_name', definition: 'TEXT'),
  (name: 'branch_name', definition: 'TEXT'),
  (name: 'ifsc_code', definition: 'TEXT'),
];

Future<void> _upgradeToV5(Migrator migrator, AppDatabase database) async {
  await _extendPartyTableV5(database, 'customer');
  await _extendPartyTableV5(database, 'supplier', isSupplier: true);
}

Future<void> _extendPartyTableV5(
  AppDatabase database,
  String table, {
  bool isSupplier = false,
}) async {
  if (!await _tableExists(database, table)) return;

  final columns = [
    if (isSupplier)
      (name: 'credit_limit', definition: 'INTEGER NOT NULL DEFAULT 0'),
    ..._sharedV5Columns,
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
