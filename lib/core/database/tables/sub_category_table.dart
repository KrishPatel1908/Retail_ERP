import 'package:drift/drift.dart';

import 'category_table.dart';

/// Second-level product grouping; each row belongs to exactly one category
/// (approved blueprint §3.3).
///
/// The `(category_id, sub_category_name)` pair is unique case-insensitively
/// (index `idx_sub_category_name_nocase_unique`). The `(category_id, id)`
/// unique key backs the composite foreign key from `product`.
@DataClassName('SubCategory')
@TableIndex(name: 'idx_sub_category_category', columns: {#categoryId})
class SubCategories extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'sub_category';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get subCategoryCode => text().unique()();
  TextColumn get subCategoryName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {categoryId, id},
  ];
}
