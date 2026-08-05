import 'package:drift/drift.dart';

/// Units of measure available across the ERP (approved blueprint §3.5, final
/// shape).
///
/// This table only stores *available* units — a name, a symbol, the measure
/// it is used for (`unit_family`) and an optional description. Conversion
/// factors never live here: universal rules live in [UomConversions] and
/// product-specific rules live in [ProductUoms].
///
/// `unit_name` uniqueness is case-insensitive and enforced by the
/// `idx_unit_name_nocase_unique` index (see [DatabaseIndexes]).
@DataClassName('Unit')
class Units extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'unit';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get unitName => text()();
  TextColumn get unitSymbol => text()();
  TextColumn get unitFamily => text().withDefault(const Constant('GENERAL'))();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
