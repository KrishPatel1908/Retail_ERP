import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import '../../domain/entities/purchase.dart';

/// Filter parameters for the purchase list.
class PurchaseFilters {
  const PurchaseFilters({
    this.supplierId,
    this.paymentStatus,
    this.purchaseDateFrom,
    this.purchaseDateTo,
    this.minAmount,
    this.maxAmount,
    this.createdFrom,
    this.createdTo,
    this.isReturn,
  });

  final int? supplierId;
  final PurchasePaymentStatus? paymentStatus;
  final DateTime? purchaseDateFrom;
  final DateTime? purchaseDateTo;

  /// Minimum total amount in paise.
  final int? minAmount;

  /// Maximum total amount in paise.
  final int? maxAmount;

  final DateTime? createdFrom;
  final DateTime? createdTo;
  final bool? isReturn;
}

/// Sortable columns for the purchase list.
enum PurchaseSortColumn {
  purchaseNumber,
  purchaseDate,
  supplierName,
  totalAmount,
  dueAmount,
  paymentStatus,
  createdAt,
}

/// Paginated purchase list result.
class PurchasePage {
  const PurchasePage({required this.items, required this.totalCount});

  final List<PurchaseEntity> items;
  final int totalCount;
}

/// A row displayed in Purchase History. Unlike [PurchaseEntity], this is one
/// immutable financial event, not the current purchase snapshot.
class PurchaseTransactionHistoryEntry {
  const PurchaseTransactionHistoryEntry({
    required this.transaction,
    required this.purchase,
  });

  final PurchaseTransactionEntity transaction;
  final PurchaseEntity purchase;
}

class PurchaseTransactionHistoryPage {
  const PurchaseTransactionHistoryPage({
    required this.items,
    required this.totalCount,
  });

  final List<PurchaseTransactionHistoryEntry> items;
  final int totalCount;
}

/// Input data for a purchase line item.
class PurchaseItemInput {
  const PurchaseItemInput({
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unitId,
    required this.purchasePrice,
    this.discount = 0,
    required this.taxRate,
  });

  final int productId;
  final int? variantId;
  final int quantity;
  final int unitId;

  /// Per-unit purchase price in paise.
  final int purchasePrice;

  /// Line discount in paise.
  final int discount;

  /// Tax rate percent (e.g. 18.0 for 18%).
  final double taxRate;
}

/// Data access for purchases.
///
/// All monetary values exchanged with this repository are in paise.
/// The repository owns the transactional purchase-creation pipeline that
/// updates inventory and supplier payable atomically.
class PurchaseRepository {
  PurchaseRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database,
      _stockService = StockService(database: database);

  final db.AppDatabase _database;
  final StockService _stockService;

  // ──────────────────── LISTING ────────────────────

  /// Returns one page of purchases matching [query], [filters] and [sort].
  Future<PurchasePage> fetchPage({
    String query = '',
    PurchaseFilters filters = const PurchaseFilters(),
    PurchaseSortColumn sort = PurchaseSortColumn.purchaseDate,
    bool sortAscending = false,
    int page = 1,
    int pageSize = 25,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final t = _database.purchases;
    final s = _database.suppliers;

    final predicate = _buildPredicate(
      t: t,
      s: s,
      normalizedQuery: query.trim().toLowerCase(),
      filters: filters,
    );

    // Count query.
    final countExpr = t.id.count();
    final countQuery = _database.selectOnly(_database.purchases);
    countQuery.addColumns([countExpr]);
    if (predicate != null) countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    // Page query with joins.
    final rowsQuery = _database.select(t).join([
      innerJoin(s, s.id.equalsExp(t.supplierId)),
    ]);
    if (predicate != null) rowsQuery.where(predicate);
    rowsQuery.orderBy([
      _buildOrderBy(t: t, s: s, sort: sort, ascending: sortAscending),
    ]);
    rowsQuery.limit(pageSize, offset: (effectivePage - 1) * pageSize);

    final rows = await rowsQuery.get();
    final items = rows.map(_fromTypedResult).toList();

    // Compute the running balance (cumulative Credit − cumulative Debit) per
    // supplier, ordered chronologically. The balance for each row reflects the
    // state after that purchase's financial effect.
    final balances = <int, int>{};
    for (final p in items) {
      balances[p.id] = await _runningBalanceFor(p);
    }

    return PurchasePage(
      items: [
        for (final p in items)
          PurchaseEntity(
            id: p.id,
            purchaseNumber: p.purchaseNumber,
            supplierId: p.supplierId,
            supplierName: p.supplierName,
            supplierCode: p.supplierCode,
            purchaseDate: p.purchaseDate,
            invoiceNumber: p.invoiceNumber,
            subtotal: p.subtotal,
            discount: p.discount,
            tax: p.tax,
            total: p.total,
            paidAmount: p.paidAmount,
            dueAmount: p.dueAmount,
            paymentStatus: p.paymentStatus,
            paymentMethod: p.paymentMethod,
            notes: p.notes,
            isReturn: p.isReturn,
            originalPurchaseId: p.originalPurchaseId,
            isActive: p.isActive,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
            runningBalance: balances[p.id],
          ),
      ],
      totalCount: total,
    );
  }

  /// Returns the append-only financial events for Purchase History.
  Future<PurchaseTransactionHistoryPage> fetchTransactionHistoryPage({
    String query = '',
    PurchaseFilters filters = const PurchaseFilters(),
    bool sortAscending = false,
    int page = 1,
    int pageSize = 25,
  }) async {
    final p = _database.purchases;
    final s = _database.suppliers;
    final h = _database.purchaseTransactions;
    final predicate = _buildPredicate(
      t: p,
      s: s,
      normalizedQuery: query.trim().toLowerCase(),
      filters: filters,
    );
    final queryBuilder = _database.select(h).join([
      innerJoin(p, p.id.equalsExp(h.purchaseId)),
      innerJoin(s, s.id.equalsExp(p.supplierId)),
    ]);
    if (predicate != null) queryBuilder.where(predicate);
    // Purchase History is an event stream, so date filtering must apply to
    // the event date rather than the immutable opening purchase date.
    if (filters.purchaseDateFrom != null) {
      queryBuilder.where(
        h.transactionDate.isBiggerOrEqualValue(filters.purchaseDateFrom!),
      );
    }
    if (filters.purchaseDateTo != null) {
      queryBuilder.where(
        h.transactionDate.isSmallerOrEqualValue(filters.purchaseDateTo!),
      );
    }
    queryBuilder.orderBy([
      sortAscending
          ? OrderingTerm.asc(h.transactionDate)
          : OrderingTerm.desc(h.transactionDate),
      sortAscending ? OrderingTerm.asc(h.id) : OrderingTerm.desc(h.id),
    ]);

    final rows = await queryBuilder.get();
    final effectivePage = page < 1 ? 1 : page;
    final offset = (effectivePage - 1) * pageSize;
    final pageRows = rows.skip(offset).take(pageSize);
    return PurchaseTransactionHistoryPage(
      totalCount: rows.length,
      items: [
        for (final row in pageRows)
          PurchaseTransactionHistoryEntry(
            transaction: _transactionFromRow(row.readTable(h)),
            purchase: _fromTypedResult(row),
          ),
      ],
    );
  }

  // ──────────────────── GET BY ID ────────────────────

  /// Gets a purchase by ID with all line items.
  Future<PurchaseEntity> getById(int id) async {
    final t = _database.purchases;
    final s = _database.suppliers;

    final query = _database.select(t).join([
      innerJoin(s, s.id.equalsExp(t.supplierId)),
    ])..where(t.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) throw PurchaseNotFoundException(id);

    final purchase = _fromTypedResult(row);
    final items = await _getItems(id);
    final transactions = await _getTransactions(id);

    return PurchaseEntity(
      id: purchase.id,
      purchaseNumber: purchase.purchaseNumber,
      supplierId: purchase.supplierId,
      supplierName: purchase.supplierName,
      supplierCode: purchase.supplierCode,
      purchaseDate: purchase.purchaseDate,
      invoiceNumber: purchase.invoiceNumber,
      subtotal: purchase.subtotal,
      discount: purchase.discount,
      tax: purchase.tax,
      total: purchase.total,
      paidAmount: purchase.paidAmount,
      dueAmount: purchase.dueAmount,
      paymentStatus: purchase.paymentStatus,
      paymentMethod: purchase.paymentMethod,
      notes: purchase.notes,
      isReturn: purchase.isReturn,
      originalPurchaseId: purchase.originalPurchaseId,
      isActive: purchase.isActive,
      createdAt: purchase.createdAt,
      updatedAt: purchase.updatedAt,
      items: items,
      transactions: transactions,
    );
  }

  // ──────────────────── CREATE ────────────────────

  /// Creates a purchase with items, updates inventory and supplier payable.
  ///
  /// Runs entirely inside one database transaction.
  Future<PurchaseEntity> createPurchase({
    required int supplierId,
    required DateTime purchaseDate,
    String? invoiceNumber,
    String? paymentMethod,
    int paidAmount = 0,
    String? notes,
    required List<PurchaseItemInput> items,
  }) async {
    if (items.isEmpty) {
      throw const PurchaseValidationException(
        'At least one product is required.',
      );
    }

    return _database.transaction(() async {
      // 1. Generate purchase number.
      final purchaseNumber = await _nextPurchaseNumber();

      // 2. Calculate totals.
      int subtotal = 0;
      int totalDiscount = 0;
      int totalTax = 0;

      final lineTotals = <String, _LineCalculation>{};

      for (final item in items) {
        final qty = item.quantity;
        final price = item.purchasePrice;
        final lineSubtotal = qty * price;
        final lineDiscount = item.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * item.taxRate / 100).round();
        final lineTotal = taxableAmount + lineTax;

        // Keyed by product *and* variant: two variants of the same parent
        // product are two distinct lines.
        lineTotals[_itemKey(item.productId, item.variantId)] = _LineCalculation(
          subtotal: lineSubtotal,
          discount: lineDiscount,
          tax: lineTax,
          total: lineTotal,
        );

        subtotal += lineSubtotal;
        totalDiscount += lineDiscount;
        totalTax += lineTax;
      }

      final grandTotal = subtotal - totalDiscount + totalTax;

      // Validate paid amount.
      if (paidAmount < 0) {
        throw const PurchaseValidationException(
          'Paid amount cannot be negative.',
        );
      }
      if (paidAmount > grandTotal) {
        throw const PurchaseValidationException(
          'Paid amount cannot be greater than the grand total.',
        );
      }

      final dueAmount = grandTotal - paidAmount;
      final paymentStatus = _derivePaymentStatus(paidAmount, grandTotal);

      // 3. Insert purchase header.
      final purchaseId = await _database
          .into(_database.purchases)
          .insert(
            db.PurchasesCompanion.insert(
              purchaseNumber: purchaseNumber,
              supplierId: supplierId,
              purchaseDate: purchaseDate,
              invoiceNumber: Value(
                invoiceNumber?.trim().isEmpty == true
                    ? null
                    : invoiceNumber?.trim(),
              ),
              subtotal: Value(subtotal),
              discount: Value(totalDiscount),
              tax: Value(totalTax),
              total: Value(grandTotal),
              paidAmount: Value(paidAmount),
              dueAmount: Value(dueAmount),
              paymentStatus: Value(paymentStatus.dbValue),
              paymentMethod: Value(paymentMethod),
              notes: Value(_normalizeText(notes)),
            ),
          );

      // 4. Insert purchase items + inventory transactions.
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final calc = lineTotals[_itemKey(item.productId, item.variantId)]!;

        await _database
            .into(_database.purchaseItems)
            .insert(
              db.PurchaseItemsCompanion.insert(
                purchaseId: purchaseId,
                productId: item.productId,
                variantId: Value(item.variantId),
                quantity: item.quantity,
                unitId: item.unitId,
                purchasePrice: item.purchasePrice,
                discount: Value(item.discount),
                taxRate: Value(item.taxRate),
                taxAmount: Value(calc.tax),
                lineTotal: Value(calc.total),
              ),
            );

        // Stock increase + movement, recorded atomically by the stock
        // service.
        await _stockService.applyStockChange(
          productId: item.productId,
          variantId: item.variantId,
          delta: item.quantity,
          transactionType: StockMovementType.purchase,
          transactionDate: purchaseDate,
          referenceNumber: purchaseNumber,
          purchaseId: purchaseId,
        );
      }

      // 5. Update supplier outstanding balance.
      await _updateSupplierPayable(supplierId, delta: grandTotal - paidAmount);

      // The opening event records the purchase amount and any initial payment
      // once. Its total follows Debit - Credit.
      await _appendTransaction(
        purchaseId: purchaseId,
        supplierId: supplierId,
        credit: grandTotal,
        debit: paidAmount,
        transactionDate: purchaseDate,
        note: _normalizeText(notes),
      );

      return getById(purchaseId);
    });
  }

  // ──────────────────── UPDATE ────────────────────

  /// Updates an existing purchase, adjusting inventory and supplier payable.
  Future<PurchaseEntity> updatePurchase(
    int id, {
    required int supplierId,
    required DateTime purchaseDate,
    String? invoiceNumber,
    String? paymentMethod,
    int paidAmount = 0,
    String? notes,
    required List<PurchaseItemInput> items,
  }) async {
    if (items.isEmpty) {
      throw const PurchaseValidationException(
        'At least one product is required.',
      );
    }

    return _database.transaction(() async {
      // Load existing purchase.
      final existing = await getById(id);

      // 1. Recalculate new totals.
      int subtotal = 0;
      int totalDiscount = 0;
      int totalTax = 0;

      final lineTotals = <String, _LineCalculation>{};

      for (final item in items) {
        final lineSubtotal = item.quantity * item.purchasePrice;
        final lineDiscount = item.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * item.taxRate / 100).round();
        final lineTotal = taxableAmount + lineTax;

        // Keyed by product *and* variant: two variants of the same parent
        // product are two distinct lines.
        lineTotals[_itemKey(item.productId, item.variantId)] = _LineCalculation(
          subtotal: lineSubtotal,
          discount: lineDiscount,
          tax: lineTax,
          total: lineTotal,
        );

        subtotal += lineSubtotal;
        totalDiscount += lineDiscount;
        totalTax += lineTax;
      }

      final grandTotal = subtotal - totalDiscount + totalTax;

      if (paidAmount < 0) {
        throw const PurchaseValidationException(
          'Paid amount cannot be negative.',
        );
      }
      if (paidAmount > grandTotal) {
        throw const PurchaseValidationException(
          'Paid amount cannot be greater than the grand total.',
        );
      }

      final dueAmount = grandTotal - paidAmount;
      final paymentStatus = _derivePaymentStatus(paidAmount, grandTotal);

      // Financial history is delta based. A lower payable is a debit (it
      // reduces what is owed); a reduced recorded payment is a credit.
      final purchaseAmountDelta = grandTotal - existing.total;
      final paymentDelta = paidAmount - existing.paidAmount;
      final transactionCredit =
          (purchaseAmountDelta > 0 ? purchaseAmountDelta : 0) +
          (paymentDelta < 0 ? -paymentDelta : 0);
      final transactionDebit =
          (purchaseAmountDelta < 0 ? -purchaseAmountDelta : 0) +
          (paymentDelta > 0 ? paymentDelta : 0);

      // 2. Update purchase header.
      await (_database.update(
        _database.purchases,
      )..where((t) => t.id.equals(id))).write(
        db.PurchasesCompanion(
          supplierId: Value(supplierId),
          purchaseDate: Value(purchaseDate),
          invoiceNumber: Value(
            invoiceNumber?.trim().isEmpty == true
                ? null
                : invoiceNumber?.trim(),
          ),
          subtotal: Value(subtotal),
          discount: Value(totalDiscount),
          tax: Value(totalTax),
          total: Value(grandTotal),
          paidAmount: Value(paidAmount),
          dueAmount: Value(dueAmount),
          paymentStatus: Value(paymentStatus.dbValue),
          paymentMethod: Value(paymentMethod),
          notes: Value(_normalizeText(notes)),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 3. Handle inventory adjustments.
      // Build map of old items for comparison.
      final oldItemsMap = <String, PurchaseItemEntity>{};
      for (final item in existing.items) {
        final key = _itemKey(item.productId, item.variantId);
        oldItemsMap[key] = item;
      }

      final newItemsMap = <String, PurchaseItemInput>{};
      for (final item in items) {
        final key = _itemKey(item.productId, item.variantId);
        newItemsMap[key] = item;
      }

      // Remove items that are no longer present — reverse their inventory.
      for (final entry in oldItemsMap.entries) {
        if (!newItemsMap.containsKey(
          entry.value.variantId != null ? entry.key : entry.key,
        )) {
          final oldItem = entry.value;
          if (oldItem.returnedQuantity > 0) {
            throw const PurchaseValidationException(
              'Cannot remove an item that has already been returned. '
              'Revert the return first.',
            );
          }
          final effectiveQty = oldItem.quantity;
          if (effectiveQty > 0) {
            await _stockService.applyStockChange(
              productId: oldItem.productId,
              variantId: oldItem.variantId,
              delta: -effectiveQty,
              transactionType: StockMovementType.purchaseAdjustment,
              transactionDate: purchaseDate,
              referenceNumber: existing.purchaseNumber,
              purchaseId: id,
              note: 'Purchase item removed during edit',
            );
          }
          // Delete the old purchase item.
          await (_database.delete(
            _database.purchaseItems,
          )..where((t) => t.id.equals(oldItem.id))).go();
        }
      }

      // Process new/updated items.
      for (final item in items) {
        final key = _itemKey(item.productId, item.variantId);
        final existingItem = oldItemsMap[key];

        if (existingItem != null) {
          if (item.quantity < existingItem.returnedQuantity) {
            throw PurchaseValidationException(
              'Cannot reduce item quantity below returned quantity '
              '(${existingItem.returnedQuantity}).',
            );
          }

          // Update existing item.
          final calc = lineTotals[key]!;
          await (_database.update(
            _database.purchaseItems,
          )..where((t) => t.id.equals(existingItem.id))).write(
            db.PurchaseItemsCompanion(
              quantity: Value(item.quantity),
              unitId: Value(item.unitId),
              purchasePrice: Value(item.purchasePrice),
              discount: Value(item.discount),
              taxRate: Value(item.taxRate),
              taxAmount: Value(calc.tax),
              lineTotal: Value(calc.total),
              updatedAt: Value(DateTime.now()),
            ),
          );

          // Adjust inventory: delta is new qty minus old qty.
          final delta = item.quantity - existingItem.quantity;

          if (delta != 0) {
            await _stockService.applyStockChange(
              productId: item.productId,
              variantId: item.variantId,
              delta: delta,
              transactionType: StockMovementType.purchaseAdjustment,
              transactionDate: purchaseDate,
              referenceNumber: existing.purchaseNumber,
              purchaseId: id,
              note: 'Purchase item quantity adjusted during edit',
            );
          }
        } else {
          // New item — insert.
          final calc = lineTotals[key]!;
          await _database
              .into(_database.purchaseItems)
              .insert(
                db.PurchaseItemsCompanion.insert(
                  purchaseId: id,
                  productId: item.productId,
                  variantId: Value(item.variantId),
                  quantity: item.quantity,
                  unitId: item.unitId,
                  purchasePrice: item.purchasePrice,
                  discount: Value(item.discount),
                  taxRate: Value(item.taxRate),
                  taxAmount: Value(calc.tax),
                  lineTotal: Value(calc.total),
                ),
              );

          // Add inventory.
          await _stockService.applyStockChange(
            productId: item.productId,
            variantId: item.variantId,
            delta: item.quantity,
            transactionType: StockMovementType.purchase,
            transactionDate: purchaseDate,
            referenceNumber: existing.purchaseNumber,
            purchaseId: id,
          );
        }
      }

      // 4. Adjust supplier payable.
      final oldPayable = existing.total - existing.paidAmount;
      final newPayable = grandTotal - paidAmount;
      final payableDelta = newPayable - oldPayable;

      if (payableDelta != 0) {
        await _updateSupplierPayable(supplierId, delta: payableDelta);
      }

      // If supplier changed, adjust both old and new supplier.
      if (supplierId != existing.supplierId) {
        // Reverse the entire old payable from old supplier.
        await _updateSupplierPayable(
          existing.supplierId,
          delta: -(existing.total - existing.paidAmount),
        );
        // Apply the new payable to the new supplier.
        await _updateSupplierPayable(
          supplierId,
          delta: grandTotal - paidAmount,
        );
      }

      // Note/invoice-only edits deliberately do not reach this branch. If the
      // purchase date changed, it is the selected date for this event;
      // otherwise use the actual edit time without rewriting the opening row.
      if (transactionCredit != 0 || transactionDebit != 0) {
        await _appendTransaction(
          purchaseId: id,
          supplierId: supplierId,
          credit: transactionCredit,
          debit: transactionDebit,
          transactionDate: purchaseDate != existing.purchaseDate
              ? purchaseDate
              : DateTime.now(),
          note: _normalizeText(notes),
        );
      }

      return getById(id);
    });
  }

  // ──────────────────── CREATE RETURN ────────────────────

  /// Creates a purchase return, adjusting inventory and supplier payable.
  Future<PurchaseEntity> createReturn({
    required int originalPurchaseId,
    required int supplierId,
    required DateTime returnDate,
    String? notes,
    required List<ReturnItemInput> returnItems,
  }) async {
    if (returnItems.isEmpty) {
      throw const PurchaseValidationException(
        'At least one product is required for return.',
      );
    }

    return _database.transaction(() async {
      // Validate return quantities against original purchase.
      final originalPurchase = await getById(originalPurchaseId);

      for (final ri in returnItems) {
        final originalItem = originalPurchase.items.firstWhere(
          (item) =>
              item.productId == ri.productId && item.variantId == ri.variantId,
          orElse: () => throw PurchaseValidationException(
            'Product/variant not found in original purchase.',
          ),
        );

        final alreadyReturned = originalItem.returnedQuantity;
        final maxReturnable = originalItem.quantity - alreadyReturned;

        if (ri.quantity <= 0) {
          throw const PurchaseValidationException(
            'Return quantity must be greater than zero.',
          );
        }

        if (ri.quantity > maxReturnable) {
          throw PurchaseValidationException(
            'Cannot return ${ri.quantity} of "${originalItem.productName}". '
            'Only $maxReturnable can be returned '
            '(purchased: ${originalItem.quantity}, already returned: $alreadyReturned).',
          );
        }
      }

      // Generate return purchase number.
      final purchaseNumber = await _nextPurchaseNumber();

      // Calculate return totals (negative of original prices).
      int subtotal = 0;
      int totalDiscount = 0;
      int totalTax = 0;

      for (final ri in returnItems) {
        final lineSubtotal = ri.quantity * ri.purchasePrice;
        final lineDiscount = ri.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * ri.taxRate / 100).round();

        subtotal += lineSubtotal;
        totalDiscount += lineDiscount;
        totalTax += lineTax;
      }

      final grandTotal = subtotal - totalDiscount + totalTax;

      // Insert the return purchase header.
      final purchaseId = await _database
          .into(_database.purchases)
          .insert(
            db.PurchasesCompanion.insert(
              purchaseNumber: purchaseNumber,
              supplierId: supplierId,
              purchaseDate: returnDate,
              subtotal: Value(subtotal),
              discount: Value(totalDiscount),
              tax: Value(totalTax),
              total: Value(grandTotal),
              paidAmount: const Value(0),
              dueAmount: const Value(0),
              paymentStatus: const Value('PAID'),
              notes: Value(_normalizeText(notes)),
              isReturn: const Value(true),
              originalPurchaseId: Value(originalPurchaseId),
            ),
          );

      // Insert return items + adjust inventory.
      for (final ri in returnItems) {
        final lineSubtotal = ri.quantity * ri.purchasePrice;
        final lineDiscount = ri.discount;
        final taxableAmount = lineSubtotal - lineDiscount;
        final lineTax = (taxableAmount * ri.taxRate / 100).round();
        final lineTotal = taxableAmount + lineTax;

        await _database
            .into(_database.purchaseItems)
            .insert(
              db.PurchaseItemsCompanion.insert(
                purchaseId: purchaseId,
                productId: ri.productId,
                variantId: Value(ri.variantId),
                quantity: ri.quantity,
                unitId: ri.unitId,
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
          delta: -ri.quantity,
          transactionType: StockMovementType.purchaseReturn,
          transactionDate: returnDate,
          referenceNumber: purchaseNumber,
          purchaseId: originalPurchaseId,
        );

        // Update the original purchase item's returned_quantity.
        final originalItem = originalPurchase.items.firstWhere(
          (item) =>
              item.productId == ri.productId && item.variantId == ri.variantId,
        );
        await (_database.update(
          _database.purchaseItems,
        )..where((t) => t.id.equals(originalItem.id))).write(
          db.PurchaseItemsCompanion(
            returnedQuantity: Value(
              originalItem.returnedQuantity + ri.quantity,
            ),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // Reduce supplier payable by the return amount.
      await _updateSupplierPayable(supplierId, delta: -grandTotal);

      return getById(purchaseId);
    });
  }

  // ──────────────────── SEARCH / FILTER HELPERS ────────────────────

  /// Distinct supplier IDs and names for the filter dropdown.
  Future<List<({int id, String name})>> distinctSuppliers() async {
    final query = _database.select(_database.suppliers)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.supplierName.lower())]);
    final rows = await query.get();
    return rows.map((r) => (id: r.id, name: r.supplierName)).toList();
  }

  // ──────────────────── INTERNALS ────────────────────

  String _itemKey(int productId, int? variantId) {
    return '$productId-${variantId ?? 'base'}';
  }

  Future<String> _nextPurchaseNumber() async {
    // Use a transactional sequence to guarantee uniqueness.
    return _database.transaction(() async {
      // Try to find existing sequence.
      final existing = await (_database.select(
        _database.documentNumberSequences,
      )..where((t) => t.documentType.equals('PURCHASE'))).getSingleOrNull();

      int nextNumber;
      String prefix;
      int padding;

      if (existing != null) {
        nextNumber = existing.lastNumber + 1;
        prefix = existing.prefix;
        padding = existing.padding;

        // Update the sequence.
        await (_database.update(
          _database.documentNumberSequences,
        )..where((t) => t.id.equals(existing.id))).write(
          db.DocumentNumberSequencesCompanion(
            lastNumber: Value(nextNumber),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        // Create new sequence.
        nextNumber = 1;
        prefix = 'PUR-';
        padding = 6;

        await _database
            .into(_database.documentNumberSequences)
            .insert(
              db.DocumentNumberSequencesCompanion.insert(
                documentType: 'PURCHASE',
                prefix: prefix,
                lastNumber: Value(nextNumber),
                padding: Value(padding),
              ),
            );
      }

      return '$prefix${nextNumber.toString().padLeft(padding, '0')}';
    });
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

  Future<void> _appendTransaction({
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

  Future<List<PurchaseTransactionEntity>> _getTransactions(
    int purchaseId,
  ) async {
    final rows =
        await (_database.select(_database.purchaseTransactions)
              ..where((t) => t.purchaseId.equals(purchaseId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.transactionDate),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();
    return [for (final row in rows) _transactionFromRow(row)];
  }

  PurchaseTransactionEntity _transactionFromRow(db.PurchaseTransaction row) =>
      PurchaseTransactionEntity(
        id: row.id,
        purchaseId: row.purchaseId,
        supplierId: row.supplierId,
        credit: row.credit,
        debit: row.debit,
        runningTotal: row.runningTotal,
        transactionDate: row.transactionDate,
        note: row.note,
      );

  /// Running balance for [purchase]'s supplier after [purchase]'s effect.
  ///
  /// Credit is the purchase total payable to the supplier; Debit is the amount
  /// paid. The running balance is the cumulative (Credit − Debit) of every
  /// purchase from the same supplier up to and including [purchase], ordered
  /// by date then id. Returns paise (may be negative when the supplier owes
  /// the business).
  Future<int> _runningBalanceFor(PurchaseEntity purchase) async {
    final t = _database.purchases;
    final expr = (t.total - t.paidAmount).sum();
    final query = _database.selectOnly(_database.purchases)..addColumns([expr]);
    query.where(
      t.supplierId.equals(purchase.supplierId) &
          t.isReturn.equals(false) &
          (t.purchaseDate.isSmallerThanValue(purchase.purchaseDate) |
              (t.purchaseDate.equals(purchase.purchaseDate) &
                  t.id.isSmallerOrEqualValue(purchase.id))),
    );
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  // ──────────────────── DELETE ────────────────────

  /// Deletes a purchase and fully reverses its financial and inventory effect.
  ///
  /// Runs atomically:
  /// - Reverses the supplier's payable balance by the purchase's net effect.
  /// - Reverses stock for every line item (purchase − returned).
  /// - Removes the purchase's inventory transactions, line items and header.
  ///
  /// A purchase that is the source of a purchase return (or whose items have
  /// been partially returned) cannot be safely deleted and is rejected.
  Future<void> deletePurchase(int id) async {
    await _database.transaction(() async {
      final existing = await getById(id);

      if (existing.isReturn) {
        throw const PurchaseDeletionException(
          'This is a purchase return and cannot be deleted directly. '
          'Reverse the corresponding transaction instead.',
        );
      }

      if (existing.originalPurchaseId != null) {
        throw const PurchaseDeletionException(
          'This purchase is linked to a return and cannot be deleted.',
        );
      }

      final hasReturns = await (_database.select(
        _database.purchases,
      )..where((t) => t.originalPurchaseId.equals(id))).get();
      if (hasReturns.isNotEmpty) {
        throw const PurchaseDeletionException(
          'This purchase has returns against it. Delete those returns first.',
        );
      }

      final returnedItem = existing.items
          .where((item) => item.returnedQuantity > 0)
          .toList();
      if (returnedItem.isNotEmpty) {
        throw const PurchaseDeletionException(
          'This purchase has items that were returned and cannot be deleted '
          'while returns exist.',
        );
      }

      // Reverse inventory: unbuy what was purchased (minus returned amounts,
      // which are already handled by the return transactions).
      for (final item in existing.items) {
        final effectiveQty = item.quantity - item.returnedQuantity;
        if (effectiveQty > 0) {
          await _stockService.applyStockChange(
            productId: item.productId,
            variantId: item.variantId,
            delta: -effectiveQty,
            transactionType: StockMovementType.purchaseAdjustment,
            transactionDate: DateTime.now(),
            referenceNumber: existing.purchaseNumber,
            purchaseId: id,
            note: 'Purchase deleted',
          );
        }
      }

      // Remove the purchase's inventory transactions (PURCHASE + adjustments).
      await (_database.delete(
        _database.inventoryTransactions,
      )..where((t) => t.purchaseId.equals(id))).go();

      // Remove the purchase's line items.
      await (_database.delete(
        _database.purchaseItems,
      )..where((t) => t.purchaseId.equals(id))).go();

      // Reverse the supplier's payable balance for this purchase's net effect.
      await _updateSupplierPayable(
        existing.supplierId,
        delta: -(existing.total - existing.paidAmount),
      );

      // Finally, remove the purchase header.
      await (_database.delete(
        _database.purchases,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  PurchasePaymentStatus _derivePaymentStatus(int paid, int total) {
    if (total <= 0 || paid <= 0) return PurchasePaymentStatus.unpaid;
    if (paid >= total) return PurchasePaymentStatus.paid;
    return PurchasePaymentStatus.partial;
  }

  String? _normalizeText(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  // ─── Predicate / Order ───

  Expression<bool>? _buildPredicate({
    required db.$PurchasesTable t,
    required db.$SuppliersTable s,
    required String normalizedQuery,
    required PurchaseFilters filters,
  }) {
    Expression<bool> predicate = const Constant(true);

    if (normalizedQuery.isNotEmpty) {
      predicate =
          predicate &
          (t.purchaseNumber.lower().contains(normalizedQuery) |
              t.invoiceNumber.lower().contains(normalizedQuery) |
              s.supplierName.lower().contains(normalizedQuery));
    }

    if (filters.supplierId != null) {
      predicate = predicate & t.supplierId.equals(filters.supplierId!);
    }
    if (filters.paymentStatus != null) {
      predicate =
          predicate & t.paymentStatus.equals(filters.paymentStatus!.dbValue);
    }
    if (filters.purchaseDateFrom != null) {
      predicate =
          predicate &
          t.purchaseDate.isBiggerOrEqualValue(filters.purchaseDateFrom!);
    }
    if (filters.purchaseDateTo != null) {
      final endOfDay = DateTime(
        filters.purchaseDateTo!.year,
        filters.purchaseDateTo!.month,
        filters.purchaseDateTo!.day,
        23,
        59,
        59,
      );
      predicate = predicate & t.purchaseDate.isSmallerOrEqualValue(endOfDay);
    }
    if (filters.minAmount != null) {
      predicate = predicate & t.total.isBiggerOrEqualValue(filters.minAmount!);
    }
    if (filters.maxAmount != null) {
      predicate = predicate & t.total.isSmallerOrEqualValue(filters.maxAmount!);
    }
    if (filters.createdFrom != null) {
      predicate =
          predicate & t.createdAt.isBiggerOrEqualValue(filters.createdFrom!);
    }
    if (filters.createdTo != null) {
      final endOfDay = DateTime(
        filters.createdTo!.year,
        filters.createdTo!.month,
        filters.createdTo!.day,
        23,
        59,
        59,
      );
      predicate = predicate & t.createdAt.isSmallerOrEqualValue(endOfDay);
    }
    if (filters.isReturn != null) {
      predicate = predicate & t.isReturn.equals(filters.isReturn!);
    }

    return predicate;
  }

  OrderingTerm _buildOrderBy({
    required db.$PurchasesTable t,
    required db.$SuppliersTable s,
    required PurchaseSortColumn sort,
    required bool ascending,
  }) {
    final direction = ascending ? OrderingTerm.asc : OrderingTerm.desc;
    return switch (sort) {
      PurchaseSortColumn.purchaseNumber => direction(t.purchaseNumber.lower()),
      PurchaseSortColumn.purchaseDate => direction(t.purchaseDate),
      PurchaseSortColumn.supplierName => direction(s.supplierName.lower()),
      PurchaseSortColumn.totalAmount => direction(t.total),
      PurchaseSortColumn.dueAmount => direction(t.dueAmount),
      PurchaseSortColumn.paymentStatus => direction(t.paymentStatus.lower()),
      PurchaseSortColumn.createdAt => direction(t.createdAt),
    };
  }

  PurchaseEntity _fromTypedResult(TypedResult row) {
    final t = row.readTable(_database.purchases);
    final s = row.readTable(_database.suppliers);

    return PurchaseEntity(
      id: t.id,
      purchaseNumber: t.purchaseNumber,
      supplierId: t.supplierId,
      supplierName: s.supplierName,
      supplierCode: s.supplierCode,
      purchaseDate: t.purchaseDate,
      invoiceNumber: t.invoiceNumber,
      subtotal: t.subtotal,
      discount: t.discount,
      tax: t.tax,
      total: t.total,
      paidAmount: t.paidAmount,
      dueAmount: t.dueAmount,
      paymentStatus: PurchasePaymentStatus.fromDbValue(t.paymentStatus),
      paymentMethod: t.paymentMethod,
      notes: t.notes,
      isReturn: t.isReturn,
      originalPurchaseId: t.originalPurchaseId,
      isActive: t.isActive,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  Future<List<PurchaseItemEntity>> _getItems(int purchaseId) async {
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
}

/// Helper for line-level calculation.
class _LineCalculation {
  const _LineCalculation({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
  });

  final int subtotal;
  final int discount;
  final int tax;
  final int total;
}

/// Input for a return line item.
class ReturnItemInput {
  const ReturnItemInput({
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unitId,
    required this.purchasePrice,
    this.discount = 0,
    required this.taxRate,
  });

  final int productId;
  final int? variantId;
  final int quantity;
  final int unitId;
  final int purchasePrice;
  final int discount;
  final double taxRate;
}

// ─── Exceptions ───

class PurchaseNotFoundException implements Exception {
  const PurchaseNotFoundException(int id)
    : message = 'Purchase with id $id not found.';

  final String message;

  @override
  String toString() => 'PurchaseNotFoundException: $message';
}

class PurchaseValidationException implements Exception {
  const PurchaseValidationException(this.message);

  final String message;

  @override
  String toString() => 'PurchaseValidationException: $message';
}

class PurchaseDeletionException implements Exception {
  const PurchaseDeletionException(this.message);

  final String message;

  @override
  String toString() => 'PurchaseDeletionException: $message';
}
