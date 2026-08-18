import 'package:drift/drift.dart';

/// Customer master for sales/receivables (approved blueprint §3.10).
///
/// Balances are stored as paise; `outstanding_balance` is a cached value
/// maintained by the transaction engine and initialised from the opening
/// balance at creation time, never written directly by the UI afterwards.
/// `balance_type` records whether the opening balance is a debit (customer
/// owes the business) or a credit (business owes the customer).
@DataClassName('Customer')
@TableIndex(name: 'idx_customer_name', columns: {#customerName})
@TableIndex(
  name: 'idx_customer_active_name',
  columns: {#isActive, #customerName},
)
class Customers extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'customer';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerCode => text().unique()();
  TextColumn get customerName => text()();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get alternateMobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get addressLine1 => text().nullable()();
  TextColumn get addressLine2 => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get pincode => text().nullable()();

  IntColumn get creditLimit => integer().withDefault(const Constant(0))();
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();
  IntColumn get outstandingBalance =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get paymentDueDate => dateTime().nullable()();

  TextColumn get accountName => text().nullable()();
  TextColumn get accountNumber => text().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get branchName => text().nullable()();
  TextColumn get ifscCode => text().nullable()();

  /// `DEBIT` or `CREDIT` — see the shared `BalanceType` enum.
  TextColumn get balanceType => text().withDefault(const Constant('DEBIT'))();
  TextColumn get notes => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
