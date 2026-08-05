import 'package:drift/drift.dart';

/// Product brand dictionary (approved blueprint §3.4).
///
/// `brand_name` uniqueness is case-insensitive and enforced by the
/// `idx_brand_name_nocase_unique` index.
@DataClassName('Brand')
class Brands extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'brand';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get brandCode => text().unique()();
  TextColumn get brandName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
