import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/domain/entities/purchase.dart';
import 'package:retail_erp/features/purchase/presentation/pages/create_purchase_return_page.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<(int supplierId, PurchaseEntity purchase, List<int> productIds)>
  seedData() async {
    final supplier = await SupplierRepository().createSupplier(
      supplierName: 'Apple India',
      mobile: '9876543210',
    );
    final p1 = await ProductRepository().createProduct(
      productName: 'Parle-G 5',
      unitId: 1,
      sellingPrice: 500,
      purchasePrice: 400,
    );
    final p2 = await ProductRepository().createProduct(
      productName: 'M4 Air',
      unitId: 1,
      sellingPrice: 100000,
      purchasePrice: 80000,
    );
    final p3 = await ProductRepository().createProduct(
      productName: 'M4 Pro',
      unitId: 1,
      sellingPrice: 180000,
      purchasePrice: 150000,
    );

    final purchase = await PurchaseRepository().createPurchase(
      supplierId: supplier.id,
      purchaseDate: DateTime(2026, 8, 1),
      paidAmount: 0,
      items: [
        PurchaseItemInput(
          productId: p1.id,
          quantity: 20,
          unitId: 1,
          purchasePrice: 400,
          discount: 0,
          taxRate: 0,
        ),
        PurchaseItemInput(
          productId: p2.id,
          quantity: 2,
          unitId: 1,
          purchasePrice: 80000,
          discount: 0,
          taxRate: 0,
        ),
        PurchaseItemInput(
          productId: p3.id,
          quantity: 1,
          unitId: 1,
          purchasePrice: 150000,
          discount: 0,
          taxRate: 0,
        ),
      ],
    );

    return (supplier.id, purchase, [p1.id, p2.id, p3.id]);
  }

  Future<int> currentStock(int productId) async {
    final database = DatabaseProvider.instance.database;
    final row =
        await (database.select(database.currentStocks)..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
            .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    VoidCallback? onSave,
    VoidCallback? onCancel,
  }) async {
    useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CreatePurchaseReturnPage(
            onSave: onSave ?? () {},
            onCancel: onCancel ?? () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> selectSupplierAndPurchase(
    WidgetTester tester, {
    required String supplierName,
    required String purchaseNumber,
  }) async {
    // Select supplier
    await tester.tap(find.text('Select supplier'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text(supplierName).last);
    await tester.pumpAndSettle();

    // Select purchase
    await tester.tap(find.text('Select purchase'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining(purchaseNumber).last);
    await tester.pumpAndSettle();
  }

  group('CreatePurchaseReturnPage partial return validation', () {
    testWidgets(
      'shows every original purchase item, including zero-stock items',
      (tester) async {
        final (_, purchase, productIds) = await seedData();
        final database = DatabaseProvider.instance.database;

        await (database.update(database.currentStocks)..where(
              (t) => t.productId.equals(productIds[1]) & t.variantId.isNull(),
            ))
            .write(const db.CurrentStocksCompanion(quantity: Value(0)));

        await pumpPage(tester);
        await selectSupplierAndPurchase(
          tester,
          supplierName: 'Apple India',
          purchaseNumber: purchase.purchaseNumber,
        );

        expect(find.text('Parle-G 5'), findsOneWidget);
        expect(find.text('M4 Air'), findsOneWidget);
        expect(find.text('M4 Pro'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
      },
    );

    testWidgets('all items qty = 0 shows error and does not save', (
      tester,
    ) async {
      final (_, purchase, _) = await seedData();
      var saved = false;

      await pumpPage(tester, onSave: () => saved = true);
      await selectSupplierAndPurchase(
        tester,
        supplierName: 'Apple India',
        purchaseNumber: purchase.purchaseNumber,
      );

      // Verify all 3 products are rendered
      expect(find.text('Parle-G 5'), findsOneWidget);
      expect(find.text('M4 Air'), findsOneWidget);
      expect(find.text('M4 Pro'), findsOneWidget);

      // Enter 0 for all three rows
      await tester.enterText(find.byKey(const ValueKey('return-qty-0')), '0');
      await tester.enterText(find.byKey(const ValueKey('return-qty-1')), '0');
      await tester.enterText(find.byKey(const ValueKey('return-qty-2')), '0');
      await tester.pumpAndSettle();

      // Click Save Return
      await tester.tap(find.text('Save Return'));
      await tester.pumpAndSettle();

      // Should show the expected validation error
      expect(
        find.text('Please enter a return quantity for at least one product.'),
        findsAtLeastNWidgets(1),
      );
      // Rows should NOT be marked as errors
      expect(
        find.text('Return quantity must be greater than zero.'),
        findsNothing,
      );
      expect(saved, isFalse);
    });

    testWidgets('negative quantity shows invalid error on row', (tester) async {
      final (_, purchase, _) = await seedData();
      var saved = false;

      await pumpPage(tester, onSave: () => saved = true);
      await selectSupplierAndPurchase(
        tester,
        supplierName: 'Apple India',
        purchaseNumber: purchase.purchaseNumber,
      );

      // Enter -1 for first row and 1 for second row
      await tester.enterText(find.byKey(const ValueKey('return-qty-0')), '-1');
      await tester.enterText(find.byKey(const ValueKey('return-qty-1')), '1');
      await tester.pumpAndSettle();

      // Click Save Return
      await tester.tap(find.text('Save Return'));
      await tester.pumpAndSettle();

      expect(find.text('Return quantity cannot be negative.'), findsOneWidget);
      expect(saved, isFalse);
    });

    testWidgets('quantity exceeding available stock shows error on row', (
      tester,
    ) async {
      final (_, purchase, _) = await seedData();
      var saved = false;

      await pumpPage(tester, onSave: () => saved = true);
      await selectSupplierAndPurchase(
        tester,
        supplierName: 'Apple India',
        purchaseNumber: purchase.purchaseNumber,
      );

      // Stock is 20 for row 0; enter 25
      await tester.enterText(find.byKey(const ValueKey('return-qty-0')), '25');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Return'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Return quantity cannot exceed available stock'),
        findsOneWidget,
      );
      expect(saved, isFalse);
    });

    testWidgets(
      'partial return (1 positive, remaining 0) saves successfully and decreases only returned product stock',
      (tester) async {
        final (_, purchase, productIds) = await seedData();
        var saved = false;

        await pumpPage(tester, onSave: () => saved = true);
        await selectSupplierAndPurchase(
          tester,
          supplierName: 'Apple India',
          purchaseNumber: purchase.purchaseNumber,
        );

        // Enter 5 for Parle-G 5, 0 for M4 Air, 0 for M4 Pro
        await tester.enterText(find.byKey(const ValueKey('return-qty-0')), '5');
        await tester.enterText(find.byKey(const ValueKey('return-qty-1')), '0');
        await tester.enterText(find.byKey(const ValueKey('return-qty-2')), '0');
        await tester.pumpAndSettle();

        // Click Save Return
        await tester.tap(find.text('Save Return'));
        await tester.pumpAndSettle();

        expect(saved, isTrue);

        // Verify stock in database
        expect(await currentStock(productIds[0]), 15); // -5
        expect(await currentStock(productIds[1]), 2); // unchanged
        expect(await currentStock(productIds[2]), 1); // unchanged

        // Verify only 1 return item was saved
        final database = DatabaseProvider.instance.database;
        final returnItems = await database
            .select(database.purchaseReturnItems)
            .get();
        expect(returnItems, hasLength(1));
        expect(returnItems.single.returnQuantity, 5);
      },
    );

    testWidgets('purchase containing 2 products displays ALL products with correct columns and return amount', (
      tester,
    ) async {
      final supplier = await SupplierRepository().createSupplier(
        supplierName: 'Tech Supplier',
        mobile: '9123456780',
      );
      final p1 = await ProductRepository().createProduct(
        productName: 'M4 Air',
        unitId: 1,
        sellingPrice: 120000,
        purchasePrice: 100000,
        barcode: 'BAR-M4',
      );
      final p2 = await ProductRepository().createProduct(
        productName: 'Parle-G 5',
        unitId: 1,
        sellingPrice: 500,
        purchasePrice: 400,
        barcode: 'BAR-PG5',
      );

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: p1.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 100000,
            discount: 5000,
            taxRate: 18,
          ),
          PurchaseItemInput(
            productId: p2.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 400,
            discount: 0,
            taxRate: 5,
          ),
        ],
      );

      await pumpPage(tester);
      await selectSupplierAndPurchase(
        tester,
        supplierName: 'Tech Supplier',
        purchaseNumber: purchase.purchaseNumber,
      );

      // Verify header columns are rendered
      expect(find.text('Product'), findsOneWidget);
      expect(find.text('Variant'), findsOneWidget);
      expect(find.text('Barcode'), findsOneWidget);
      expect(find.text('Purchased'), findsOneWidget);
      expect(find.text('Stock'), findsOneWidget);
      expect(find.text('Return Qty*'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Tax'), findsWidgets);
      expect(find.text('Return Amt'), findsOneWidget);

      // Both products MUST be displayed
      expect(find.text('M4 Air'), findsOneWidget);
      expect(find.text('Parle-G 5'), findsOneWidget);
      expect(find.text('BAR-M4'), findsOneWidget);
      expect(find.text('BAR-PG5'), findsOneWidget);
      expect(find.text('18.0%'), findsOneWidget);
      expect(find.text('5.0%'), findsOneWidget);

      // Initially Return Amt displays dash '—'
      expect(find.text('—'), findsWidgets);

      // When Return Qty 1 is entered for M4 Air (Price: 100000, Disc: 5000 -> Taxable: 95000, Tax 18%: 17100 -> Total: 112100 paise = ₹1121)
      await tester.enterText(find.byKey(const ValueKey('return-qty-0')), '1');
      await tester.pumpAndSettle();

      expect(find.text('₹1121'), findsWidgets);
    });

    testWidgets('purchase containing products with variants displays all variant rows', (
      tester,
    ) async {
      final supplier = await SupplierRepository().createSupplier(
        supplierName: 'Mobile Store',
        mobile: '9988776655',
      );
      final product = await ProductRepository().createProduct(
        productName: 'iPhone 16',
        unitId: 1,
        sellingPrice: 80000,
        purchasePrice: 70000,
        variants: [
          const VariantInput(
            variantName: '128GB Black',
            sellingPrice: 80000,
            purchasePrice: 70000,
            barcode: 'IPH-128-BLK',
          ),
          const VariantInput(
            variantName: '256GB White',
            sellingPrice: 90000,
            purchasePrice: 80000,
            barcode: 'IPH-256-WHT',
          ),
        ],
      );

      final v1 = product.variants[0];
      final v2 = product.variants[1];

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: product.id,
            variantId: v1.id,
            quantity: 5,
            unitId: 1,
            purchasePrice: 70000,
            discount: 0,
            taxRate: 18,
          ),
          PurchaseItemInput(
            productId: product.id,
            variantId: v2.id,
            quantity: 3,
            unitId: 1,
            purchasePrice: 80000,
            discount: 0,
            taxRate: 18,
          ),
        ],
      );

      await pumpPage(tester);
      await selectSupplierAndPurchase(
        tester,
        supplierName: 'Mobile Store',
        purchaseNumber: purchase.purchaseNumber,
      );

      expect(find.text('iPhone 16'), findsNWidgets(2));
      expect(find.text('128GB Black'), findsOneWidget);
      expect(find.text('256GB White'), findsOneWidget);
      expect(find.text('IPH-128-BLK'), findsOneWidget);
      expect(find.text('IPH-256-WHT'), findsOneWidget);
    });
  });
}
