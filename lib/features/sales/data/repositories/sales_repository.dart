import 'dart:math';

import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/master_entry/product_uom/data/repositories/product_uom_repository.dart';
import 'package:retail_erp/features/master_entry/uom_conversion/data/repositories/uom_conversion_repository.dart';
import 'package:retail_erp/features/master_entry/uom_conversion/services/conversion_service.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sellable_item.dart';
import '../../domain/exceptions/sales_exceptions.dart';

/// Input item for creating a sale.
class CreateSaleItemInput {
  const CreateSaleItemInput({
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    this.barcode,
    required this.unitId,
    required this.unitName,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0,
    required this.taxRate,
  });

  final int productId;
  final int? variantId;
  final String productName;
  final String? variantName;
  final String? barcode;
  final int unitId;
  final String unitName;
  final double quantity;

  /// Selling price in paise.
  final int unitPrice;

  /// Line discount in paise.
  final int discount;

  /// Tax rate percentage (e.g. 18.0 for 18%).
  final double taxRate;
}

/// Filter parameters for the sales list.
class SalesFilters {
  const SalesFilters({
    this.customerId,
    this.paymentStatus,
    this.startDate,
    this.endDate,
    this.isActive,
  });

  final int? customerId;
  final SalePaymentStatus? paymentStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
}

/// Paginated sales result.
class SalesPage {
  const SalesPage({required this.items, required this.totalCount});

  final List<SaleEntity> items;
  final int totalCount;
}

/// Data access and business transaction engine for Sales POS.
///
/// All monetary values exchanged with this repository are in paise.
/// Owns the atomic sale creation pipeline that updates inventory,
/// customer ledger, and sequence numbers safely.
class SalesRepository {
  SalesRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database,
      _stockService = StockService(database: database),
      _conversionService = ConversionService(
        uomRepository: UomConversionRepository(
          database: database ?? DatabaseProvider.instance.database,
        ),
        productLookup: (productId, fromUnitId, toUnitId) =>
            ProductUomRepository(
              database: database ?? DatabaseProvider.instance.database,
            ).resolveFactor(productId, fromUnitId, toUnitId),
      );

  final db.AppDatabase _database;
  final StockService _stockService;
  final ConversionService _conversionService;

  // In-flight saving mutex to prevent rapid double-clicks at the repository level.
  final Set<String> _inFlightSaleCreations = <String>{};

  // ──────────────────── SEARCH & LOOKUP ────────────────────

  /// Searches active products and variants database-side.
  ///
  /// Searches active products and variants database-side.
  ///
  /// For products with variants, returns each variant as an independent sellable item.
  /// For products without variants, returns the product itself.
  /// Inactive products and out-of-stock products are respected.
  /// If [categoryId] is provided, only products in that category are returned.
  Future<List<SellableItem>> searchSellableItems({
    String query = '',
    int? categoryId,
    int limit = 30,
  }) async {
    final normalized = query.trim().toLowerCase();
    final taxRates = await _loadTaxRates();

    // 1. Fetch products matching query or with variants matching query.
    final pTable = _database.products;
    final uTable = _database.units;
    final tcTable = _database.taxCategories;
    final catTable = _database.categories;

    final productQuery = _database.select(pTable).join([
      innerJoin(uTable, uTable.id.equalsExp(pTable.unitId)),
      leftOuterJoin(tcTable, tcTable.id.equalsExp(pTable.taxCategoryId)),
      leftOuterJoin(catTable, catTable.id.equalsExp(pTable.categoryId)),
    ])..where(pTable.isActive.equals(true));

    if (categoryId != null) {
      productQuery.where(pTable.categoryId.equals(categoryId));
    }

    if (normalized.isNotEmpty) {
      // Find matching variant product IDs.
      final matchingVariantProductIds =
          (await (_database.selectOnly(_database.productVariants)
                ..addColumns([_database.productVariants.productId])
                ..where(
                  _database.productVariants.isActive.equals(true) &
                      (_database.productVariants.variantName
                              .lower()
                              .contains(normalized) |
                          _database.productVariants.barcode
                              .lower()
                              .contains(normalized)),
                ))
              .get())
          .map((row) => row.read(_database.productVariants.productId)!)
          .toSet();

      productQuery.where(
        pTable.productName.lower().contains(normalized) |
            pTable.productCode.lower().contains(normalized) |
            (pTable.barcode.isNotNull() &
                pTable.barcode.lower().contains(normalized)) |
            pTable.id.isIn(matchingVariantProductIds),
      );
    }

    productQuery.orderBy([OrderingTerm.asc(pTable.productName.lower())]);
    if (limit > 0) {
      productQuery.limit(limit);
    }

    final productRows = await productQuery.get();
    if (productRows.isEmpty) return const [];

    final productIds = productRows.map((r) => r.readTable(pTable).id).toList();

    // 2. Fetch all active variants for these products.
    final variantRows =
        await (_database.select(_database.productVariants)
              ..where(
                (v) =>
                    v.productId.isIn(productIds) & v.isActive.equals(true),
              )
              ..orderBy([(v) => OrderingTerm.asc(v.variantName.lower())]))
            .get();

    final variantsByProductId = <int, List<db.ProductVariant>>{};
    for (final v in variantRows) {
      variantsByProductId.putIfAbsent(v.productId, () => []).add(v);
    }

    // 3. Fetch current stocks for these products and variants.
    final stockRows =
        await (_database.select(_database.currentStocks)
              ..where((s) => s.productId.isIn(productIds)))
            .get();

    final stockMap = <String, int>{};
    for (final s in stockRows) {
      final key = '${s.productId}:${s.variantId ?? 'base'}';
      stockMap[key] = s.quantity;
    }

    final result = <SellableItem>[];

    for (final row in productRows) {
      final product = row.readTable(pTable);
      final unit = row.readTable(uTable);
      final taxCategory = row.readTableOrNull(tcTable);
      final category = row.readTableOrNull(catTable);
      final taxRate = (product.taxCategoryId != null)
          ? (taxRates[product.taxCategoryId!] ?? 0.0)
          : 0.0;

      final variants = variantsByProductId[product.id] ?? const [];

      if (variants.isNotEmpty) {
        // Product with variants: emit each variant as an independent sellable item.
        for (final v in variants) {
          if (normalized.isNotEmpty) {
            final matchesVariant = v.variantName.toLowerCase().contains(normalized) ||
                (v.barcode != null && v.barcode!.toLowerCase().contains(normalized)) ||
                product.productName.toLowerCase().contains(normalized);
            if (!matchesVariant) continue;
          }

          final stock = stockMap['${product.id}:${v.id}'] ?? 0;
          final sellingPrice = v.sellingPrice > 0
              ? v.sellingPrice
              : product.sellingPrice;

          result.add(
            SellableItem(
              productId: product.id,
              variantId: v.id,
              productName: product.productName,
              variantName: v.variantName,
              barcode: v.barcode ?? product.barcode,
              sellingPrice: sellingPrice,
              mrp: v.mrp ?? product.mrp,
              unitId: unit.id,
              unitName: unit.unitName,
              unitSymbol: unit.unitSymbol,
              taxCategoryId: product.taxCategoryId,
              taxCategoryName: taxCategory?.taxCategoryName,
              taxRate: taxRate,
              availableStock: stock,
              categoryId: product.categoryId,
              categoryName: category?.categoryName,
              isActive: product.isActive && v.isActive,
            ),
          );
        }
      } else {
        // Simple product without variants.
        final stock = stockMap['${product.id}:base'] ?? 0;
        result.add(
          SellableItem(
            productId: product.id,
            variantId: null,
            productName: product.productName,
            variantName: null,
            barcode: product.barcode,
            sellingPrice: product.sellingPrice,
            mrp: product.mrp,
            unitId: unit.id,
            unitName: unit.unitName,
            unitSymbol: unit.unitSymbol,
            taxCategoryId: product.taxCategoryId,
            taxCategoryName: taxCategory?.taxCategoryName,
            taxRate: taxRate,
            availableStock: stock,
            categoryId: product.categoryId,
            categoryName: category?.categoryName,
            isActive: product.isActive,
          ),
        );
      }
    }

    return result;
  }

  /// Exact case-insensitive barcode lookup returning the sellable product or variant.
  ///
  /// Checks variant barcodes first, then product barcodes.
  /// Rejects inactive items and ambiguous duplicate barcodes.
  Future<SellableItem?> findSellableItemByBarcode(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return null;

    final taxRates = await _loadTaxRates();

    // 1. Check exact variant barcode match.
    final variantMatches = await (_database.select(_database.productVariants)
          ..where((v) => v.barcode.lower().equals(trimmed.toLowerCase())))
        .get();

    if (variantMatches.length > 1) {
      throw AmbiguousBarcodeException(trimmed);
    }

    if (variantMatches.isNotEmpty) {
      final v = variantMatches.single;
      final product = await (_database.select(_database.products)
            ..where((p) => p.id.equals(v.productId)))
          .getSingleOrNull();

      if (product == null) return null;
      if (!product.isActive || !v.isActive) {
        throw const SalesValidationException(
          'Product is inactive and cannot be sold.',
        );
      }

      final unit = await (_database.select(_database.units)
            ..where((u) => u.id.equals(product.unitId)))
          .getSingle();

      final taxCat = product.taxCategoryId != null
          ? await (_database.select(_database.taxCategories)
                ..where((t) => t.id.equals(product.taxCategoryId!)))
              .getSingleOrNull()
          : null;

      final taxRate = (product.taxCategoryId != null)
          ? (taxRates[product.taxCategoryId!] ?? 0.0)
          : 0.0;

      final stock = await _stockService.currentStock(product.id, v.id);
      final sellingPrice = v.sellingPrice > 0 ? v.sellingPrice : product.sellingPrice;

      return SellableItem(
        productId: product.id,
        variantId: v.id,
        productName: product.productName,
        variantName: v.variantName,
        barcode: v.barcode ?? product.barcode,
        sellingPrice: sellingPrice,
        mrp: v.mrp ?? product.mrp,
        unitId: unit.id,
        unitName: unit.unitName,
        unitSymbol: unit.unitSymbol,
        taxCategoryId: product.taxCategoryId,
        taxCategoryName: taxCat?.taxCategoryName,
        taxRate: taxRate,
        availableStock: stock,
        isActive: true,
      );
    }

    // 2. Check exact product barcode match.
    final productMatches = await (_database.select(_database.products)
          ..where((p) => p.barcode.lower().equals(trimmed.toLowerCase())))
        .get();

    if (productMatches.length > 1) {
      throw AmbiguousBarcodeException(trimmed);
    }

    if (productMatches.isNotEmpty) {
      final product = productMatches.single;
      if (!product.isActive) {
        throw const SalesValidationException(
          'Product is inactive and cannot be sold.',
        );
      }

      final unit = await (_database.select(_database.units)
            ..where((u) => u.id.equals(product.unitId)))
          .getSingle();

      final taxCat = product.taxCategoryId != null
          ? await (_database.select(_database.taxCategories)
                ..where((t) => t.id.equals(product.taxCategoryId!)))
              .getSingleOrNull()
          : null;

      final taxRate = (product.taxCategoryId != null)
          ? (taxRates[product.taxCategoryId!] ?? 0.0)
          : 0.0;

      final stock = await _stockService.currentStock(product.id, null);

      return SellableItem(
        productId: product.id,
        variantId: null,
        productName: product.productName,
        variantName: null,
        barcode: product.barcode,
        sellingPrice: product.sellingPrice,
        mrp: product.mrp,
        unitId: unit.id,
        unitName: unit.unitName,
        unitSymbol: unit.unitSymbol,
        taxCategoryId: product.taxCategoryId,
        taxCategoryName: taxCat?.taxCategoryName,
        taxRate: taxRate,
        availableStock: stock,
        isActive: true,
      );
    }

    return null;
  }

  // ──────────────────── DOCUMENT NUMBERING ────────────────────

  /// Generates the next sequential sale number atomically.
  Future<String> nextSaleNumber() async {
    return _database.transaction(() async {
      final existing = await (_database.select(_database.documentNumberSequences)
            ..where((t) => t.documentType.equals('SALE')))
          .getSingleOrNull();

      if (existing != null) {
        final nextNum = existing.lastNumber + 1;
        await (_database.update(_database.documentNumberSequences)
              ..where((t) => t.id.equals(existing.id)))
            .write(
              db.DocumentNumberSequencesCompanion(
                lastNumber: Value(nextNum),
                updatedAt: Value(DateTime.now()),
              ),
            );
        return '${existing.prefix}${nextNum.toString().padLeft(existing.padding, '0')}';
      }

      const prefix = 'SAL-';

      const nextNum = 1;
      const padding = 6;

      await _database.into(_database.documentNumberSequences).insert(
            db.DocumentNumberSequencesCompanion.insert(
              documentType: 'SALE',
              prefix: prefix,
              lastNumber: const Value(nextNum),
              padding: const Value(padding),
            ),
          );

      return '$prefix${nextNum.toString().padLeft(padding, '0')}';
    });
  }

  // ──────────────────── SALE CREATION (ATOMIC) ────────────────────

  /// Creates a sale atomically.
  ///
  /// Steps:
  /// 1. Re-validate cart and items (non-empty, qty > 0, price >= 0).
  /// 2. Re-validate stock inside SQLite transaction (prevents race condition).
  /// 3. Calculate financial totals server-side in paise.
  /// 4. Allocate unique sequential sale number.
  /// 5. Save sale header and line items snapshots.
  /// 6. Reduce inventory via StockService (creates inventory movement).
  /// 7. Update customer outstanding balance and append to customer ledger if partial/credit.
  /// 8. Returns completed SaleEntity.
  Future<SaleEntity> createSale({
    int? customerId,
    required DateTime saleDate,
    required List<CreateSaleItemInput> items,
    int billDiscount = 0,
    required String paymentMethod,
    int amountReceived = 0,
    String? notes,
  }) async {
    if (items.isEmpty) {
      throw const SalesValidationException('Cart cannot be empty.');
    }

    final key = 'sale_${customerId ?? 'walkin'}_${DateTime.now().millisecondsSinceEpoch}';
    if (_inFlightSaleCreations.contains(key)) {
      throw const SalesValidationException('A sale is already being processed.');
    }
    _inFlightSaleCreations.add(key);

    try {
      return await _database.transaction(() async {
        // Step 1: Pre-validate items
        for (final item in items) {
          if (item.quantity <= 0) {
            throw const SalesValidationException('Item quantity must be greater than zero.');
          }
          if (item.unitPrice < 0) {
            throw const SalesValidationException('Item price cannot be negative.');
          }
          if (item.discount < 0) {
            throw const SalesValidationException('Item discount cannot be negative.');
          }
        }

        // Step 2: Validate stock and conversion inside transaction
        final baseQuantities = <int>[];
        for (final item in items) {
          final product = await (_database.select(_database.products)
                ..where((p) => p.id.equals(item.productId)))
              .getSingleOrNull();

          if (product == null || !product.isActive) {
            throw SalesValidationException(
              'Product "${item.productName}" is not available for sale.',
            );
          }

          if (item.variantId != null) {
            final variant = await (_database.select(_database.productVariants)
                  ..where((v) => v.id.equals(item.variantId!)))
                .getSingleOrNull();
            if (variant == null || !variant.isActive) {
              throw SalesValidationException(
                'Variant "${item.variantName}" is not available for sale.',
              );
            }
          }

          int baseQty;
          if (item.unitId == product.unitId) {
            baseQty = item.quantity.round();
          } else {
            final factor = await _conversionService.convert(
              productId: item.productId,
              fromUnitId: item.unitId,
              toUnitId: product.unitId,
              quantity: item.quantity,
            );
            baseQty = factor.round();
          }

          final stock = await _stockService.currentStock(
            item.productId,
            item.variantId,
          );

          if (stock < baseQty) {
            throw InsufficientStockException(
              'Insufficient stock. Available stock: $stock.',
            );
          }
          baseQuantities.add(baseQty);
        }

        // Step 3: Calculate totals server-side in paise
        int subtotal = 0;
        int totalItemDiscount = 0;
        int totalTax = 0;

        final lineCalculations = <({
          int lineSubtotal,
          int lineDiscount,
          int taxableAmount,
          int taxAmount,
          int lineTotal,
        })>[];

        for (final item in items) {
          final lineSubtotal = (item.quantity * item.unitPrice).round();
          final lineDiscount = min(lineSubtotal, max(0, item.discount));
          final taxable = max(0, lineSubtotal - lineDiscount);
          final taxAmount = (taxable * item.taxRate / 100).round();
          final lineTotal = taxable + taxAmount;

          subtotal += lineSubtotal;
          totalItemDiscount += lineDiscount;
          totalTax += taxAmount;

          lineCalculations.add((
            lineSubtotal: lineSubtotal,
            lineDiscount: lineDiscount,
            taxableAmount: taxable,
            taxAmount: taxAmount,
            lineTotal: lineTotal,
          ));
        }

        final boundedBillDiscount = min(
          max(0, subtotal - totalItemDiscount),
          max(0, billDiscount),
        );
        final totalDiscount = totalItemDiscount + boundedBillDiscount;
        final grandTotal = max(0, subtotal - totalDiscount + totalTax);

        // Payment status and amounts calculation
        int paidAmount = 0;
        int balanceAmount = 0;
        int changeAmount = 0;
        SalePaymentStatus paymentStatus = SalePaymentStatus.unpaid;

        final cleanPaymentMethod = paymentMethod.trim();

        if (cleanPaymentMethod == 'Cash') {
          if (customerId == null) {
            // Walk-in customer must pay full cash.
            if (amountReceived < grandTotal) {
              throw const SalesValidationException(
                'Walk-in customer sale must be fully paid.',
              );
            }
            paidAmount = grandTotal;
            changeAmount = amountReceived - grandTotal;
            balanceAmount = 0;
            paymentStatus = SalePaymentStatus.paid;
          } else {
            // Registered customer can have partial cash payment.
            if (amountReceived >= grandTotal) {
              paidAmount = grandTotal;
              changeAmount = amountReceived - grandTotal;
              balanceAmount = 0;
              paymentStatus = SalePaymentStatus.paid;
            } else {
              paidAmount = max(0, amountReceived);
              changeAmount = 0;
              balanceAmount = grandTotal - paidAmount;
              paymentStatus = paidAmount > 0
                  ? SalePaymentStatus.partial
                  : SalePaymentStatus.unpaid;
            }
          }
        } else if (cleanPaymentMethod == 'Credit') {
          if (customerId == null) {
            throw const SalesValidationException(
              'Credit sale requires a registered customer.',
            );
          }
          paidAmount = min(grandTotal, max(0, amountReceived));
          changeAmount = 0;
          balanceAmount = grandTotal - paidAmount;
          paymentStatus = paidAmount > 0
              ? (paidAmount >= grandTotal ? SalePaymentStatus.paid : SalePaymentStatus.partial)
              : SalePaymentStatus.unpaid;
        } else {
          // Digital, Card, UPI
          paidAmount = grandTotal;
          balanceAmount = 0;
          changeAmount = 0;
          paymentStatus = SalePaymentStatus.paid;
        }

        // Step 4: Allocate sale number
        final saleNumber = await nextSaleNumber();

        // Step 5: Insert Sale Header
        final saleId = await _database.into(_database.sales).insert(
              db.SalesCompanion.insert(
                saleNumber: saleNumber,
                customerId: Value(customerId),
                saleDate: saleDate,
                subtotal: Value(subtotal),
                discount: Value(totalDiscount),
                tax: Value(totalTax),
                grandTotal: Value(grandTotal),
                paidAmount: Value(paidAmount),
                balanceAmount: Value(balanceAmount),
                changeAmount: Value(changeAmount),
                paymentStatus: Value(paymentStatus.dbValue),
                paymentMethod: Value(cleanPaymentMethod),
                notes: Value(notes?.trim()),
                isActive: const Value(true),
              ),
            );

        // Step 6: Insert Sale Items
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          final calc = lineCalculations[i];

          await _database.into(_database.saleItems).insert(
                db.SaleItemsCompanion.insert(
                  saleId: saleId,
                  productId: item.productId,
                  variantId: Value(item.variantId),
                  productName: item.productName,
                  variantName: Value(item.variantName),
                  barcode: Value(item.barcode),
                  unitId: item.unitId,
                  unitName: item.unitName,
                  quantity: Value(item.quantity),
                  unitPrice: item.unitPrice,
                  discount: Value(calc.lineDiscount),
                  taxRate: Value(item.taxRate),
                  taxAmount: Value(calc.taxAmount),
                  lineTotal: Value(calc.lineTotal),
                ),
              );

          // Step 7: Reduce stock via StockService
          final baseQty = baseQuantities[i];
          await _stockService.applyStockChange(
            productId: item.productId,
            variantId: item.variantId,
            delta: -baseQty,
            transactionType: StockMovementType.sale,
            transactionDate: saleDate,
            referenceNumber: saleNumber,
            saleId: saleId,
            note: 'Sale $saleNumber',
          );
        }

        // Step 8: Customer Ledger entry if partial/credit
        if (customerId != null && balanceAmount > 0) {
          // Update customer outstanding balance: customer owes more (debit effect).
          await _database.customStatement(
            'UPDATE customer SET outstanding_balance = outstanding_balance + $balanceAmount, '
            'updated_at = ${DateTime.now().millisecondsSinceEpoch ~/ 1000} '
            'WHERE id = $customerId',
          );

          // Find previous running total
          final prevTxn = await (_database.select(_database.customerTransactions)
                ..where((c) => c.customerId.equals(customerId))
                ..orderBy([
                  (c) => OrderingTerm.desc(c.transactionDate),
                  (c) => OrderingTerm.desc(c.id),
                ])
                ..limit(1))
              .getSingleOrNull();

          final prevTotal = prevTxn?.runningTotal ?? 0;
          final newRunningTotal = prevTotal + grandTotal - paidAmount;

          await _database.into(_database.customerTransactions).insert(
                db.CustomerTransactionsCompanion.insert(
                  saleId: Value(saleId),
                  customerId: customerId,
                  debit: Value(grandTotal),
                  credit: Value(paidAmount),
                  runningTotal: newRunningTotal,
                  transactionDate: saleDate,
                  note: Value('Sale $saleNumber'),
                ),
              );
        }

        return getById(saleId);
      });
    } finally {
      _inFlightSaleCreations.remove(key);
    }
  }

  // ──────────────────── REVERSAL / VOID ────────────────────

  /// Voids a completed sale, atomically reversing inventory and customer balance.
  Future<void> voidSale(int saleId, {String? reason}) async {
    await _database.transaction(() async {
      final sale = await getById(saleId);
      if (!sale.isActive) {
        throw const SalesValidationException('This sale is already voided.');
      }

      // Mark sale as inactive.
      await (_database.update(_database.sales)
            ..where((s) => s.id.equals(saleId)))
          .write(
            db.SalesCompanion(
              isActive: const Value(false),
              notes: Value(
                [
                  if (sale.notes != null) sale.notes,
                  'VOIDED: ${reason ?? 'No reason provided'}',
                ].join('\n'),
              ),
              updatedAt: Value(DateTime.now()),
            ),
          );

      // Reverse inventory for each item.
      for (final item in sale.items) {
        final product = await (_database.select(_database.products)
              ..where((p) => p.id.equals(item.productId)))
            .getSingle();

        int baseQty;
        if (item.unitId == product.unitId) {
          baseQty = item.quantity.round();
        } else {
          final factor = await _conversionService.convert(
            productId: item.productId,
            fromUnitId: item.unitId,
            toUnitId: product.unitId,
            quantity: item.quantity,
          );
          baseQty = factor.round();
        }

        await _stockService.applyStockChange(
          productId: item.productId,
          variantId: item.variantId,
          delta: baseQty,
          transactionType: StockMovementType.saleReturn,
          transactionDate: DateTime.now(),
          referenceNumber: sale.saleNumber,
          saleId: sale.id,
          note: 'Reversal: Voided sale ${sale.saleNumber}',
        );
      }

      // Reverse customer balance if this sale had an outstanding balance.
      if (sale.customerId != null && sale.balanceAmount > 0) {
        await _database.customStatement(
          'UPDATE customer SET outstanding_balance = outstanding_balance - ${sale.balanceAmount}, '
          'updated_at = ${DateTime.now().millisecondsSinceEpoch ~/ 1000} '
          'WHERE id = ${sale.customerId}',
        );

        final prevTxn = await (_database.select(_database.customerTransactions)
              ..where((c) => c.customerId.equals(sale.customerId!))
              ..orderBy([
                (c) => OrderingTerm.desc(c.transactionDate),
                (c) => OrderingTerm.desc(c.id),
              ])
              ..limit(1))
            .getSingleOrNull();

        final prevTotal = prevTxn?.runningTotal ?? 0;
        final newRunningTotal = prevTotal - sale.balanceAmount;

        await _database.into(_database.customerTransactions).insert(
              db.CustomerTransactionsCompanion.insert(
                saleId: Value(sale.id),
                customerId: sale.customerId!,
                debit: const Value(0),
                credit: Value(sale.balanceAmount),
                runningTotal: newRunningTotal,
                transactionDate: DateTime.now(),
                note: Value('Reversal: Voided sale ${sale.saleNumber}'),
              ),
            );
      }
    });
  }

  // ──────────────────── RETRIEVAL ────────────────────

  /// Retrieves a sale by ID with its line items and customer information.
  Future<SaleEntity> getById(int id) async {
    final sTable = _database.sales;
    final cTable = _database.customers;

    final query = _database.select(sTable).join([
      leftOuterJoin(cTable, cTable.id.equalsExp(sTable.customerId)),
    ])..where(sTable.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) throw SaleNotFoundException(id);

    final sale = row.readTable(sTable);
    final customer = row.readTableOrNull(cTable);

    final itemRows = await (_database.select(_database.saleItems)
          ..where((i) => i.saleId.equals(id))
          ..orderBy([(i) => OrderingTerm.asc(i.id)]))
        .get();

    final items = itemRows
        .map(
          (i) => SaleItemEntity(
            id: i.id,
            saleId: i.saleId,
            productId: i.productId,
            variantId: i.variantId,
            productName: i.productName,
            variantName: i.variantName,
            barcode: i.barcode,
            unitId: i.unitId,
            unitName: i.unitName,
            quantity: i.quantity,
            unitPrice: i.unitPrice,
            discount: i.discount,
            taxRate: i.taxRate,
            taxAmount: i.taxAmount,
            lineTotal: i.lineTotal,
            createdAt: i.createdAt,
            updatedAt: i.updatedAt,
          ),
        )
        .toList();

    return SaleEntity(
      id: sale.id,
      saleNumber: sale.saleNumber,
      customerId: sale.customerId,
      customerName: customer?.customerName,
      customerCode: customer?.customerCode,
      saleDate: sale.saleDate,
      subtotal: sale.subtotal,
      discount: sale.discount,
      tax: sale.tax,
      grandTotal: sale.grandTotal,
      paidAmount: sale.paidAmount,
      balanceAmount: sale.balanceAmount,
      changeAmount: sale.changeAmount,
      paymentStatus: SalePaymentStatus.fromDbValue(sale.paymentStatus),
      paymentMethod: sale.paymentMethod,
      notes: sale.notes,
      isActive: sale.isActive,
      items: items,
      createdAt: sale.createdAt,
      updatedAt: sale.updatedAt,
    );
  }

  /// Lists sales paginated and filtered.
  Future<SalesPage> fetchPage({
    SalesFilters filters = const SalesFilters(),
    int page = 1,
    int pageSize = 25,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final sTable = _database.sales;
    final cTable = _database.customers;

    Expression<bool> predicate = const Constant(true);

    if (filters.customerId != null) {
      predicate = predicate & sTable.customerId.equals(filters.customerId!);
    }
    if (filters.paymentStatus != null) {
      predicate = predicate &
          sTable.paymentStatus.equals(filters.paymentStatus!.dbValue);
    }
    if (filters.startDate != null) {
      predicate = predicate & sTable.saleDate.isBiggerOrEqualValue(filters.startDate!);
    }
    if (filters.endDate != null) {
      predicate = predicate & sTable.saleDate.isSmallerOrEqualValue(filters.endDate!);
    }
    if (filters.isActive != null) {
      predicate = predicate & sTable.isActive.equals(filters.isActive!);
    }

    final countExpr = sTable.id.count();
    final countQuery = _database.selectOnly(sTable)..addColumns([countExpr]);
    countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    final rowsQuery = _database.select(sTable).join([
      leftOuterJoin(cTable, cTable.id.equalsExp(sTable.customerId)),
    ]);
    rowsQuery.where(predicate);
    rowsQuery.orderBy([OrderingTerm.desc(sTable.saleDate), OrderingTerm.desc(sTable.id)]);
    rowsQuery.limit(pageSize, offset: (effectivePage - 1) * pageSize);

    final rows = await rowsQuery.get();

    final sales = <SaleEntity>[];
    for (final row in rows) {
      final sale = row.readTable(sTable);
      final customer = row.readTableOrNull(cTable);

      sales.add(
        SaleEntity(
          id: sale.id,
          saleNumber: sale.saleNumber,
          customerId: sale.customerId,
          customerName: customer?.customerName,
          customerCode: customer?.customerCode,
          saleDate: sale.saleDate,
          subtotal: sale.subtotal,
          discount: sale.discount,
          tax: sale.tax,
          grandTotal: sale.grandTotal,
          paidAmount: sale.paidAmount,
          balanceAmount: sale.balanceAmount,
          changeAmount: sale.changeAmount,
          paymentStatus: SalePaymentStatus.fromDbValue(sale.paymentStatus),
          paymentMethod: sale.paymentMethod,
          notes: sale.notes,
          isActive: sale.isActive,
          items: const [],
          createdAt: sale.createdAt,
          updatedAt: sale.updatedAt,
        ),
      );
    }

    return SalesPage(items: sales, totalCount: total);
  }

  // ──────────────────── HELPERS ────────────────────

  Future<Map<int, double>> _loadTaxRates() async {
    final rates = await _database.select(_database.taxCategoryRates).get();
    final map = <int, double>{};
    for (final r in rates) {
      map[r.taxCategoryId] = (map[r.taxCategoryId] ?? 0.0) + r.ratePercent;
    }
    return map;
  }
}
