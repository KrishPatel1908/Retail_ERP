import 'package:drift/drift.dart';

import 'customer_table.dart';
import 'sale_table.dart';

/// Immutable financial events belonging to a customer (ledger).
///
/// Amounts are in paise.
/// For a customer:
/// - debit: increases customer receivable (e.g. sale total amount)
/// - credit: payments made by customer reducing receivable
/// - runningTotal: previous running total + debit - credit
@DataClassName('CustomerTransaction')
@TableIndex(
  name: 'idx_customer_transaction_sale_date',
  columns: {#saleId, #transactionDate},
)
@TableIndex(
  name: 'idx_customer_transaction_customer_date',
  columns: {#customerId, #transactionDate},
)
class CustomerTransactions extends Table {
  @override
  String get tableName => 'customer_transaction';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId =>
      integer().nullable().references(Sales, #id, onDelete: KeyAction.cascade)();
  IntColumn get customerId => integer().references(Customers, #id)();

  /// Debit: amount customer owes (e.g. sale grand total), in paise.
  IntColumn get debit => integer().withDefault(const Constant(0))();

  /// Credit: amount paid by customer, in paise.
  IntColumn get credit => integer().withDefault(const Constant(0))();

  /// Running outstanding balance = previousTotal + debit - credit, in paise.
  IntColumn get runningTotal => integer()();

  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
