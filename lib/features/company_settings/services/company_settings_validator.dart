import '../../master_entry/party/services/party_validator.dart';
import '../domain/entities/company_settings_draft.dart';

/// Validation rules for the Company Settings form.
///
/// Reuses [PartyValidator] for the rules shared with the party masters
/// (email, GSTIN, PAN, pincode, IFSC, account number) and adds the
/// company-specific rules: GSTIN required when GST registration is enabled,
/// CIN for incorporated business types, Indian phone (mobile or landline),
/// website URL, UPI ID, invoice prefix and the starting invoice number.
///
/// Every method returns an error message, or `null` when valid. Values are
/// trimmed before checking; optional fields return `null` for blank input.
abstract final class CompanySettingsValidator {
  static const int maxBusinessNameLength = PartyValidator.maxNameLength;
  static const int maxAddressLength = PartyValidator.maxAddressLength;
  static const int maxContactLength = 100;
  static const int maxInvoicePrefixLength = 10;
  static const int maxLongTextLength = 2000;
  static const int maxCurrencySymbolLength = 5;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _gstPattern = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
  );
  static final RegExp _panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
  static final RegExp _cinPattern = RegExp(
    r'^[LU][0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6}$',
  );
  static final RegExp _pincodePattern = RegExp(r'^\d{6}$');
  static final RegExp _websitePattern = RegExp(
    r'^(https?://)?(www\.)?[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?'
    r'(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)+'
    r'(:\d+)?(/[^\s]*)?$',
  );
  static final RegExp _ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static final RegExp _accountNumberPattern = RegExp(r'^[a-zA-Z0-9]{9,30}$');
  static final RegExp _upiPattern = RegExp(r'^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$');
  static final RegExp _invoicePrefixPattern = RegExp(r'^[A-Za-z0-9_-]+$');

  /// Validates the whole draft. Returns a map of field key → error message;
  /// keys with a `null` value are valid.
  static Map<String, String?> validate(CompanySettingsDraft draft) {
    final requiresCin = draft.businessType.requiresCin;
    return {
      'businessName': validateBusinessName(draft.businessName),
      'gstin': validateGstin(
        draft.gstin,
        required: draft.gstRegistered,
      ),
      'pan': validatePan(draft.pan),
      'cin': validateCin(draft.cin, required: requiresCin),
      'phone': validatePhone(draft.phone),
      'email': validateEmail(draft.email),
      'website': validateWebsite(draft.website),
      'addressLine1': validateRequired(
        draft.addressLine1,
        label: 'Address 1',
      ),
      'addressLine2': validateOptional(
        draft.addressLine2,
        label: 'Address 2',
      ),
      'city': validateRequired(draft.city, label: 'City'),
      'state': validateRequired(draft.state, label: 'State'),
      'pincode': validatePincode(draft.pincode, required: true),
      'country': validateOptional(draft.country, label: 'Country'),
      'invoicePrefix': validateInvoicePrefix(draft.invoicePrefix),
      'invoiceStartNumber': validateInvoiceStartNumber(
        draft.invoiceStartNumber,
      ),
      'currencyCode': validateCurrencyCode(draft.currencyCode),
      'currencySymbol': validateOptional(
        draft.currencySymbol,
        maxLength: maxCurrencySymbolLength,
        label: 'Currency symbol',
      ),
      'bankName': validateOptional(draft.bankName, label: 'Bank name'),
      'bankAccountName': validateOptional(
        draft.bankAccountName,
        label: 'Account name',
      ),
      'bankAccountNumber': validateAccountNumber(draft.bankAccountNumber),
      'bankIfsc': validateIfsc(draft.bankIfsc),
      'bankBranch': validateOptional(draft.bankBranch, label: 'Branch name'),
      'upiId': validateUpiId(draft.upiId),
      'invoiceFooter': validateOptional(
        draft.invoiceFooter,
        maxLength: maxLongTextLength,
        label: 'Invoice footer',
      ),
      'invoiceTerms': validateOptional(
        draft.invoiceTerms,
        maxLength: maxLongTextLength,
        label: 'Terms & conditions',
      ),
      'invoiceThankYouMessage': validateOptional(
        draft.invoiceThankYouMessage,
        maxLength: maxLongTextLength,
        label: 'Thank you message',
      ),
    };
  }

  /// Required free-text field, trimmed and length-checked.
  static String? validateRequired(
    String value, {
    required String label,
    int maxLength = maxBusinessNameLength,
  }) {
    return PartyValidator.validateRequired(
      value,
      label: label,
      maxLength: maxLength,
    );
  }

  /// Optional free-text field with a length cap.
  static String? validateOptional(
    String value, {
    int maxLength = maxAddressLength,
    String? label,
  }) {
    return PartyValidator.validateOptional(
      value,
      maxLength: maxLength,
      label: label,
    );
  }

  static String? validateBusinessName(String value) {
    return validateRequired(value, label: 'Business name');
  }

  /// GSTIN: required (with format check) when the business is GST registered,
  /// otherwise an optional format check.
  static String? validateGstin(String value, {bool required = false}) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) {
      return required ? 'GSTIN is required when GST registration is enabled.' : null;
    }
    if (!_gstPattern.hasMatch(normalized)) {
      return 'Enter a valid 15-character GST number.';
    }
    return null;
  }

  static String? validatePan(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!_panPattern.hasMatch(normalized)) {
      return 'Enter a valid PAN (e.g. ABCDE1234F).';
    }
    return null;
  }

  /// CIN is required for incorporated business types (LLP, Private Limited,
  /// Public Limited).
  static String? validateCin(String value, {bool required = false}) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) {
      return required
          ? 'CIN is required for this business type.'
          : null;
    }
    if (!_cinPattern.hasMatch(normalized)) {
      return 'Enter a valid 21-character CIN (e.g. U12345MH2024PTC123456).';
    }
    return null;
  }

  /// Indian phone number: a 10-digit mobile starting with 6–9, or an
  /// 11-digit landline with a leading `0`. Spaces, dashes and an optional
  /// `+91` / `91` country prefix are ignored.
  static String? validatePhone(String value) {
    var normalized = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (normalized.startsWith('+91')) {
      normalized = normalized.substring(3);
    } else if (normalized.startsWith('91') && normalized.length == 12) {
      normalized = normalized.substring(2);
    }
    if (normalized.isEmpty) return 'Phone number is required.';
    if (!RegExp(r'^([6-9]\d{9}|0\d{10})$').hasMatch(normalized)) {
      return 'Enter a valid Indian phone number '
          '(10-digit mobile or landline with STD code).';
    }
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > 254) return 'Email must be 254 characters or fewer.';
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Optional website URL. A scheme is not required (e.g. `acme.com`).
  static String? validateWebsite(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > 200) return 'Website must be 200 characters or fewer.';
    if (!_websitePattern.hasMatch(trimmed)) {
      return 'Enter a valid website URL (e.g. www.acme.com).';
    }
    return null;
  }

  static String? validatePincode(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return required ? 'Pincode is required.' : null;
    }
    if (!_pincodePattern.hasMatch(trimmed)) {
      return 'Enter a valid 6-digit pincode.';
    }
    return null;
  }

  static String? validateIfsc(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!_ifscPattern.hasMatch(normalized)) {
      return 'Enter a valid 11-character IFSC code (e.g. SBIN0001234).';
    }
    return null;
  }

  static String? validateAccountNumber(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    if (!_accountNumberPattern.hasMatch(normalized)) {
      return 'Enter a valid account number.';
    }
    return null;
  }

  /// Optional UPI ID (e.g. `acme@upi`).
  static String? validateUpiId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    if (!_upiPattern.hasMatch(normalized)) {
      return 'Enter a valid UPI ID (e.g. name@upi).';
    }
    return null;
  }

  /// Required invoice prefix: trimmed, at most 10 characters, only letters,
  /// digits, `-` and `_`.
  static String? validateInvoicePrefix(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Invoice prefix is required.';
    if (trimmed.length > maxInvoicePrefixLength) {
      return 'Invoice prefix must be $maxInvoicePrefixLength characters or fewer.';
    }
    if (!_invoicePrefixPattern.hasMatch(trimmed)) {
      return 'Use only letters, numbers, dash or underscore.';
    }
    return null;
  }

  /// Required starting invoice number: a positive integer.
  static String? validateInvoiceStartNumber(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Starting invoice number is required.';
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 1) {
      return 'Enter a positive whole number (e.g. 1).';
    }
    return null;
  }

  /// Optional ISO-style currency code (e.g. `INR`).
  static String? validateCurrencyCode(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalized)) {
      return 'Enter a 3-letter currency code (e.g. INR).';
    }
    return null;
  }
}
