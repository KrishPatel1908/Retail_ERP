import 'package:drift/drift.dart';

import 'customer_table.dart';

/// Sales header — one row per completed or voided sale transaction.
///
/// Monetary values are stored in paise (int). Payment status is derived from
/// paidAmount vs grandTotal.
@DataClassName('Sale')
@TableIndex(name: 'idx_sale_number', columns: {#saleNumber})
@TableIndex(name: 'idx_sale_customer', columns: {#customerId})
@TableIndex(name: 'idx_sale_date', columns: {#saleDate})
@TableIndex(
  name: 'idx_sale_customer_date',
  columns: {#customerId, #saleDate},
)
class Sales extends Table {
  @override
  String get tableName => 'sale';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get saleNumber => text().unique()();
  IntColumn get customerId =>
      integer().nullable().references(Customers, #id)();
  DateTimeColumn get saleDate => dateTime()();

  /// Subtotal before discount and tax, in paise.
  IntColumn get subtotal => integer().withDefault(const Constant(0))();

  /// Total discount across all items and bill discount, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Total tax across all items, in paise.
  IntColumn get tax => integer().withDefault(const Constant(0))();

  /// Grand total = subtotal - discount + tax, in paise.
  IntColumn get grandTotal => integer().withDefault(const Constant(0))();

  /// Amount paid by customer, in paise.
  IntColumn get paidAmount => integer().withDefault(const Constant(0))();

  /// Balance due = max(0, grandTotal - paidAmount), in paise.
  IntColumn get balanceAmount => integer().withDefault(const Constant(0))();

  /// Change returned to customer = max(0, paidAmount - grandTotal), in paise.
  IntColumn get changeAmount => integer().withDefault(const Constant(0))();

  /// PAID, PARTIAL, or UNPAID.
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('UNPAID'))();

  /// Payment method: Cash, UPI, Card, Credit.
  TextColumn get paymentMethod =>
      text().withDefault(const Constant('Cash'))();

  TextColumn get notes => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
