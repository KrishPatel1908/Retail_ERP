import 'package:drift/drift.dart';

import 'product_table.dart';
import 'unit_table.dart';

/// Per-product conversion rules (approved blueprint §4.2, final shape).
///
/// A row reads `1 to_unit = conversion_factor × from_unit` for the given
/// product — e.g. for product Banana: from Dozen, to Piece, factor 12 means
/// "1 Dozen = 12 Piece". Several conversions per product are allowed as long
/// as the combination (product, from unit, to unit, factor) is unique;
/// exact duplicates are rejected.
///
/// Only this table has a "default" conversion per product. At most one row
/// per product may be flagged `is_default` — enforced by the partial unique
/// index `idx_product_uom_one_default` (see [DatabaseIndexes]).
@DataClassName('ProductUom')
class ProductUoms extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'product_uom';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  @ReferenceName('productUomsFrom')
  IntColumn get fromUnitId => integer().references(Units, #id)();
  @ReferenceName('productUomsTo')
  IntColumn get toUnitId => integer().references(Units, #id)();
  RealColumn get conversionFactor => real()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {productId, fromUnitId, toUnitId, conversionFactor},
  ];

  @override
  List<String> get customConstraints => const [
    'CHECK (from_unit_id <> to_unit_id)',
    'CHECK (conversion_factor > 0)',
  ];
}
