import 'package:drift/drift.dart';

import 'product_table.dart';
import 'purchase_table.dart';

/// Inventory transaction — records every stock change with its cause.
///
/// Enables future reports such as "Where did this stock come from?"
/// Types: PURCHASE, PURCHASE_RETURN, MANUAL_ADJUSTMENT, SALE (future).
@DataClassName('InventoryTransaction')
@TableIndex(
  name: 'idx_inv_txn_product_variant',
  columns: {#productId, #variantId},
)
@TableIndex(name: 'idx_inv_txn_type', columns: {#transactionType})
@TableIndex(name: 'idx_inv_txn_date', columns: {#transactionDate})
@TableIndex(name: 'idx_inv_txn_purchase', columns: {#purchaseId})
class InventoryTransactions extends Table {
  @override
  String get tableName => 'inventory_transaction';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId =>
      integer().nullable().references(ProductVariants, #id)();

  /// PURCHASE, PURCHASE_RETURN, MANUAL_ADJUSTMENT, SALE.
  TextColumn get transactionType => text()();

  /// Positive for stock in, negative for stock out.
  IntColumn get quantity => integer()();

  /// Reference purchase ID for purchase/return transactions.
  IntColumn get purchaseId =>
      integer().nullable().references(Purchases, #id)();

  DateTimeColumn get transactionDate => dateTime()();

  TextColumn get referenceNumber => text().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
