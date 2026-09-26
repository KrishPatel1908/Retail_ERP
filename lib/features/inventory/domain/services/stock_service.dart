import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';

/// The canonical types recorded in `inventory_transaction.transaction_type`.
abstract final class StockMovementType {
  static const String purchase = 'PURCHASE';
  static const String purchaseReturn = 'PURCHASE_RETURN';
  static const String purchaseAdjustment = 'PURCHASE_ADJUSTMENT';
  static const String stockAdjustment = 'STOCK_ADJUSTMENT';
  static const String sale = 'SALE';
  static const String saleReturn = 'SALE_RETURN';
}

/// Direction of a stock adjustment.
enum StockAdjustmentDirection { increase, decrease }

/// Thrown when an operation would drive stock below zero.
///
/// The business rule: stock can never go negative. Callers surface
/// [message] directly to the user.
class InsufficientStockException implements Exception {
  const InsufficientStockException(this.message);

  final String message;

  @override
  String toString() => 'InsufficientStockException: $message';
}

/// The single stock engine used by every stock-affecting module
/// (Purchase, Purchase Return, Stock Adjustment, future Sales).
///
/// Responsibilities:
/// - Maintain `current_stock` atomically alongside `inventory_transaction`.
/// - Record the movement with previous/new stock levels for the history UI.
/// - Reject any operation that would make stock negative — never silently
///   clamp. A rejected operation aborts the surrounding database
///   transaction so stock and its cause stay consistent.
///
/// Every method must be called inside an open database transaction owned by
/// the calling repository. The service itself performs no transaction
/// management so composition stays in one place.
class StockService {
  StockService({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// Reads the current stock for one product/variant.
  ///
  /// A missing row means the item was never stocked and reads as zero.
  Future<int> currentStock(int productId, int? variantId) async {
    final row = await _findStockRow(productId, variantId);
    return row?.quantity ?? 0;
  }

  /// Finds the `current_stock` row for a product/variant, or null when the
  /// item was never stocked.
  Future<db.CurrentStock?> _findStockRow(int productId, int? variantId) async {
    return (_database.select(_database.currentStocks)..where(
          (t) => _stockKeyPredicate(t, productId, variantId),
        ))
        .getSingleOrNull();
  }

  /// Applies [delta] to the current stock and records one movement.
  ///
  /// [quantity] is the signed magnitude stored on the movement (positive for
  /// stock in, negative for stock out). When [quantity] is omitted it
  /// defaults to [delta].
  ///
  /// Throws [InsufficientStockException] when the resulting stock would be
  /// negative, aborting the caller's transaction.
  Future<void> applyStockChange({
    required int productId,
    int? variantId,
    required int delta,
    required String transactionType,
    required DateTime transactionDate,
    String? referenceNumber,
    String? note,
    int? purchaseId,
    int? quantity,
  }) async {
    final movementQuantity = quantity ?? delta;
    final existingRow = await _findStockRow(productId, variantId);
    final stock = existingRow?.quantity ?? 0;
    final newStock = stock + delta;

    if (newStock < 0) {
      throw InsufficientStockException(
        'Insufficient stock. Available stock: $stock.',
      );
    }

    await _database
        .into(_database.inventoryTransactions)
        .insert(
          db.InventoryTransactionsCompanion.insert(
            productId: productId,
            variantId: Value(variantId),
            transactionType: transactionType,
            quantity: movementQuantity,
            previousQuantity: Value(stock),
            newQuantity: Value(newStock),
            purchaseId: Value(purchaseId),
            transactionDate: transactionDate,
            referenceNumber: Value(referenceNumber),
            notes: Value(_normalizeText(note)),
          ),
        );

    if (existingRow == null) {
      // The very first stock for this item: insert the row.
      await _database.into(_database.currentStocks).insert(
            db.CurrentStocksCompanion.insert(
              productId: productId,
              variantId: Value(variantId),
              quantity: Value(newStock),
            ),
          );
    } else {
      await (_database.update(_database.currentStocks)..where(
            (t) => t.id.equals(existingRow.id),
          ))
          .write(
            db.CurrentStocksCompanion(
              quantity: Value(newStock),
              updatedAt: Value(DateTime.now()),
            ),
          );
    }
  }

  /// Records a manual stock adjustment.
  ///
  /// Unlike a purchase (where new stock may be anything ≥ 0), an adjustment
  /// is validated explicitly:
  /// - quantity must be > 0,
  /// - a decrease cannot drive stock below zero,
  /// - reason is required.
  ///
  /// Returns the new stock level.
  Future<int> recordAdjustment({
    required int productId,
    int? variantId,
    required StockAdjustmentDirection direction,
    required int quantity,
    required String reason,
    String? note,
    required DateTime adjustmentDate,
  }) async {
    if (quantity <= 0) {
      throw const InsufficientStockException(
        'Adjustment quantity must be greater than 0.',
      );
    }
    if (reason.trim().isEmpty) {
      throw const InsufficientStockException('A reason is required.');
    }

    final stock = await currentStock(productId, variantId);
    final delta = direction == StockAdjustmentDirection.increase
        ? quantity
        : -quantity;
    final newStock = stock + delta;

    if (newStock < 0) {
      throw InsufficientStockException(
        'Insufficient stock. Available stock: $stock.',
      );
    }

    final details = <String>[
      'Reason: ${reason.trim()}',
      if (_normalizeText(note) != null) 'Note: ${_normalizeText(note)}',
    ].join('\n');

    await applyStockChange(
      productId: productId,
      variantId: variantId,
      delta: delta,
      transactionType: StockMovementType.stockAdjustment,
      transactionDate: adjustmentDate,
      note: details,
    );
    return newStock;
  }

  /// Resolves a scanned/typed barcode to the exact sellable item.
  ///
  /// A variant barcode wins over its parent product barcode; both are
  /// matched case-sensitively and exactly — ambiguous duplicates are
  /// rejected so a scan can never affect the wrong item.
  Future<db.Product?> findProductByBarcode(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return null;

    // Exact variant match first.
    final variantRows =
        await (_database.select(_database.productVariants).join([
              innerJoin(
                _database.products,
                _database.products.id.equalsExp(
                  _database.productVariants.productId,
                ),
              ),
            ])..where(_database.productVariants.barcode.equals(trimmed)))
            .get();
    if (variantRows.length > 1) {
      throw AmbiguousBarcodeException(trimmed);
    }
    if (variantRows.isNotEmpty) {
      return variantRows.single.readTable(_database.products);
    }

    // Then an exact product match.
    final productRows =
        await (_database.select(_database.products)
              ..where((t) => t.barcode.equals(trimmed)))
            .get();
    if (productRows.length > 1) {
      throw AmbiguousBarcodeException(trimmed);
    }
    return productRows.isEmpty ? null : productRows.single;
  }

  /// Resolves a barcode to the exact product/variant pair, if any.
  Future<({int productId, int? variantId})?> resolveStockItem(
    String barcode,
  ) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return null;

    final variantRow =
        await (_database.select(_database.productVariants)
              ..where((t) => t.barcode.equals(trimmed)))
            .getSingleOrNull();
    if (variantRow != null) {
      return (productId: variantRow.productId, variantId: variantRow.id);
    }

    final productRow =
        await (_database.select(_database.products)
              ..where((t) => t.barcode.equals(trimmed)))
            .getSingleOrNull();
    if (productRow != null) {
      return (productId: productRow.id, variantId: null);
    }
    return null;
  }

  Expression<bool> _stockKeyPredicate(
    db.$CurrentStocksTable t,
    int productId,
    int? variantId,
  ) {
    return t.productId.equals(productId) &
        (variantId != null
            ? t.variantId.equals(variantId)
            : (t.variantId.isNull() | t.variantId.equals(0)));
  }

  String? _normalizeText(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

/// Thrown when a barcode matches more than one sellable item.
class AmbiguousBarcodeException implements Exception {
  const AmbiguousBarcodeException(this.barcode);

  final String barcode;

  @override
  String toString() =>
      'AmbiguousBarcodeException: barcode "$barcode" matches multiple items';
}
