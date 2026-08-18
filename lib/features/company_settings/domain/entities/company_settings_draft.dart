import '../company_settings_enums.dart';
import 'company_settings.dart';

/// Raw form values of the Company Settings page.
///
/// Text fields keep their unparsed string values so the validator can report
/// precise field errors; the service parses and normalizes them before
/// persisting. [logoPath] is not a text field — it is the resolved logo file
/// path chosen through the logo uploader.
class CompanySettingsDraft {
  const CompanySettingsDraft({
    required this.businessName,
    this.legalName = '',
    required this.businessType,
    required this.gstRegistered,
    this.gstin = '',
    this.pan = '',
    this.cin = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.country = '',
    this.logoPath,
    required this.defaultTaxType,
    this.invoicePrefix = '',
    this.invoiceStartNumber = '',
    required this.financialYearStartMonth,
    this.currencyCode = '',
    this.currencySymbol = '',
    required this.decimalPlaces,
    this.bankName = '',
    this.bankAccountName = '',
    this.bankAccountNumber = '',
    this.bankIfsc = '',
    this.bankBranch = '',
    this.upiId = '',
    this.invoiceFooter = '',
    this.invoiceTerms = '',
    this.invoiceThankYouMessage = '',
    required this.showLogoOnInvoice,
    required this.showBankDetailsOnInvoice,
    required this.showGstDetailsOnInvoice,
  });

  factory CompanySettingsDraft.fromEntity(CompanySettings settings) {
    return CompanySettingsDraft(
      businessName: settings.companyName,
      legalName: settings.legalName ?? '',
      businessType: settings.businessType,
      gstRegistered: settings.gstRegistered,
      gstin: settings.gstNumber ?? '',
      pan: settings.panNumber ?? '',
      cin: settings.cin ?? '',
      phone: settings.mobile ?? '',
      email: settings.email ?? '',
      website: settings.website ?? '',
      addressLine1: settings.addressLine1 ?? '',
      addressLine2: settings.addressLine2 ?? '',
      city: settings.city ?? '',
      state: settings.state ?? '',
      pincode: settings.pincode ?? '',
      country: settings.country ?? 'India',
      logoPath: settings.logoPath,
      defaultTaxType: settings.defaultTaxType,
      invoicePrefix: settings.invoicePrefix,
      invoiceStartNumber: settings.invoiceStartNumber.toString(),
      financialYearStartMonth: settings.financialYearStartMonth,
      currencyCode: settings.currencyCode,
      currencySymbol: settings.currencySymbol,
      decimalPlaces: settings.decimalPlaces,
      bankName: settings.bankName ?? '',
      bankAccountName: settings.bankAccountName ?? '',
      bankAccountNumber: settings.bankAccountNumber ?? '',
      bankIfsc: settings.bankIfsc ?? '',
      bankBranch: settings.bankBranch ?? '',
      upiId: settings.upiId ?? '',
      invoiceFooter: settings.invoiceFooter ?? '',
      invoiceTerms: settings.invoiceTerms ?? '',
      invoiceThankYouMessage: settings.invoiceThankYouMessage ?? '',
      showLogoOnInvoice: settings.showLogoOnInvoice,
      showBankDetailsOnInvoice: settings.showBankDetailsOnInvoice,
      showGstDetailsOnInvoice: settings.showGstDetailsOnInvoice,
    );
  }

  final String businessName;
  final String legalName;
  final BusinessType businessType;
  final bool gstRegistered;
  final String gstin;
  final String pan;
  final String cin;
  final String phone;
  final String email;
  final String website;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;

  /// Resolved logo file path (set through the logo uploader, not a field).
  final String? logoPath;

  final TaxTreatment defaultTaxType;
  final String invoicePrefix;

  /// Raw text of the starting invoice number (parsed by the service).
  final String invoiceStartNumber;

  final int financialYearStartMonth;
  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;

  final String bankName;
  final String bankAccountName;
  final String bankAccountNumber;
  final String bankIfsc;
  final String bankBranch;
  final String upiId;

  final String invoiceFooter;
  final String invoiceTerms;
  final String invoiceThankYouMessage;
  final bool showLogoOnInvoice;
  final bool showBankDetailsOnInvoice;
  final bool showGstDetailsOnInvoice;

  /// Returns a copy with a different logo path (the only value not sourced
  /// from a text field).
  CompanySettingsDraft withLogoPath(String? logoPath) {
    return CompanySettingsDraft(
      businessName: businessName,
      legalName: legalName,
      businessType: businessType,
      gstRegistered: gstRegistered,
      gstin: gstin,
      pan: pan,
      cin: cin,
      phone: phone,
      email: email,
      website: website,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      pincode: pincode,
      country: country,
      logoPath: logoPath,
      defaultTaxType: defaultTaxType,
      invoicePrefix: invoicePrefix,
      invoiceStartNumber: invoiceStartNumber,
      financialYearStartMonth: financialYearStartMonth,
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      decimalPlaces: decimalPlaces,
      bankName: bankName,
      bankAccountName: bankAccountName,
      bankAccountNumber: bankAccountNumber,
      bankIfsc: bankIfsc,
      bankBranch: bankBranch,
      upiId: upiId,
      invoiceFooter: invoiceFooter,
      invoiceTerms: invoiceTerms,
      invoiceThankYouMessage: invoiceThankYouMessage,
      showLogoOnInvoice: showLogoOnInvoice,
      showBankDetailsOnInvoice: showBankDetailsOnInvoice,
      showGstDetailsOnInvoice: showGstDetailsOnInvoice,
    );
  }
}
