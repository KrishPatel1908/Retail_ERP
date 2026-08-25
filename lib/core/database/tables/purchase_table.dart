import 'package:drift/drift.dart';

import 'supplier_table.dart';

/// Purchase header — one row per purchase transaction.
///
/// Monetary values are stored in paise (int). Payment status is derived from
/// paid_amount vs total and never set manually by the UI.
@DataClassName('Purchase')
@TableIndex(name: 'idx_purchase_number', columns: {#purchaseNumber})
@TableIndex(name: 'idx_purchase_supplier', columns: {#supplierId})
@TableIndex(name: 'idx_purchase_date', columns: {#purchaseDate})
@TableIndex(
  name: 'idx_purchase_supplier_date',
  columns: {#supplierId, #purchaseDate},
)
class Purchases extends Table {
  @override
  String get tableName => 'purchase';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get purchaseNumber => text().unique()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  DateTimeColumn get purchaseDate => dateTime()();
  TextColumn get invoiceNumber => text().nullable()();

  /// Subtotal before discount and tax, in paise.
  IntColumn get subtotal => integer().withDefault(const Constant(0))();

  /// Total discount across all items, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Total tax across all items, in paise.
  IntColumn get tax => integer().withDefault(const Constant(0))();

  /// Grand total = subtotal - discount + tax, in paise.
  IntColumn get total => integer().withDefault(const Constant(0))();

  /// Amount already paid to supplier, in paise.
  IntColumn get paidAmount => integer().withDefault(const Constant(0))();

  /// Amount due = total - paid, in paise.
  IntColumn get dueAmount => integer().withDefault(const Constant(0))();

  /// UNPAID, PARTIAL, or PAID — derived, never set by the user.
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('UNPAID'))();

  /// Payment method used for the initial payment: Cash, UPI, Bank, Card, Other.
  TextColumn get paymentMethod => text().nullable()();

  TextColumn get notes => text().nullable()();

  BoolColumn get isReturn => boolean().withDefault(const Constant(false))();

  /// Reference to the original purchase when this is a return.
  IntColumn get originalPurchaseId => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
