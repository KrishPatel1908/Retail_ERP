import 'tax_category_component.dart';

/// Domain model of a tax category template (e.g. GST 18%, Tax Free).
///
/// Holds the category identity and the list of tax components breakdown.
class TaxCategory {
  const TaxCategory({
    required this.id,
    required this.taxCategoryName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.components,
  });

  final int id;
  final String taxCategoryName;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaxCategoryComponent> components;

  /// Total tax percentage calculated automatically as the sum of all component percentages.
  double get totalTaxPercentage =>
      components.fold(0.0, (sum, item) => sum + item.percentage);

  TaxCategory copyWith({
    int? id,
    String? taxCategoryName,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TaxCategoryComponent>? components,
  }) {
    return TaxCategory(
      id: id ?? this.id,
      taxCategoryName: taxCategoryName ?? this.taxCategoryName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      components: components ?? this.components,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taxCategoryName == other.taxCategoryName &&
          description == other.description &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      Object.hash(id, taxCategoryName, description, createdAt, updatedAt);

  @override
  String toString() =>
      'TaxCategory(id: $id, name: $taxCategoryName, components: ${components.length}, totalTax: $totalTaxPercentage%)';
}
