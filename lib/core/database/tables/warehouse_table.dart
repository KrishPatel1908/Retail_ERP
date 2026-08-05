import 'package:drift/drift.dart';

/// Physical stock locations; fully multi-warehouse from day one
/// (approved blueprint §3.12).
@DataClassName('Warehouse')
class Warehouses extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'warehouse';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get warehouseCode => text().unique()();
  TextColumn get warehouseName => text()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
