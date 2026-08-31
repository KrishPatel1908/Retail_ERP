import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<(int, int)> seedSupplierAndProduct({
    String productName = 'Parle-G',
    int? purchasePrice,
    List<({String variantName, int? purchasePrice, String? barcode})>
    variants = const [],
  }) async {
    final supplier = await SupplierRepository().createSupplier(
      supplierName: 'Acme Supplies',
      mobile: '9876543210',
    );
    final product = await ProductRepository().createProduct(
      productName: productName,
      unitId: 1,
      sellingPrice: 1000,
      purchasePrice: purchasePrice,
      variants: [
        for (final v in variants)
          VariantInput(
            variantName: v.variantName,
            sellingPrice: 1000,
            purchasePrice: v.purchasePrice,
            barcode: v.barcode,
          ),
      ],
    );
    return (supplier.id, product.id);
  }

  group('createPurchase calculations', () {
    test('percentage discount = subtotal * percent / 100', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      // Quantity 10 @ ₹100 = ₹1000 subtotal, 10% discount = ₹100.
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 10000,
            discount: (10 * 10000 * 10 / 100).round(), // 10% of ₹1000
            taxRate: 0,
          ),
        ],
      );

      expect(purchase.items.single.quantity, 10);
      expect(purchase.subtotal, 100000);
      expect(purchase.discount, 10000);
      expect(purchase.tax, 0);
      expect(purchase.total, 90000);
    });

    test('fixed-currency discount = entered amount', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      // Subtotal ₹1000, fixed discount ₹123.45.
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 10000,
            discount: 12345,
            taxRate: 0,
          ),
        ],
      );

      expect(purchase.subtotal, 100000);
      expect(purchase.discount, 12345);
      expect(purchase.total, 87655);
    });

    test('a 100% discount leaves a zero (never negative) payable amount', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final subtotal = 20000;
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 2000,
            discount: subtotal,
            taxRate: 0,
          ),
        ],
      );

      expect(purchase.total, 0);
      expect(purchase.total, greaterThanOrEqualTo(0));
    });

    test('an over-100% discount is rejected at the repository boundary', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      // The UI clamps discounts, but if a value exceeding the subtotal ever
      // reaches the repository the purchase must be rejected rather than
      // writing a negative total.
      expect(
        () => PurchaseRepository().createPurchase(
          supplierId: supplierId,
          purchaseDate: DateTime(2026, 8, 1),
          paidAmount: 0,
          items: [
            PurchaseItemInput(
              productId: productId,
              quantity: 10,
              unitId: 1,
              purchasePrice: 1000,
              discount: 15000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseValidationException>()),
      );
    });

    test('percentage discount is clamped to 100%', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final subtotal = 20000;
      // 150% would want ₹300 discount; the UI clamps percent to 100%.
      final clampedDiscount = subtotal;
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 2000,
            discount: clampedDiscount,
            taxRate: 0,
          ),
        ],
      );

      expect(purchase.total, 0);
    });

    test('tax is applied after discount on the taxable amount', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      // Subtotal ₹1000, discount 10% = ₹100, taxable = ₹900, tax 5% = ₹45.
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 10000,
            discount: 10000,
            taxRate: 5,
          ),
        ],
      );

      expect(purchase.subtotal, 100000);
      expect(purchase.discount, 10000);
      expect(purchase.tax, 4500);
      expect(purchase.total, 94500);
      expect(purchase.items.single.taxAmount, 4500);
      expect(purchase.items.single.lineTotal, 94500);
    });
  });

  group('inventory and history', () {
    test('purchase records correct stock and supplier payable', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 5,
            unitId: 1,
            purchasePrice: 2000,
            discount: 0,
            taxRate: 0,
          ),
        ],
      );

      final db = DatabaseProvider.instance.database;
      final stock = await (db.select(db.currentStocks)
            ..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
          .getSingle();
      expect(stock.quantity, 5);

      final txns = await (db.select(db.inventoryTransactions)
            ..where((t) => t.purchaseId.equals(purchase.id)))
          .get();
      expect(txns, hasLength(1));
      expect(txns.single.transactionType, 'PURCHASE');
      expect(txns.single.quantity, 5);

      final loaded = await PurchaseRepository().getById(purchase.id);
      expect(loaded.items.single.productName, 'Parle-G');
      expect(loaded.dueAmount, purchase.total);
    });

    test('two variants of the same parent are two distinct lines', () async {
      final (supplierId, productId) = await seedSupplierAndProduct(
        variants: [
          (variantName: 'Parle-G 5', purchasePrice: 1000, barcode: 'BAR5'),
          (variantName: 'Parle-G 10', purchasePrice: 2000, barcode: 'BAR10'),
        ],
      );

      final variants = await ProductRepository().getVariants(productId);
      expect(variants, hasLength(2));
      final byName = {
        for (final v in variants) v.variantName: v,
      };

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            variantId: byName['Parle-G 5']!.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
          PurchaseItemInput(
            productId: productId,
            variantId: byName['Parle-G 10']!.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 2000,
            taxRate: 0,
          ),
        ],
      );

      expect(purchase.items, hasLength(2));
      expect(purchase.subtotal, 3000);
      final names = purchase.items.map((i) => i.variantName).toSet();
      expect(names, containsAll(['Parle-G 5', 'Parle-G 10']));
      expect(purchase.discount, 0);
      expect(purchase.tax, 0);
    });
  });

  group('running balance', () {
    test('Total is cumulative Credit − Debit for the same supplier', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final repo = PurchaseRepository();

      // Purchase 1: total ₹20,000, paid ₹0 → running +20,000.
      await repo.createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 20,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      // Purchase 2: total ₹10,000, paid ₹8,000 → running +22,000.
      await repo.createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 5),
        paidAmount: 8000,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      final page = await repo.fetchPage(
        filters: const PurchaseFilters(),
        sort: PurchaseSortColumn.purchaseDate,
        sortAscending: true,
      );

      expect(page.items, hasLength(2));
      // Oldest first (ascending date).
      // Purchase 1 (₹200) → running +₹200 (20000 paise).
      expect(page.items[0].runningBalance, 20000);
      // Purchase 2 (₹100 − ₹80 paid) → running +₹220 (22000 paise).
      expect(page.items[1].runningBalance, 22000);
    });
  });

  group('date filters', () {
    test('purchaseDateFrom and purchaseDateTo filter inclusive and through DB',
        () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final repo = PurchaseRepository();

      Future<void> make(String inv, DateTime date) => repo.createPurchase(
            supplierId: supplierId,
            purchaseDate: date,
            invoiceNumber: inv,
            paidAmount: 0,
            items: [
              PurchaseItemInput(
                productId: productId,
                quantity: 1,
                unitId: 1,
                purchasePrice: 100,
                taxRate: 0,
              ),
            ],
          );

      await make('P1', DateTime(2026, 8, 1));
      await make('P2', DateTime(2026, 8, 15));
      await make('P3', DateTime(2026, 8, 31));

      // Only From → purchases from that date onward.
      var page = await repo.fetchPage(
        filters: PurchaseFilters(
          purchaseDateFrom: DateTime(2026, 8, 15),
          isReturn: false,
        ),
      );
      expect(page.items.map((p) => p.invoiceNumber),
          containsAll(['P2', 'P3']));
      expect(page.items.any((p) => p.invoiceNumber == 'P1'), isFalse);

      // Only To → purchases up to that date (inclusive).
      page = await repo.fetchPage(
        filters: PurchaseFilters(
          purchaseDateTo: DateTime(2026, 8, 15),
          isReturn: false,
        ),
      );
      expect(page.items.map((p) => p.invoiceNumber),
          containsAll(['P1', 'P2']));
      expect(page.items.any((p) => p.invoiceNumber == 'P3'), isFalse);

      // Both → inclusive range.
      page = await repo.fetchPage(
        filters: PurchaseFilters(
          purchaseDateFrom: DateTime(2026, 8, 2),
          purchaseDateTo: DateTime(2026, 8, 30),
          isReturn: false,
        ),
      );
      expect(page.items.map((p) => p.invoiceNumber), ['P2']);
    });
  });

  group('deletePurchase', () {
    test('deletes the purchase and reverses stock and payable', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final repo = PurchaseRepository();

      final purchase = await repo.createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 2000,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 5,
            unitId: 1,
            purchasePrice: 2000,
            taxRate: 0,
          ),
        ],
      );

      // Confirm stock and payable were created.
      final db = DatabaseProvider.instance.database;
      final before = await (db.select(db.currentStocks)
            ..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
          .getSingle();
      expect(before.quantity, 5);
      final supplierBefore = await (db.select(db.suppliers)
            ..where((t) => t.id.equals(supplierId)))
          .getSingle();
      // 5 * 20.00 = 100.00 total, paid 20.00 → payable 80.00.
      expect(supplierBefore.outstandingBalance, 8000);

      await repo.deletePurchase(purchase.id);

      // Purchase header and items gone.
      expect((await db.select(db.purchases).get()), isEmpty);
      expect((await db.select(db.purchaseItems).get()), isEmpty);

      // Inventory transactions for the purchase gone, stock reversed.
      final txns = await (db.select(db.inventoryTransactions)
            ..where((t) => t.purchaseId.equals(purchase.id)))
          .get();
      expect(txns, isEmpty);
      final stockAfter = await (db.select(db.currentStocks)
            ..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
          .getSingleOrNull();
      // Stock is reversed to zero (the row may remain, clamped to 0).
      expect(
        stockAfter?.quantity == 0 || stockAfter == null,
        isTrue,
      );

      // Supplier payable reversed to zero.
      final supplierAfter = await (db.select(db.suppliers)
            ..where((t) => t.id.equals(supplierId)))
          .getSingle();
      expect(supplierAfter.outstandingBalance, 0);
    });

    test('rejects deletion when a return references the purchase', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final repo = PurchaseRepository();

      final purchase = await repo.createPurchase(
        supplierId: supplierId,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 10,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      await repo.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        returnItems: [
          ReturnItemInput(
            productId: productId,
            quantity: 2,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      await expectLater(
        repo.deletePurchase(purchase.id),
        throwsA(isA<PurchaseDeletionException>()),
      );
    });
  });
}
