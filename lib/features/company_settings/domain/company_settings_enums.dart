/// Legal structure of the company, stored in `company_settings.business_type`.
enum BusinessType {
  proprietorship('Proprietorship', 'PROPRIETORSHIP'),
  partnership('Partnership', 'PARTNERSHIP'),
  llp('LLP', 'LLP'),
  privateLimited('Private Limited', 'PRIVATE_LIMITED'),
  publicLimited('Public Limited', 'PUBLIC_LIMITED'),
  other('Other', 'OTHER');

  const BusinessType(this.label, this.dbValue);

  /// Human-readable label shown in the UI.
  final String label;

  /// Value stored in the `business_type` column.
  final String dbValue;

  /// Company types that carry a CIN; for these the CIN field is required.
  bool get requiresCin =>
      this == BusinessType.llp ||
      this == BusinessType.privateLimited ||
      this == BusinessType.publicLimited;

  /// Resolves a stored value back to its enum, defaulting to proprietorship
  /// for values the current build does not know about.
  static BusinessType fromDbValue(String value) {
    for (final type in values) {
      if (type.dbValue == value) return type;
    }
    return BusinessType.proprietorship;
  }
}

/// How prices are treated by default in documents (the "Default Tax Type").
///
/// Persisted as `company_settings.prices_inclusive_of_tax`: `true` when
/// prices already include tax, `false` when tax is added on top.
enum TaxTreatment {
  inclusive('Tax Inclusive', true),
  exclusive('Tax Exclusive', false);

  const TaxTreatment(this.label, this.inclusiveOfTax);

  /// Human-readable label shown in the UI.
  final String label;

  /// The stored boolean: `true` for inclusive, `false` for exclusive.
  final bool inclusiveOfTax;

  static TaxTreatment fromInclusive(bool inclusiveOfTax) =>
      inclusiveOfTax ? TaxTreatment.inclusive : TaxTreatment.exclusive;
}
