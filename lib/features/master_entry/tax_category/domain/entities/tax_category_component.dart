/// Domain model representing a single tax component in a tax category
/// (e.g. CGST 9%, SGST 9%, IGST 18%, CESS 2%).
class TaxCategoryComponent {
  const TaxCategoryComponent({
    required this.taxTypeId,
    required this.taxTypeName,
    required this.percentage,
  });

  final int taxTypeId;
  final String taxTypeName;
  final double percentage;

  TaxCategoryComponent copyWith({
    int? taxTypeId,
    String? taxTypeName,
    double? percentage,
  }) {
    return TaxCategoryComponent(
      taxTypeId: taxTypeId ?? this.taxTypeId,
      taxTypeName: taxTypeName ?? this.taxTypeName,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxCategoryComponent &&
          runtimeType == other.runtimeType &&
          taxTypeId == other.taxTypeId &&
          taxTypeName == other.taxTypeName &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(taxTypeId, taxTypeName, percentage);

  @override
  String toString() =>
      'TaxCategoryComponent(taxTypeId: $taxTypeId, taxTypeName: $taxTypeName, percentage: $percentage)';
}
