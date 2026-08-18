import '../../party/services/party_validator.dart';

/// Validation rules for the customer form.
///
/// All rules are shared with the supplier module via [PartyValidator]; this
/// class only names the customer-specific messages and limits.
abstract final class CustomerValidator {
  static String? validateName(String value) {
    return PartyValidator.validateRequired(value, label: 'Customer name');
  }

  static String? validateMobile(String value) {
    return PartyValidator.validateMobile(value);
  }

  static String? validateAlternateMobile(String value) {
    return PartyValidator.validateAlternateMobile(value);
  }

  static String? validateEmail(String value) {
    return PartyValidator.validateEmail(value);
  }

  static String? validateGstNumber(String value) {
    return PartyValidator.validateGstNumber(value);
  }

  static String? validatePanNumber(String value) {
    return PartyValidator.validatePanNumber(value);
  }

  static String? validatePincode(String value) {
    return PartyValidator.validatePincode(value);
  }

  static String? validateAmount(String value, {required String label}) {
    return PartyValidator.validateAmount(value, label: label);
  }

  static String? validateAccountName(String value) {
    return PartyValidator.validateOptional(value, label: 'Account name');
  }

  static String? validateAccountNumber(String value) {
    return PartyValidator.validateAccountNumber(value);
  }

  static String? validateBankName(String value) {
    return PartyValidator.validateOptional(value, label: 'Bank name');
  }

  static String? validateBranchName(String value) {
    return PartyValidator.validateOptional(value, label: 'Branch name');
  }

  static String? validateIfscCode(String value) {
    return PartyValidator.validateIfscCode(value);
  }

  static String? validateNotes(String value) {
    return PartyValidator.validateOptional(
      value,
      maxLength: PartyValidator.maxNotesLength,
      label: 'Notes',
    );
  }

  static String? validateOptional(String value, {String? label}) {
    return PartyValidator.validateOptional(
      value,
      maxLength: PartyValidator.maxAddressLength,
      label: label,
    );
  }
}
