import 'package:drift/drift.dart';

import 'product_table.dart';

/// Current stock levels per product/variant.
///
/// This is a cached/materialized view maintained by the inventory transaction
/// engine. It is updated atomically alongside inventory transactions.
@DataClassName('CurrentStock')
@TableIndex(
  name: 'idx_stock_product_variant',
  columns: {#productId, #variantId},
  unique: true,
)
class CurrentStocks extends Table {
  @override
  String get tableName => 'current_stock';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId =>
      integer().nullable().references(ProductVariants, #id)();

  /// Current quantity on hand.
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
