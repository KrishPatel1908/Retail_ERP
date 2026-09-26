import 'package:drift/drift.dart';

/// Single-row company settings (approved blueprint §3.1).
///
/// Holds the business identity and global defaults used by document
/// numbering, GST logic and reporting.
///
/// The singleton rule is enforced twice: `CHECK (id = 1)` rejects a second
/// row at the database level, and the repository/service layer always read
/// and write `id = 1`.
@DataClassName('CompanySettings')
class CompanySettingsTable extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'company_settings';

  /// Primary key. `CHECK (id = 1)` enforces the single-row rule.
  IntColumn get id => integer().autoIncrement()();

  // --- Company information ------------------------------------------------

  /// The name displayed throughout the ERP.
  TextColumn get companyName => text()();
  TextColumn get legalName => text().nullable()();

  /// One of the [BusinessType] db values (e.g. `PROPRIETORSHIP`).
  TextColumn get businessType =>
      text().withDefault(const Constant('PROPRIETORSHIP'))();

  /// Whether the business is registered for GST; when true the GSTIN is
  /// required by the application layer.
  BoolColumn get gstRegistered =>
      boolean().withDefault(const Constant(false))();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  TextColumn get cin => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get website => text().nullable()();

  // --- Business address ---------------------------------------------------

  TextColumn get addressLine1 => text().nullable()();
  TextColumn get addressLine2 => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get pincode => text().nullable()();

  // --- Logo ---------------------------------------------------------------

  /// Absolute path of the logo file stored outside the database.
  TextColumn get logoPath => text().nullable()();

  // --- Tax & billing ------------------------------------------------------

  /// `true` = tax inclusive, `false` = tax exclusive (the default tax type).
  BoolColumn get pricesInclusiveOfTax =>
      boolean().withDefault(const Constant(false))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('INV-'))();
  IntColumn get invoiceStartNumber =>
      integer().withDefault(const Constant(1))();
  TextColumn get purchasePrefix => text().withDefault(const Constant('PUR-'))();
  TextColumn get receiptPrefix => text().withDefault(const Constant('RCT-'))();

  // --- Financial ----------------------------------------------------------

  /// 1–12; April (4) is the default Indian financial-year start.
  IntColumn get financialYearStartMonth =>
      integer().withDefault(const Constant(4))();
  TextColumn get currencyCode => text().withDefault(const Constant('INR'))();
  TextColumn get currencySymbol =>
      text().withDefault(const Constant('\u20B9'))();
  IntColumn get decimalPlaces => integer().withDefault(const Constant(2))();
  TextColumn get timezone =>
      text().withDefault(const Constant('Asia/Kolkata'))();

  // --- Bank details -------------------------------------------------------

  TextColumn get bankName => text().nullable()();
  TextColumn get bankAccountName => text().nullable()();
  TextColumn get bankAccountNumber => text().nullable()();
  TextColumn get bankIfsc => text().nullable()();
  TextColumn get bankBranch => text().nullable()();
  TextColumn get upiId => text().nullable()();

  // --- Invoice rendering --------------------------------------------------

  TextColumn get invoiceFooter => text().nullable()();
  TextColumn get invoiceTerms => text().nullable()();
  TextColumn get invoiceThankYouMessage => text().nullable()();
  BoolColumn get showLogoOnInvoice =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showBankDetailsOnInvoice =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showGstDetailsOnInvoice =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const ['CHECK (id = 1)'];
}
