import 'package:drift/drift.dart';

import 'unit_table.dart';

/// Global unit conversion rules (approved blueprint §3.6).
///
/// Semantics: `1 to_unit = conversion_factor × from_unit`, i.e.
/// `qty_to = qty_from × conversion_factor`. Only the forward direction is
/// stored — the reverse direction is derived automatically (divide by
/// [conversionFactor]). A conversion never stores a "default" flag; that
/// concept exists only on [ProductUoms].
@DataClassName('UomConversion')
@TableIndex(name: 'idx_uom_from_unit', columns: {#fromUnitId})
@TableIndex(name: 'idx_uom_to_unit', columns: {#toUnitId})
class UomConversions extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'uom_conversion';

  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('fromUnit')
  IntColumn get fromUnitId => integer().references(Units, #id)();
  @ReferenceName('toUnit')
  IntColumn get toUnitId => integer().references(Units, #id)();
  RealColumn get conversionFactor => real()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {fromUnitId, toUnitId},
  ];

  @override
  List<String> get customConstraints => const [
    'CHECK (from_unit_id <> to_unit_id)',
    'CHECK (conversion_factor > 0)',
  ];
}
