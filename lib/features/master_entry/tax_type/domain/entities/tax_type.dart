/// Domain model of a tax type component (e.g. GST, CGST, SGST, IGST, CESS).
///
/// This is the shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type leaks
/// into UI code.
class TaxType {
  const TaxType({
    required this.id,
    required this.taxTypeName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  final String taxTypeName;

  final String? description;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// A copy of this entity with the given fields replaced.
  TaxType copyWith({
    String? taxTypeName,
    String? description,
    DateTime? updatedAt,
  }) {
    return TaxType(
      id: id,
      taxTypeName: taxTypeName ?? this.taxTypeName,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
