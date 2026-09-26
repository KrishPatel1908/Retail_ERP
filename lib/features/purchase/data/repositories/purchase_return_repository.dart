import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_return.dart';

/// Filter parameters for the purchase return list.
class PurchaseReturnFilters {
  const PurchaseReturnFilters({
    this.supplierId,
    this.returnDateFrom,
    this.returnDateTo,
    this.status,
  });

  final int? supplierId;
  final DateTime? returnDateFrom;
  final DateTime? returnDateTo;
  final PurchaseReturnStatus? status;
}

/// Paginated purchase return list result.
class PurchaseReturnPage {
  const PurchaseReturnPage({required this.items, required this.totalCount});

  final List<PurchaseReturnEntity> items;
  final int totalCount;
}

/// A returnable item row: a purchase item whose product can be returned,
/// along with current available stock for that product/variant.
class ReturnableItem {
  const ReturnableItem({
    required this.purchaseItem,
    required this.currentStock,
    required this.purchasePrice,
    required this.discount,
    required this.taxRate,
    required this.unitTax,
    required this.unitLineTotal,
  });

  final PurchaseItemEntity purchaseItem;

  /// Current available stock for the product/variant.
  final int currentStock;

  /// Per-unit purchase price from the original purchase (paise).
  final int purchasePrice;

  /// Line discount from the original purchase (paise).
  final int discount;

  /// Tax rate percent from the original purchase.
  final double taxRate;

  /// Precomputed tax amount for a single unit (paise).
  final int unitTax;

  /// Precomputed line total for a single unit (paise).
  final int unitLineTotal;

  /// The original purchase item id this returnable item maps to.
  int get purchaseItemId => purchaseItem.id;
}

/// Input data for a return line item.
class PurchaseReturnItemInput {
  const PurchaseReturnItemInput({
    required this.purchaseItemId,
    required this.productId,
    this.variantId,
    required this.returnQuantity,
    required this.purchasePrice,
    this.discount = 0,
    required this.taxRate,
  });

  final int purchaseItemId;
  final int productId;
  final int? variantId;
  final int returnQuantity;
  final int purchasePrice;
  final int discount;
  final double taxRate;
}

/// Exceptions for purchase return operations.
class PurchaseReturnNotFoundException implements Exception {
  const PurchaseReturnNotFoundException(int id)
    : message = 'Purchase return with id $id not found.';

  final String message;

  @override
  String toString() => 'PurchaseReturnNotFoundException: $message';
}

class PurchaseReturnValidationException implements Exception {
  const PurchaseReturnValidationException(this.message);

  final String message;

  @override
  String toString() => 'PurchaseReturnValidationException: $message';
}

class PurchaseReturnOperationException implements Exception {
  const PurchaseReturnOperationException(this.message);

  final String message;

  @override
  String toString() => 'PurchaseReturnOperationException: $message';
}

/// Data access and business logic for purchase returns.
///
/// All monetary values exchanged with this repository are in paise.
class PurchaseReturnRepository {
  PurchaseReturnRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database,
      _stockService = StockService(database: database);

  final db.AppDatabase _database;
  final StockService _stockService;

  // ──────────────────── LISTING ────────────────────

  /// Returns one page of purchase returns matching [query] and [filters].
  Future<PurchaseReturnPage> fetchPage({
    String query = '',
    PurchaseReturnFilters filters = const PurchaseReturnFilters(),
    bool sortAscending = false,
    int page = 1,
    int pageSize = 25,
  }) async {
    final pr = _database.purchaseReturns;
    final s = _database.suppliers;

    final predicate = _buildPredicate(
      pr: pr,
      s: s,
      normalizedQuery: query.trim().toLowerCase(),
      filters: filters,
    );

    final countExpr = pr.id.count();
    final countQuery = _database.selectOnly(_database.purchaseReturns);
    countQuery.addColumns([countExpr]);
    if (predicate != null) countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    final rowsQuery = _database.select(pr).join([
      innerJoin(s, s.id.equalsExp(pr.supplierId)),
    ]);
    if (predicate != null) rowsQuery.where(predicate);
    rowsQuery.orderBy([
      sortAscending
          ? OrderingTerm.asc(pr.returnDate)
          : OrderingTerm.desc(pr.returnDate),
      sortAscending ? OrderingTerm.asc(pr.id) : OrderingTerm.desc(pr.id),
    ]);
    rowsQuery.limit(pageSize, offset: (page < 1 ? 1 : page - 1) * pageSize);

    final rows = await rowsQuery.get();
    final items = rows.map((row) => _fromTypedResult(row)).toList();

    return PurchaseReturnPage(items: items, totalCount: total);
  }

  /// Lists purchases belonging to a supplier that can be returned against.
  /// Only non-return, active purchases from the selected supplier.
  Future<List<PurchaseEntity>> purchasesForSupplier(int supplierId) async {
    final p = _database.purchases;
    final s = _database.suppliers;

    final rows =
        await (_database.select(p).join([
                innerJoin(s, s.id.equalsExp(p.supplierId)),
              ])
              ..where(
                p.supplierId.equals(supplierId) &
                    p.isReturn.equals(false) &
                    p.isActive.equals(true),
              )
              ..orderBy([OrderingTerm.desc(p.purchaseDate)]))
            .get();

    return rows.map((row) {
      final purchase = row.readTable(p);
      final supplier = row.readTable(s);
      return PurchaseEntity(
        id: purchase.id,
        purchaseNumber: purchase.purchaseNumber,
        supplierId: purchase.supplierId,
        supplierName: supplier.supplierName,
        supplierCode: supplier.supplierCode,
        purchaseDate: purchase.purchaseDate,
        invoiceNumber: purchase.invoiceNumber,
        subtotal: purchase.subtotal,
        discount: purchase.discount,
        tax: purchase.tax,
        total: purchase.total,
        paidAmount: purchase.paidAmount,
        dueAmount: purchase.dueAmount,
        paymentStatus: PurchasePaymentStatus.fromDbValue(
          purchase.paymentStatus,
        ),
        paymentMethod: purchase.paymentMethod,
        notes: purchase.notes,
        isReturn: purchase.isReturn,
        originalPurchaseId: purchase.originalPurchaseId,
        isActive: purchase.isActive,
        createdAt: purchase.createdAt,
        updatedAt: purchase.updatedAt,
      );
    }).toList();
  }

  /// Distinct active suppliers with a non-return purchase.
  Future<List<({int id, String name})>> distinctSuppliers() async {
    final p = _database.purchases;
    final s = _database.suppliers;

    final rows =
        await (_database.select(p).join([
                innerJoin(s, s.id.equalsExp(p.supplierId)),
              ])
              ..where(p.isReturn.equals(false) & p.isActive.equals(true))
              ..orderBy([OrderingTerm.asc(p.supplierId)]))
            .get();

    final seen = <int>{};
    final result = <({int id, String name})>[];
    for (final row in rows) {
      final supplier = row.readTable(s);
      if (seen.add(supplier.id)) {
        result.add((id: supplier.id, name: supplier.supplierName));
      }
    }
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return result;
  }

  /// Returns the original purchase items that still have quantity eligible for
  /// return, along with the current available stock for each.
  ///
  /// A line remains visible even when its stock is zero. Hiding it makes the
  /// return form look incomplete and prevents the user from seeing why that
  /// item cannot currently be returned. The UI and create validation continue
  /// to enforce the available-stock limit.
  Future<List<ReturnableItem>> returnableItemsForPurchase(
    int purchaseId,
  ) async {
    final purchase = await _getPurchaseDetail(purchaseId);

    final items = <ReturnableItem>[];
    for (final item in purchase.items) {
      final stock = await _currentStock(item.productId, item.variantId);

      final unitSubtotal = item.purchasePrice;
      final unitDiscount = item.discount != 0 && item.quantity > 0
          ? (item.discount / item.quantity).round()
          : 0;
      final unitTaxable = unitSubtotal - unitDiscount;
      final unitTax = (unitTaxable * item.taxRate / 100).round();
      final unitLineTotal = unitTaxable + unitTax;

      items.add(
        ReturnableItem(
          purchaseItem: item,
          currentStock: stock,
          purchasePrice: item.purchasePrice,
          discount: unitDiscount,
          taxRate: item.taxRate,
          unitTax: unitTax,
          unitLineTotal: unitLineTotal,
        ),
      );
    }
    return items;
  }

  // ──────────────────── GET BY ID ────────────────────

  /// Gets a purchase return by ID with all line items.
  Future<PurchaseReturnEntity> getById(int id) async {
    final pr = _database.purchaseReturns;
    final s = _database.suppliers;

    final query = _database.select(pr).join([
      innerJoin(s, s.id.equalsExp(pr.supplierId)),
    ])..where(pr.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) throw PurchaseReturnNotFoundException(id);

    final entity = _fromTypedResult(row);
    final items = await _getItems(id);

    return PurchaseReturnEntity(
      id: entity.id,
      returnNumber: entity.returnNumber,
      originalPurchaseId: entity.originalPurchaseId,
      originalPurchaseNumber: entity.originalPurchaseNumber,
      originalInvoiceNumber: entity.originalInvoiceNumber,
      supplierId: entity.supplierId,
      supplierName: entity.supplierName,
      supplierCode: entity.supplierCode,
      returnDate: entity.returnDate,
      subtotal: entity.subtotal,
      discount: entity.discount,
      tax: entity.tax,
      total: entity.total,
      notes: entity.notes,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      items: items,
    );
  }

  // ──────────────────── CREATE ────────────────────

  /// Creates a purchase return with items, adjusting inventory and supplier
  /// payable. Runs entirely inside one database transaction.
  Future<PurchaseReturnEntity> createReturn({
    required int originalPurchaseId,
    required int supplierId,
    required DateTime returnDate,
    String? notes,
    required List<PurchaseReturnItemInput> items,
  }) async {
    if (items.isEmpty) {
      throw const PurchaseReturnValidationException(
        'Please enter a return quantity for at least one product.',
      );
    }

    return _database.transaction(() async {
      final originalPurchase = await _getPurchaseDetail(originalPurchaseId);

      if (originalPurchase.supplierId != supplierId) {
        throw const PurchaseReturnValidationException(
          'Supplier does not match the original purchase.',
        );
      }

      // 1. Validate quantities against original purchase AND current stock.
      final validatedItems = <_ValidatedItem>[];
      for (final ri in items) {
        final originalItem = originalPurchase.items.firstWhere(
          (item) =>
              item.id == ri.purchaseItemId ||
              (item.productId == ri.productId && item.variantId == ri.variantId),
          orElse: () => throw PurchaseReturnValidationException(
            'Product/variant not found in original purchase.',
          ),
        );

        // Returns must not exceed what remains from the original purchase
        // after previous returns.
        final alreadyReturned = await _totalReturnedForPurchaseItem(
          originalItem.id,
        );
        final maxFromPurchase = originalItem.quantity - alreadyReturned;

        if (ri.returnQuantity < 0) {
          throw const PurchaseReturnValidationException(
            'Return quantity cannot be negative.',
          );
        }

        // Current stock check: never return more than available stock.
        final currentStock = await _currentStock(ri.productId, ri.variantId);
        if (ri.returnQuantity > currentStock) {
          throw PurchaseReturnValidationException(
            'Return quantity cannot exceed available stock. '
            'Available: $currentStock.',
          );
        }
        if (ri.returnQuantity > maxFromPurchase) {
          throw PurchaseReturnValidationException(
            'Cannot return ${ri.returnQuantity} of '
            '"${originalItem.productName}". Only $maxFromPurchase can be '
            'returned (purchased: ${originalItem.quantity}, already returned: '
            '$alreadyReturned).',
          );
        }

        if (ri.returnQuantity == 0) {
          continue;
        }

        if (currentStock <= 0) {
          throw PurchaseReturnValidationException(
            'No stock available for return of "${originalItem.productName}".',
          );
        }

        validatedItems.add(
          _ValidatedItem(
            originalItem: originalItem,
            input: ri,
            currentStock: currentStock,
          ),
        );
      }

      if (validatedItems.isEmpty) {
        throw const PurchaseReturnValidationException(
          'Please enter a return quantity for at least one product.',
        );
      }

      // 2. Generate return number.
      final returnNumber = await _nextReturnNumber();

      // 3. Calculate return totals (using original purchase prices).
      int subtotal = 0;
      int totalDiscount = 0;
      int totalTax = 0;

      for (final v in validatedItems) {
        final ri = v.input;
        final lineSubtotal = ri.returnQuantity * ri.purchasePrice;
        final lineDiscount = ri.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * ri.taxRate / 100).round();

        subtotal += lineSubtotal;
        totalDiscount += lineDiscount;
        totalTax += lineTax;
      }

      final grandTotal = subtotal - totalDiscount + totalTax;

      // 4. Insert purchase return header.
      final returnId = await _database
          .into(_database.purchaseReturns)
          .insert(
            db.PurchaseReturnsCompanion.insert(
              returnNumber: returnNumber,
              originalPurchaseId: originalPurchaseId,
              supplierId: supplierId,
              returnDate: returnDate,
              originalPurchaseNumber: Value(originalPurchase.purchaseNumber),
              originalInvoiceNumber: Value(originalPurchase.invoiceNumber),
              subtotal: Value(subtotal),
              discount: Value(totalDiscount),
              tax: Value(totalTax),
              total: Value(grandTotal),
              notes: Value(_normalizeText(notes)),
              status: const Value('COMPLETED'),
            ),
          );

      // 5. Insert return items + adjust inventory.
      for (final v in validatedItems) {
        final ri = v.input;
        final lineSubtotal = ri.returnQuantity * ri.purchasePrice;
        final lineDiscount = ri.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * ri.taxRate / 100).round();
        final lineTotal = taxableAmount + lineTax;

        await _database
            .into(_database.purchaseReturnItems)
            .insert(
              db.PurchaseReturnItemsCompanion.insert(
                purchaseReturnId: returnId,
                purchaseItemId: v.originalItem.id,
                returnQuantity: ri.returnQuantity,
                purchasePrice: ri.purchasePrice,
                discount: Value(ri.discount),
                taxRate: Value(ri.taxRate),
                taxAmount: Value(lineTax),
                lineTotal: Value(lineTotal),
              ),
            );

        // Reverse inventory (stock decrease) via the stock service.
        await _stockService.applyStockChange(
          productId: ri.productId,
          variantId: ri.variantId,
          delta: -ri.returnQuantity,
          transactionType: StockMovementType.purchaseReturn,
          transactionDate: returnDate,
          referenceNumber: returnNumber,
          purchaseId: originalPurchaseId,
          note: 'Purchase return',
        );

        // Update the original purchase item's returned_quantity.
        final newReturned = v.originalItem.returnedQuantity + ri.returnQuantity;
        await (_database.update(
          _database.purchaseItems,
        )..where((t) => t.id.equals(v.originalItem.id))).write(
          db.PurchaseItemsCompanion(
            returnedQuantity: Value(newReturned),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // 6. Reduce supplier payable by the return amount (Debit).
      await _updateSupplierPayable(supplierId, delta: -grandTotal);

      // 7. Append a Debit financial event to the supplier's return.
      await _appendReturnTransaction(
        purchaseId: originalPurchaseId,
        supplierId: supplierId,
        credit: 0,
        debit: grandTotal,
        transactionDate: returnDate,
        note: 'Return $returnNumber',
      );

      return getById(returnId);
    });
  }

  // ──────────────────── REVERT ────────────────────

  /// Reverts a purchase return: reverses its inventory and supplier
  /// accounting effect while preserving the original return in history.
  ///
  /// Runs atomically. The return must not already be reverted.
  Future<void> revertReturn(int id, {DateTime? revertDate}) async {
    await _database.transaction(() async {
      final existing = await getById(id);

      if (existing.isReverted) {
        throw const PurchaseReturnOperationException(
          'This purchase return has already been reverted.',
        );
      }

      // Validate inventory state before reversing stock. Reversing adds back
      // the returned quantity, which only ever increases stock. Validate the
      // original purchase still exists so the inventory transaction can
      // reference a valid purchase.
      final originalExists =
          await (_database.selectOnly(_database.purchases)
                ..addColumns([const Constant(1)])
                ..where(
                  _database.purchases.id.equals(existing.originalPurchaseId),
                ))
              .getSingleOrNull();
      if (originalExists == null) {
        throw const PurchaseReturnOperationException(
          'The original purchase no longer exists. Revert is not possible.',
        );
      }

      // 1. Reverse inventory effect (add stock back).
      for (final item in existing.items) {
        // item.productId / variantId are populated by _getItems.
        await _stockService.applyStockChange(
          productId: item.productId,
          variantId: item.variantId,
          delta: item.returnQuantity,
          transactionType: StockMovementType.purchaseReturn,
          transactionDate: revertDate ?? DateTime.now(),
          referenceNumber: existing.returnNumber,
          purchaseId: existing.originalPurchaseId,
          note: 'Purchase return reverted',
        );

        // Reduce the original purchase item's returned_quantity.
        final originalItem = await (_database.select(
          _database.purchaseItems,
        )..where((t) => t.id.equals(item.purchaseItemId))).getSingleOrNull();
        if (originalItem != null) {
          final newReturned =
              (originalItem.returnedQuantity - item.returnQuantity).clamp(
                0,
                1 << 31,
              );
          await (_database.update(
            _database.purchaseItems,
          )..where((t) => t.id.equals(item.purchaseItemId))).write(
            db.PurchaseItemsCompanion(
              returnedQuantity: Value(newReturned < 0 ? 0 : newReturned),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      // 2. Reverse supplier accounting effect (reduce Debit, add back Credit
      //    equivalent → increases payable by the return amount).
      if (existing.total != 0) {
        await _updateSupplierPayable(
          existing.supplierId,
          delta: existing.total,
        );

        await _appendReturnTransaction(
          purchaseId: existing.originalPurchaseId,
          supplierId: existing.supplierId,
          credit: existing.total,
          debit: 0,
          transactionDate: DateTime.now(),
          note: 'Return ${existing.returnNumber} reverted',
        );
      }

      // 3. Mark return as Reverted.
      await (_database.update(
        _database.purchaseReturns,
      )..where((t) => t.id.equals(id))).write(
        db.PurchaseReturnsCompanion(
          status: const Value('REVERTED'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  // ──────────────────── DELETE ────────────────────

  /// Permanently deletes a purchase return and all its associated records.
  ///
  /// Runs atomically. Unlike revert, this removes the return entirely.
  Future<void> deleteReturn(int id) async {
    await _database.transaction(() async {
      final existing = await getById(id);

      // 1. Load the return's items BEFORE removing them — the restore steps
      //    below need each item's product/variant and quantity.
      final items = await _getItems(id);

      // 2. Remove associated return items.
      await (_database.delete(
        _database.purchaseReturnItems,
      )..where((t) => t.purchaseReturnId.equals(id))).go();

      // 3. Remove associated inventory transactions for this return
      //    (matching the return's reference number).
      await (_database.delete(
        _database.inventoryTransactions,
      )..where((t) => t.referenceNumber.equals(existing.returnNumber))).go();

      // 4. Restore the original purchase item's returned_quantity.
      for (final item in items) {
        final originalItem = await (_database.select(
          _database.purchaseItems,
        )..where((t) => t.id.equals(item.purchaseItemId))).getSingleOrNull();
        if (originalItem != null) {
          final restored = (originalItem.returnedQuantity - item.returnQuantity)
              .clamp(0, 1 << 31);
          await (_database.update(
            _database.purchaseItems,
          )..where((t) => t.id.equals(item.purchaseItemId))).write(
            db.PurchaseItemsCompanion(
              returnedQuantity: Value(restored < 0 ? 0 : restored),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      // 5. Reverse inventory for the deleted return (only when it was not
      //    reverted — a reverted return already reversed its stock).
      if (!existing.isReverted) {
        for (final item in items) {
          await _stockService.applyStockChange(
            productId: item.productId,
            variantId: item.variantId,
            delta: item.returnQuantity,
            transactionType: StockMovementType.purchaseReturn,
            transactionDate: DateTime.now(),
            referenceNumber: existing.returnNumber,
            purchaseId: existing.originalPurchaseId,
            note: 'Purchase return deleted',
          );
        }
      }

      // 6. Reverse supplier accounting effect (only if not already reverted).
      if (!existing.isReverted && existing.total != 0) {
        await _updateSupplierPayable(
          existing.supplierId,
          delta: existing.total,
        );
      }

      // 7. Remove the return's associated supplier financial event.
      //    The inventory_transaction removal above already covered the
      //    inventory side; the supplier financial event lives in
      //    purchase_transaction. We remove the matching reversal rows.
      await _deleteReturnFinancialEvents(existing);

      // 8. Remove the return header.
      await (_database.delete(
        _database.purchaseReturns,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  // ──────────────────── INTERNALS ────────────────────

  Future<PurchaseEntity> _getPurchaseDetail(int purchaseId) async {
    final p = _database.purchases;
    final s = _database.suppliers;

    final row = await (_database.select(p).join([
      innerJoin(s, s.id.equalsExp(p.supplierId)),
    ])..where(p.id.equals(purchaseId))).getSingleOrNull();
    if (row == null) {
      throw PurchaseReturnValidationException('Original purchase not found.');
    }

    final purchase = row.readTable(p);
    final supplier = row.readTable(s);
    final items = await _getPurchaseItems(purchaseId);

    return PurchaseEntity(
      id: purchase.id,
      purchaseNumber: purchase.purchaseNumber,
      supplierId: purchase.supplierId,
      supplierName: supplier.supplierName,
      supplierCode: supplier.supplierCode,
      purchaseDate: purchase.purchaseDate,
      invoiceNumber: purchase.invoiceNumber,
      subtotal: purchase.subtotal,
      discount: purchase.discount,
      tax: purchase.tax,
      total: purchase.total,
      paidAmount: purchase.paidAmount,
      dueAmount: purchase.dueAmount,
      paymentStatus: PurchasePaymentStatus.fromDbValue(purchase.paymentStatus),
      paymentMethod: purchase.paymentMethod,
      notes: purchase.notes,
      isReturn: purchase.isReturn,
      originalPurchaseId: purchase.originalPurchaseId,
      isActive: purchase.isActive,
      createdAt: purchase.createdAt,
      updatedAt: purchase.updatedAt,
      items: items,
    );
  }

  Future<List<PurchaseItemEntity>> _getPurchaseItems(int purchaseId) async {
    final pi = _database.purchaseItems;
    final p = _database.products;
    final pv = _database.productVariants;
    final u = _database.units;

    final rows =
        await (_database.select(pi).join([
                leftOuterJoin(p, p.id.equalsExp(pi.productId)),
                leftOuterJoin(pv, pv.id.equalsExp(pi.variantId)),
                leftOuterJoin(u, u.id.equalsExp(pi.unitId)),
              ])
              ..where(pi.purchaseId.equals(purchaseId))
              ..orderBy([OrderingTerm.asc(pi.id)]))
            .get();

    return rows.map((row) {
      final item = row.readTable(pi);
      final product = row.readTableOrNull(p);
      final variant = row.readTableOrNull(pv);
      final unit = row.readTableOrNull(u);

      return PurchaseItemEntity(
        id: item.id,
        purchaseId: item.purchaseId,
        productId: item.productId,
        productName: product?.productName ?? 'Product #${item.productId}',
        productCode: product?.productCode ?? '',
        variantId: item.variantId,
        variantName: variant?.variantName,
        barcode: variant?.barcode ?? product?.barcode,
        quantity: item.quantity,
        unitId: item.unitId,
        unitName: unit?.unitName ?? '',
        purchasePrice: item.purchasePrice,
        discount: item.discount,
        taxRate: item.taxRate,
        taxAmount: item.taxAmount,
        lineTotal: item.lineTotal,
        returnedQuantity: item.returnedQuantity,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );
    }).toList();
  }

  Future<List<PurchaseReturnItemEntity>> _getItems(int returnId) async {
    final pri = _database.purchaseReturnItems;
    final pi = _database.purchaseItems;
    final p = _database.products;
    final pv = _database.productVariants;
    final u = _database.units;

    final rows =
        await (_database.select(pri).join([
                leftOuterJoin(pi, pi.id.equalsExp(pri.purchaseItemId)),
                leftOuterJoin(p, p.id.equalsExp(pi.productId)),
                leftOuterJoin(pv, pv.id.equalsExp(pi.variantId)),
                leftOuterJoin(u, u.id.equalsExp(pi.unitId)),
              ])
              ..where(pri.purchaseReturnId.equals(returnId))
              ..orderBy([OrderingTerm.asc(pri.id)]))
            .get();

    return rows.map((row) {
      final r = row.readTable(pri);
      final item = row.readTableOrNull(pi);
      final product = row.readTableOrNull(p);
      final variant = row.readTableOrNull(pv);
      final unit = row.readTableOrNull(u);

      return PurchaseReturnItemEntity(
        id: r.id,
        purchaseReturnId: r.purchaseReturnId,
        purchaseItemId: r.purchaseItemId,
        productId: item?.productId ?? 0,
        productName: product?.productName ?? 'Product #${item?.productId ?? ''}',
        productCode: product?.productCode ?? '',
        variantId: item?.variantId,
        variantName: variant?.variantName,
        barcode: variant?.barcode ?? product?.barcode,
        unitName: unit?.unitName ?? '',
        returnQuantity: r.returnQuantity,
        purchasePrice: r.purchasePrice,
        discount: r.discount,
        taxRate: r.taxRate,
        taxAmount: r.taxAmount,
        lineTotal: r.lineTotal,
        createdAt: r.createdAt,
      );
    }).toList();
  }

  /// Total quantity already returned against a purchase item.
  Future<int> _totalReturnedForPurchaseItem(int purchaseItemId) async {
    final pri = _database.purchaseReturnItems;
    final expr = pri.returnQuantity.sum();
    final query = _database.selectOnly(_database.purchaseReturnItems)
      ..addColumns([expr])
      ..where(pri.purchaseItemId.equals(purchaseItemId));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Current available stock for a product/variant.
  Future<int> _currentStock(int productId, int? variantId) async {
    return _stockService.currentStock(productId, variantId);
  }

  Future<void> _updateSupplierPayable(
    int supplierId, {
    required int delta,
  }) async {
    if (delta == 0) return;

    await _database.customStatement(
      'UPDATE supplier SET outstanding_balance = outstanding_balance + $delta, '
      'updated_at = ${DateTime.now().millisecondsSinceEpoch ~/ 1000} '
      'WHERE id = $supplierId',
    );
  }

  /// Appends a financial event to the purchase_transaction table.
  Future<void> _appendReturnTransaction({
    required int purchaseId,
    required int supplierId,
    required int credit,
    required int debit,
    required DateTime transactionDate,
    String? note,
  }) async {
    final t = _database.purchaseTransactions;
    final previous =
        await (_database.select(t)
              ..where((row) => row.purchaseId.equals(purchaseId))
              ..orderBy([
                (row) => OrderingTerm.desc(row.transactionDate),
                (row) => OrderingTerm.desc(row.id),
              ])
              ..limit(1))
            .getSingleOrNull();
    final previousTotal = previous?.runningTotal ?? 0;
    await _database
        .into(t)
        .insert(
          db.PurchaseTransactionsCompanion.insert(
            purchaseId: purchaseId,
            supplierId: supplierId,
            credit: Value(credit),
            debit: Value(debit),
            runningTotal: previousTotal + debit - credit,
            transactionDate: transactionDate,
            note: Value(note),
          ),
        );
  }

  /// Removes all financial events associated with a given return.
  Future<void> _deleteReturnFinancialEvents(
    PurchaseReturnEntity existing,
  ) async {
    final t = _database.purchaseTransactions;
    await (_database.delete(t)..where(
          (row) =>
              row.purchaseId.equals(existing.originalPurchaseId) &
              row.note.equals('Return ${existing.returnNumber}'),
        ))
        .go();
  }

  Future<String> _nextReturnNumber() async {
    return _database.transaction(() async {
      final existing =
          await (_database.select(_database.documentNumberSequences)
                ..where((t) => t.documentType.equals('PURCHASE_RETURN')))
              .getSingleOrNull();

      int nextNumber;
      String prefix;
      int padding;

      if (existing != null) {
        nextNumber = existing.lastNumber + 1;
        prefix = existing.prefix;
        padding = existing.padding;
        await (_database.update(
          _database.documentNumberSequences,
        )..where((t) => t.id.equals(existing.id))).write(
          db.DocumentNumberSequencesCompanion(
            lastNumber: Value(nextNumber),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        nextNumber = 1;
        prefix = 'PRN-';
        padding = 6;
        await _database
            .into(_database.documentNumberSequences)
            .insert(
              db.DocumentNumberSequencesCompanion.insert(
                documentType: 'PURCHASE_RETURN',
                prefix: prefix,
                lastNumber: Value(nextNumber),
                padding: Value(padding),
              ),
            );
      }

      return '$prefix${nextNumber.toString().padLeft(padding, '0')}';
    });
  }

  Expression<bool>? _buildPredicate({
    required db.$PurchaseReturnsTable pr,
    required db.$SuppliersTable s,
    required String normalizedQuery,
    required PurchaseReturnFilters filters,
  }) {
    Expression<bool> predicate = const Constant(true);

    if (normalizedQuery.isNotEmpty) {
      predicate =
          predicate &
          (pr.returnNumber.lower().contains(normalizedQuery) |
              pr.originalPurchaseNumber.lower().contains(normalizedQuery) |
              pr.originalInvoiceNumber.lower().contains(normalizedQuery) |
              s.supplierName.lower().contains(normalizedQuery));
    }

    if (filters.supplierId != null) {
      predicate = predicate & pr.supplierId.equals(filters.supplierId!);
    }
    if (filters.returnDateFrom != null) {
      predicate =
          predicate &
          pr.returnDate.isBiggerOrEqualValue(filters.returnDateFrom!);
    }
    if (filters.returnDateTo != null) {
      final endOfDay = DateTime(
        filters.returnDateTo!.year,
        filters.returnDateTo!.month,
        filters.returnDateTo!.day,
        23,
        59,
        59,
      );
      predicate = predicate & pr.returnDate.isSmallerOrEqualValue(endOfDay);
    }
    if (filters.status != null) {
      predicate = predicate & pr.status.equals(filters.status!.dbValue);
    }

    return predicate;
  }

  PurchaseReturnEntity _fromTypedResult(TypedResult row) {
    final pr = row.readTable(_database.purchaseReturns);
    final s = row.readTable(_database.suppliers);

    return PurchaseReturnEntity(
      id: pr.id,
      returnNumber: pr.returnNumber,
      originalPurchaseId: pr.originalPurchaseId,
      originalPurchaseNumber: pr.originalPurchaseNumber ?? '',
      originalInvoiceNumber: pr.originalInvoiceNumber,
      supplierId: pr.supplierId,
      supplierName: s.supplierName,
      supplierCode: s.supplierCode,
      returnDate: pr.returnDate,
      subtotal: pr.subtotal,
      discount: pr.discount,
      tax: pr.tax,
      total: pr.total,
      notes: pr.notes,
      status: PurchaseReturnStatus.fromDbValue(pr.status),
      createdAt: pr.createdAt,
      updatedAt: pr.updatedAt,
    );
  }

  String? _normalizeText(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

/// Internal representation of a validated return item.
class _ValidatedItem {
  const _ValidatedItem({
    required this.originalItem,
    required this.input,
    required this.currentStock,
  });

  final PurchaseItemEntity originalItem;
  final PurchaseReturnItemInput input;
  final int currentStock;
}
