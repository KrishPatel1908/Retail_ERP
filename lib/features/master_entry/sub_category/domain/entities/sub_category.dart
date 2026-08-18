/// Domain model of a product sub-category.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code.
class SubCategory {
  const SubCategory({
    required this.id,
    required this.categoryId,
    this.categoryName,
    required this.subCategoryCode,
    required this.subCategoryName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  /// Foreign key referencing the parent [Category].
  final int categoryId;

  /// Display name of the parent category (hydrated via join).
  final String? categoryName;

  /// Human-readable, unique code (e.g. `SUB-0001`).
  final String subCategoryCode;

  final String subCategoryName;

  final String? description;

  final bool isActive;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// A copy of this entity with the given fields replaced.
  SubCategory copyWith({
    int? categoryId,
    String? categoryName,
    String? subCategoryCode,
    String? subCategoryName,
    String? description,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return SubCategory(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subCategoryCode: subCategoryCode ?? this.subCategoryCode,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
