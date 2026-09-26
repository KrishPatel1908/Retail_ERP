import 'package:drift/drift.dart';

import 'purchase_item_table.dart';
import 'purchase_return_table.dart';

/// Purchase return line items — each row represents one product/variant returned.
///
/// Stores the snapshot of the purchase price and tax from the original purchase
/// at the time of return. Monetary values are stored in paise (int).
@DataClassName('PurchaseReturnItem')
@TableIndex(
  name: 'idx_purchase_return_item_return',
  columns: {#purchaseReturnId},
)
@TableIndex(
  name: 'idx_purchase_return_item_purchase_item',
  columns: {#purchaseItemId},
)
class PurchaseReturnItems extends Table {
  @override
  String get tableName => 'purchase_return_item';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseReturnId =>
      integer().references(PurchaseReturns, #id)();
  IntColumn get purchaseItemId => integer().references(PurchaseItems, #id)();

  /// Quantity returned.
  IntColumn get returnQuantity => integer()();

  /// Price per unit from the original purchase, in paise.
  IntColumn get purchasePrice => integer()();

  /// Line-level discount from the original purchase, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Tax rate percent from the original purchase (e.g. 18 for 18%).
  RealColumn get taxRate => real().withDefault(const Constant(0))();

  /// Tax amount in paise.
  IntColumn get taxAmount => integer().withDefault(const Constant(0))();

  /// line_total = (qty * price) - discount + tax_amount, in paise.
  IntColumn get lineTotal => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
