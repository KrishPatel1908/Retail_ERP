/// Domain model of a product category.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code.
class Category {
  const Category({
    required this.id,
    required this.categoryCode,
    required this.categoryName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  /// Human-readable, auto-generated code (e.g. `CAT-0001`).
  final String categoryCode;

  final String categoryName;

  final String? description;

  final bool isActive;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// A copy of this entity with the given fields replaced.
  Category copyWith({
    String? categoryName,
    String? description,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id,
      categoryCode: categoryCode,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
