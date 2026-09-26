import 'package:drift/drift.dart';

import 'purchase_table.dart';
import 'supplier_table.dart';

/// Immutable financial events belonging to a purchase.
///
/// Amounts are in paise. A row contains the movement that occurred at that
/// point in time, never a snapshot of the purchase header. [runningTotal] is
/// calculated as previous total + debit - credit.
@DataClassName('PurchaseTransaction')
@TableIndex(
  name: 'idx_purchase_transaction_purchase_date',
  columns: {#purchaseId, #transactionDate},
)
@TableIndex(
  name: 'idx_purchase_transaction_supplier_date',
  columns: {#supplierId, #transactionDate},
)
class PurchaseTransactions extends Table {
  @override
  String get tableName => 'purchase_transaction';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId =>
      integer().references(Purchases, #id, onDelete: KeyAction.cascade)();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  IntColumn get credit => integer().withDefault(const Constant(0))();
  IntColumn get debit => integer().withDefault(const Constant(0))();
  IntColumn get runningTotal => integer()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
