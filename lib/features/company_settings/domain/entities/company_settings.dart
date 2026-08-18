import '../company_settings_enums.dart';

/// Domain model of the single company configuration.
///
/// This is the only shape the presentation layer sees; Drift row classes are
/// mapped to this entity inside the repository so no Drift type ever leaks
/// into UI code. There is exactly one instance (id `1`) per database —
/// the singleton rule is enforced by the table's `CHECK (id = 1)` constraint
/// and by the repository/service layer.
///
/// Fields that are not surfaced in the settings UI (document-numbering
/// prefixes, timezone, activity flag) are still preserved through saves.
class CompanySettings {
  const CompanySettings({
    required this.id,
    required this.companyName,
    this.legalName,
    required this.businessType,
    required this.gstRegistered,
    this.gstNumber,
    this.panNumber,
    this.cin,
    this.mobile,
    this.email,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.pincode,
    this.logoPath,
    required this.defaultTaxType,
    required this.invoicePrefix,
    required this.invoiceStartNumber,
    required this.financialYearStartMonth,
    required this.currencyCode,
    required this.currencySymbol,
    required this.decimalPlaces,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.bankBranch,
    this.upiId,
    this.invoiceFooter,
    this.invoiceTerms,
    this.invoiceThankYouMessage,
    required this.showLogoOnInvoice,
    required this.showBankDetailsOnInvoice,
    required this.showGstDetailsOnInvoice,
    required this.createdAt,
    required this.updatedAt,
  });

  static const int singletonId = 1;

  final int id;

  /// The name displayed throughout the ERP.
  final String companyName;

  final String? legalName;
  final BusinessType businessType;

  /// Whether the business is GST registered; when true the GSTIN is required.
  final bool gstRegistered;

  final String? gstNumber;
  final String? panNumber;
  final String? cin;
  final String? mobile;
  final String? email;
  final String? website;

  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;

  /// Two-digit state code derived from the GSTIN (kept for future GST
  /// reports; not edited through the UI).
  final String? stateCode;

  final String? country;
  final String? pincode;

  /// Absolute path of the logo file stored outside the database.
  final String? logoPath;

  /// Default tax treatment for future documents.
  final TaxTreatment defaultTaxType;

  final String invoicePrefix;
  final int invoiceStartNumber;

  /// 1–12; April (4) is the default Indian financial-year start.
  final int financialYearStartMonth;

  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;

  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? bankIfsc;
  final String? bankBranch;
  final String? upiId;

  final String? invoiceFooter;
  final String? invoiceTerms;
  final String? invoiceThankYouMessage;
  final bool showLogoOnInvoice;
  final bool showBankDetailsOnInvoice;
  final bool showGstDetailsOnInvoice;

  final DateTime createdAt;
  final DateTime updatedAt;
}
