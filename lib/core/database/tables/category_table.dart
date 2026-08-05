import 'package:drift/drift.dart';

/// Product top-level grouping (approved blueprint §3.2).
///
/// `category_name` uniqueness is case-insensitive and enforced by the
/// `idx_category_name_nocase_unique` index.
@DataClassName('Category')
class Categories extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'category';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryCode => text().unique()();
  TextColumn get categoryName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
