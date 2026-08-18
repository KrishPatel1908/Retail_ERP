/// Thrown by the application layer when a draft fails validation.
///
/// The UI validates first, so this is defense in depth — it should only fire
/// when a caller bypassed the form. [errors] maps form field keys to the
/// message to show under that field.
class CompanySettingsValidationException implements Exception {
  const CompanySettingsValidationException([this.errors = const {}]);

  final Map<String, String?> errors;

  String get message => 'Company settings failed validation.';

  @override
  String toString() => 'CompanySettingsValidationException: $message';
}
