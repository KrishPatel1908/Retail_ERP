import 'package:drift/drift.dart';

/// Tax treatment profile applied to products (approved blueprint §3.7).
///
/// The category itself carries no single rate — rates live in
/// `tax_category_rate` as (tax type, rate) pairs.
@DataClassName('TaxCategory')
class TaxCategories extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'tax_category';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get taxCategoryCode => text().unique()();
  TextColumn get taxCategoryName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
