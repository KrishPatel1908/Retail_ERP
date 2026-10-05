import 'package:drift/drift.dart';

import 'product_table.dart';
import 'sale_table.dart';
import 'unit_table.dart';

/// Sale line items — each row represents one product/variant sold in a sale.
///
/// Stores snapshots of product name, variant name, barcode, selling price,
/// unit name, discount, tax rate, and tax amount at the time of sale.
/// Monetary values are stored in paise (int).
@DataClassName('SaleItem')
@TableIndex(name: 'idx_sale_item_sale', columns: {#saleId})
@TableIndex(name: 'idx_sale_item_product', columns: {#productId})
@TableIndex(name: 'idx_sale_item_variant', columns: {#variantId})
class SaleItems extends Table {
  @override
  String get tableName => 'sale_item';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId =>
      integer().references(Sales, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId =>
      integer().nullable().references(ProductVariants, #id)();

  /// Product name snapshot at time of sale.
  TextColumn get productName => text()();

  /// Variant name snapshot at time of sale.
  TextColumn get variantName => text().nullable()();

  /// Barcode snapshot at time of sale.
  TextColumn get barcode => text().nullable()();

  /// Unit of measure snapshot at time of sale.
  IntColumn get unitId => integer().references(Units, #id)();
  TextColumn get unitName => text()();

  /// Quantity sold (supports fractional values like 0.5 kg).
  RealColumn get quantity => real().withDefault(const Constant(1.0))();

  /// Selling price per unit at time of sale, in paise.
  IntColumn get unitPrice => integer()();

  /// Line-level discount, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Tax rate percent (e.g. 18.0 for 18%).
  RealColumn get taxRate => real().withDefault(const Constant(0.0))();

  /// Tax amount in paise.
  IntColumn get taxAmount => integer().withDefault(const Constant(0))();

  /// lineTotal = (qty * unitPrice) - discount + taxAmount, in paise.
  IntColumn get lineTotal => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
