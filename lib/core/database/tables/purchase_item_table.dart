import 'package:drift/drift.dart';

import 'product_table.dart';
import 'purchase_table.dart';
import 'unit_table.dart';

/// Purchase line items — each row represents one product/variant purchased.
///
/// Stores the snapshot of the purchase price and tax at the time of purchase.
/// Monetary values are stored in paise (int).
@DataClassName('PurchaseItem')
@TableIndex(name: 'idx_purchase_item_purchase', columns: {#purchaseId})
@TableIndex(name: 'idx_purchase_item_product', columns: {#productId})
@TableIndex(name: 'idx_purchase_item_variant', columns: {#variantId})
class PurchaseItems extends Table {
  @override
  String get tableName => 'purchase_item';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId =>
      integer().nullable().references(ProductVariants, #id)();

  /// Quantity purchased.
  IntColumn get quantity => integer()();

  /// Unit of measure — references the product's unit.
  IntColumn get unitId => integer().references(Units, #id)();

  /// Price per unit paid to supplier, in paise.
  IntColumn get purchasePrice => integer()();

  /// Line-level discount, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Tax rate percent (e.g. 18 for 18%).
  RealColumn get taxRate => real().withDefault(const Constant(0))();

  /// Tax amount in paise.
  IntColumn get taxAmount => integer().withDefault(const Constant(0))();

  /// line_total = (qty * price) - discount + tax_amount, in paise.
  IntColumn get lineTotal => integer().withDefault(const Constant(0))();

  /// For returns: quantity returned against this item.
  IntColumn get returnedQuantity => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
