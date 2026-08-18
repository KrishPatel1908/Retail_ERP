/// Domain model of a product brand.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code.
class Brand {
  const Brand({
    required this.id,
    required this.brandName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.productCount = 0,
  });

  final int id;

  final String brandName;

  final String? description;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// Dynamically calculated count of products associated with this brand.
  final int productCount;

  /// A copy of this entity with the given fields replaced.
  Brand copyWith({
    String? brandName,
    String? description,
    DateTime? updatedAt,
    int? productCount,
  }) {
    return Brand(
      id: id,
      brandName: brandName ?? this.brandName,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productCount: productCount ?? this.productCount,
    );
  }
}
