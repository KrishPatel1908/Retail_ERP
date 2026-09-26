import 'package:drift/drift.dart';

import '../app_database.dart';
import 'migration_step.dart';

/// Schema v6 — extends `company_settings` into the full Company Settings
/// module: company identity (legal name, business type, GST registration,
/// CIN), a two-line business address, invoice numbering, financial
/// defaults (currency symbol, decimal places), bank details, invoice
/// rendering text/options, and the logo reference.
///
/// The single `address` column becomes `address_line1` and a new
/// `address_line2` column is added, mirroring the customer/supplier v4
/// migration. Every statement is guarded so repeated or partial upgrades
/// (and databases that never created the table) are safe.
const MigrationStep upgradeToV6 = _upgradeToV6;

/// New nullable text columns.
const List<({String name, String definition})> _v6NullableTextColumns = [
  (name: 'legal_name', definition: 'TEXT'),
  (name: 'cin', definition: 'TEXT'),
  (name: 'address_line2', definition: 'TEXT'),
  (name: 'bank_name', definition: 'TEXT'),
  (name: 'bank_account_name', definition: 'TEXT'),
  (name: 'bank_account_number', definition: 'TEXT'),
  (name: 'bank_ifsc', definition: 'TEXT'),
  (name: 'bank_branch', definition: 'TEXT'),
  (name: 'upi_id', definition: 'TEXT'),
  (name: 'invoice_footer', definition: 'TEXT'),
  (name: 'invoice_terms', definition: 'TEXT'),
  (name: 'invoice_thank_you_message', definition: 'TEXT'),
];

/// New columns with a default; existing rows automatically receive the
/// default value.
const List<({String name, String definition})> _v6DefaultedColumns = [
  (name: 'business_type', definition: "TEXT NOT NULL DEFAULT 'PROPRIETORSHIP'"),
  (name: 'gst_registered', definition: 'INTEGER NOT NULL DEFAULT 0'),
  (name: 'invoice_start_number', definition: 'INTEGER NOT NULL DEFAULT 1'),
  (name: 'currency_symbol', definition: "TEXT NOT NULL DEFAULT '\u20B9'"),
  (name: 'decimal_places', definition: 'INTEGER NOT NULL DEFAULT 2'),
  (name: 'show_logo_on_invoice', definition: 'INTEGER NOT NULL DEFAULT 1'),
  (
    name: 'show_bank_details_on_invoice',
    definition: 'INTEGER NOT NULL DEFAULT 1',
  ),
  (
    name: 'show_gst_details_on_invoice',
    definition: 'INTEGER NOT NULL DEFAULT 1',
  ),
];

Future<void> _upgradeToV6(Migrator migrator, AppDatabase database) async {
  if (!await _tableExists(database, 'company_settings')) return;

  // The old single `address` column becomes the first address line.
  if (await _columnExists(database, 'company_settings', 'address') &&
      !await _columnExists(database, 'company_settings', 'address_line1')) {
    await database.customStatement(
      'ALTER TABLE company_settings RENAME COLUMN address TO address_line1',
    );
  }

  for (final column in _v6NullableTextColumns) {
    if (await _columnExists(database, 'company_settings', column.name)) {
      continue;
    }
    await database.customStatement(
      'ALTER TABLE company_settings ADD COLUMN ${column.name} '
      '${column.definition}',
    );
  }
  for (final column in _v6DefaultedColumns) {
    if (await _columnExists(database, 'company_settings', column.name)) {
      continue;
    }
    await database.customStatement(
      'ALTER TABLE company_settings ADD COLUMN ${column.name} '
      '${column.definition}',
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
