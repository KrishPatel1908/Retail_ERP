import 'party_formatters.dart';

/// Pure, shared validation rules for the customer and supplier forms.
///
/// Values are trimmed before they are checked; optional fields return `null`
/// for blank input. Each method returns an error message, or `null` when the
/// value is valid.
abstract final class PartyValidator {
  static const int maxNameLength = 120;
  static const int maxAddressLength = 200;
  static const int maxContactLength = 100;
  static const int maxNotesLength = 500;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _gstPattern = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
  );
  static final RegExp _panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
  static final RegExp _pincodePattern = RegExp(r'^\d{6}$');

  /// Required free-text field, trimmed and length-checked.
  static String? validateRequired(
    String value, {
    required String label,
    int maxLength = maxNameLength,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '$label is required.';
    if (trimmed.length > maxLength) {
      return '$label must be $maxLength characters or fewer.';
    }
    return null;
  }

  /// Required Indian mobile number: 10 digits starting with 6–9.
  static String? validateMobile(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (normalized.isEmpty) return 'Mobile number is required.';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(normalized)) {
      return 'Enter a valid 10-digit mobile number.';
    }
    return null;
  }

  /// Optional Indian mobile number: 10 digits starting with 6–9.
  static String? validateAlternateMobile(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (normalized.isEmpty) return null;
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(normalized)) {
      return 'Enter a valid 10-digit mobile number.';
    }
    return null;
  }

  /// Optional email address.
  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > 254) {
      return 'Email must be 254 characters or fewer.';
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Optional Indian GSTIN (15 characters).
  static String? validateGstNumber(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!_gstPattern.hasMatch(normalized)) {
      return 'Enter a valid 15-character GST number.';
    }
    return null;
  }

  /// Optional Permanent Account Number.
  static String? validatePanNumber(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!_panPattern.hasMatch(normalized)) {
      return 'Enter a valid PAN (e.g. ABCDE1234F).';
    }
    return null;
  }

  /// Optional 6-digit Indian pincode.
  static String? validatePincode(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    if (!_pincodePattern.hasMatch(normalized)) {
      return 'Enter a valid 6-digit pincode.';
    }
    return null;
  }

  /// Optional free-text field with a length cap.
  static String? validateOptional(
    String value, {
    int maxLength = maxAddressLength,
    String? label,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > maxLength) {
      return '${label ?? 'This field'} must be $maxLength characters or '
          'fewer.';
    }
    return null;
  }

  static final RegExp _ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static final RegExp _accountNumberPattern = RegExp(r'^[a-zA-Z0-9]{9,30}$');

  /// Optional Indian Bank IFSC Code (11 characters: 4 letters, '0', 6 alphanumeric).
  static String? validateIfscCode(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (!_ifscPattern.hasMatch(normalized)) {
      return 'Enter a valid 11-character IFSC code (e.g. SBIN0001234).';
    }
    return null;
  }

  /// Optional Bank Account Number (numeric/alphanumeric 9-30 characters).
  static String? validateAccountNumber(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    if (!_accountNumberPattern.hasMatch(normalized)) {
      return 'Enter a valid account number.';
    }
    return null;
  }

  /// Optional non-negative monetary amount with up to two decimals.
  static String? validateAmount(String value, {required String label}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (PartyFormatters.parseRupeesToPaise(trimmed) == null) {
      return '$label must be a valid non-negative amount.';
    }
    return null;
  }
}
