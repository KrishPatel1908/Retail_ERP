import 'package:drift/drift.dart';

import 'purchase_table.dart';
import 'supplier_table.dart';

/// Purchase return header — one row per return transaction.
///
/// Stores the return against an original purchase. Monetary values are
/// stored in paise (int).
@DataClassName('PurchaseReturn')
@TableIndex(name: 'idx_purchase_return_number', columns: {#returnNumber})
@TableIndex(name: 'idx_purchase_return_supplier', columns: {#supplierId})
@TableIndex(name: 'idx_purchase_return_date', columns: {#returnDate})
@TableIndex(
  name: 'idx_purchase_return_original_purchase',
  columns: {#originalPurchaseId},
)
class PurchaseReturns extends Table {
  @override
  String get tableName => 'purchase_return';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get returnNumber => text().unique()();
  IntColumn get originalPurchaseId => integer().references(Purchases, #id)();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  DateTimeColumn get returnDate => dateTime()();
  TextColumn get originalPurchaseNumber => text().nullable()();
  TextColumn get originalInvoiceNumber => text().nullable()();

  /// Subtotal before discount and tax, in paise.
  IntColumn get subtotal => integer().withDefault(const Constant(0))();

  /// Total discount across all items, in paise.
  IntColumn get discount => integer().withDefault(const Constant(0))();

  /// Total tax across all items, in paise.
  IntColumn get tax => integer().withDefault(const Constant(0))();

  /// Grand total = subtotal - discount + tax, in paise.
  IntColumn get total => integer().withDefault(const Constant(0))();

  TextColumn get notes => text().nullable()();

  /// COMPLETED or REVERTED.
  TextColumn get status => text().withDefault(const Constant('COMPLETED'))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
