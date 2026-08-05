import 'package:drift/drift.dart';

/// Atomic tax components (GST, CGST, SGST, IGST, CESS, ...) — extensible by
/// insertion (approved blueprint §3.8).
@DataClassName('TaxType')
class TaxTypes extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'tax_type';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get taxTypeCode => text()();
  TextColumn get taxTypeName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
