import 'package:drift/drift.dart';

/// Single-row company settings (approved blueprint §3.1).
///
/// Holds the business identity and global defaults used by document
/// numbering, GST logic and reporting.
@DataClassName('CompanySettings')
class CompanySettingsTable extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'company_settings';

  /// Primary key. `CHECK (id = 1)` enforces the single-row rule.
  IntColumn get id => integer().autoIncrement()();

  TextColumn get companyName => text()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get pincode => text().nullable()();

  TextColumn get currencyCode => text().withDefault(const Constant('INR'))();
  IntColumn get financialYearStartMonth =>
      integer().withDefault(const Constant(4))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('INV-'))();
  TextColumn get purchasePrefix => text().withDefault(const Constant('PUR-'))();
  TextColumn get receiptPrefix => text().withDefault(const Constant('RCT-'))();
  TextColumn get timezone =>
      text().withDefault(const Constant('Asia/Kolkata'))();
  BoolColumn get pricesInclusiveOfTax =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const ['CHECK (id = 1)'];
}
