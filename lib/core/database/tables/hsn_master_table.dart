import 'package:drift/drift.dart';

import 'tax_category_table.dart';

/// Single source of truth for HSN codes; products reference this table
/// instead of duplicating HSN strings (approved blueprint §3.9).
@DataClassName('HsnMaster')
@TableIndex(
  name: 'idx_hsn_default_tax_category',
  columns: {#defaultTaxCategoryId},
)
class HsnMasters extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'hsn_master';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get hsnCode => text()();
  TextColumn get description => text()();
  IntColumn get defaultTaxCategoryId =>
      integer().nullable().references(TaxCategories, #id)();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
