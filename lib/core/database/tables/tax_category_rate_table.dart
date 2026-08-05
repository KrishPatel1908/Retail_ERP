import 'package:drift/drift.dart';

import 'tax_category_table.dart';
import 'tax_type_table.dart';

/// Rate breakdown of a tax category (approved blueprint §3.7).
///
/// E.g. `GST 18%` = CGST 9 + SGST 9 (+ IGST 18 for inter-state).
@DataClassName('TaxCategoryRate')
@TableIndex(name: 'idx_rate_tax_category', columns: {#taxCategoryId})
@TableIndex(name: 'idx_rate_tax_type', columns: {#taxTypeId})
class TaxCategoryRates extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'tax_category_rate';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get taxCategoryId => integer().references(TaxCategories, #id)();
  IntColumn get taxTypeId => integer().references(TaxTypes, #id)();
  RealColumn get ratePercent => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {taxCategoryId, taxTypeId},
  ];

  @override
  List<String> get customConstraints => const [
    'CHECK (rate_percent >= 0 AND rate_percent <= 100)',
  ];
}
