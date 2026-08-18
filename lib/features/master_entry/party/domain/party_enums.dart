/// Direction of an opening (and eventually outstanding) balance.
///
/// For a customer a debit means the customer owes the business (receivable);
/// for a supplier a credit means the business owes the supplier (payable).
/// The value is persisted in the `balance_type` column of the customer and
/// supplier tables.
enum BalanceType {
  debit('Debit', 'DEBIT'),
  credit('Credit', 'CREDIT');

  const BalanceType(this.label, this.dbValue);

  /// Human-readable label shown in the UI.
  final String label;

  /// Value stored in the `balance_type` column.
  final String dbValue;

  /// Short suffix used in tables, e.g. `₹1,000 Dr`.
  String get shortLabel => this == BalanceType.debit ? 'Dr' : 'Cr';

  /// Resolves a stored value back to its enum, defaulting to debit for
  /// values the current build does not know about.
  static BalanceType fromDbValue(String value) {
    for (final type in values) {
      if (type.dbValue == value) return type;
    }
    return BalanceType.debit;
  }
}
