import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/migrations/upgrade_to_v15.dart';
import 'package:retail_erp/features/inventory/data/repositories/inventory_repository.dart';
import 'package:retail_erp/features/inventory/domain/entities/inventory.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/inventory/presentation/dialogs/stock_adjustment_dialog.dart';
import 'package:retail_erp/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_return_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<int> stockOf(int productId, {int? variantId}) async {
    final database = DatabaseProvider.instance.database;
    final row = await (database.select(database.currentStocks)..where(
          (t) =>
              t.productId.equals(productId) &
              (variantId != null
                  ? t.variantId.equals(variantId)
                  : t.variantId.isNull()),
        ))
            .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  group('Inventory Regression — Zero-Stock & Variants', () {
    test('newly created product appears in Inventory immediately with 0 stock and outOfStock', () async {
      final productRepo = ProductRepository();
      final inventoryRepo = InventoryRepository();

      final product = await productRepo.createProduct(
        productName: 'Parle-G 5',
        unitId: 1,
        sellingPrice: 500,
        purchasePrice: 400,
        barcode: 'PARLE5',
        minimumStock: 10,
      );

      final page = await inventoryRepo.fetchPage(page: 1, pageSize: 20);

      expect(page.totalCount, 1);
      expect(page.items.length, 1);

      final item = page.items.single;
      expect(item.productId, product.id);
      expect(item.productName, 'Parle-G 5');
      expect(item.variantId, isNull);
      expect(item.variantName, isNull);
      expect(item.barcode, 'PARLE5');
      expect(item.currentStock, 0);
      expect(item.status, StockStatus.outOfStock);
    });

    test('newly created product with variants shows variants independently with 0 stock and excludes parent', () async {
      final productRepo = ProductRepository();
      final inventoryRepo = InventoryRepository();

      final parent = await productRepo.createProduct(
        productName: 'Shirt',
        unitId: 1,
        sellingPrice: 100000,
        purchasePrice: 80000,
        variants: [
          VariantInput(
            variantName: 'Shirt Small',
            sellingPrice: 90000,
            purchasePrice: 70000,
            barcode: 'SHIRT-S',
          ),
          VariantInput(
            variantName: 'Shirt Large',
            sellingPrice: 110000,
            purchasePrice: 90000,
            barcode: 'SHIRT-L',
          ),
        ],
      );

      final page = await inventoryRepo.fetchPage(page: 1, pageSize: 20);

      expect(page.totalCount, 2);
      expect(page.items.length, 2);

      // Verify that no item has null variantId (parent is NOT listed as a sellable item)
      expect(page.items.any((i) => i.variantId == null), isFalse);

      final small = page.items.firstWhere((i) => i.barcode == 'SHIRT-S');
      expect(small.productId, parent.id);
      expect(small.productName, 'Shirt');
      expect(small.variantName, 'Shirt Small');
      expect(small.currentStock, 0);
      expect(small.status, StockStatus.outOfStock);

      final large = page.items.firstWhere((i) => i.barcode == 'SHIRT-L');
      expect(large.productId, parent.id);
      expect(large.productName, 'Shirt');
      expect(large.variantName, 'Shirt Large');
      expect(large.currentStock, 0);
      expect(large.status, StockStatus.outOfStock);
    });

    test('adjustmentOptions includes zero-stock products for opening stock entry', () async {
      final productRepo = ProductRepository();
      final inventoryRepo = InventoryRepository();

      await productRepo.createProduct(
        productName: 'Notebook',
        unitId: 1,
        sellingPrice: 5000,
      );

      final options = await inventoryRepo.adjustmentOptions();
      expect(options.any((o) => o.itemName == 'Notebook' && o.currentStock == 0), isTrue);
    });

    test('filtering by Out of Stock status includes newly created un-stocked products', () async {
      final productRepo = ProductRepository();
      final inventoryRepo = InventoryRepository();

      await productRepo.createProduct(
        productName: 'Zero Stock Item',
        unitId: 1,
        sellingPrice: 1000,
      );

      final outPage = await inventoryRepo.fetchPage(
        filters: const InventoryFilters(stockStatus: StockStatus.outOfStock),
        page: 1,
        pageSize: 20,
      );
      expect(outPage.totalCount, 1);
      expect(outPage.items.single.productName, 'Zero Stock Item');

      final inPage = await inventoryRepo.fetchPage(
        filters: const InventoryFilters(stockStatus: StockStatus.inStock),
        page: 1,
        pageSize: 20,
      );
      expect(inPage.totalCount, 0);
    });
  });

  group('Stock Protection — Negative Stock Rejection', () {
    test('exact available, less than available, and excessive decrease behavior', () async {
      final supplier = await SupplierRepository().createSupplier(
        supplierName: 'Stock Supplier',
        mobile: '9876543210',
      );
      final product = await ProductRepository().createProduct(
        productName: 'Widget',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 600,
      );

      // Purchase 10 units
      await PurchaseRepository().createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          PurchaseItemInput(
            productId: product.id,
            quantity: 10,
            unitId: 1,
            purchasePrice: 600,
            taxRate: 0,
          ),
        ],
      );

      final inventoryRepo = InventoryRepository();

      // Decrease 4 (less than available 10) -> Success, stock = 6
      final afterFirst = await inventoryRepo.createAdjustment(
        productId: product.id,
        direction: StockAdjustmentDirection.decrease,
        quantity: 4,
        reason: 'Test partial decrease',
        adjustmentDate: DateTime(2026, 9, 2),
      );
      expect(afterFirst, 6);
      expect(await stockOf(product.id), 6);

      // Attempt decrease 8 (greater than available 6) -> Throws InsufficientStockException, stock remains 6
      await expectLater(
        () => inventoryRepo.createAdjustment(
          productId: product.id,
          direction: StockAdjustmentDirection.decrease,
          quantity: 8,
          reason: 'Excessive decrease',
          adjustmentDate: DateTime(2026, 9, 3),
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      expect(await stockOf(product.id), 6);

      // Decrease exactly 6 (exact available) -> Success, stock = 0
      final afterExact = await inventoryRepo.createAdjustment(
        productId: product.id,
        direction: StockAdjustmentDirection.decrease,
        quantity: 6,
        reason: 'Exact decrease',
        adjustmentDate: DateTime(2026, 9, 4),
      );
      expect(afterExact, 0);
      expect(await stockOf(product.id), 0);

      // Attempt decrease 1 when stock is 0 -> Throws InsufficientStockException
      await expectLater(
        () => inventoryRepo.createAdjustment(
          productId: product.id,
          direction: StockAdjustmentDirection.decrease,
          quantity: 1,
          reason: 'Decrease from zero',
          adjustmentDate: DateTime(2026, 9, 5),
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      expect(await stockOf(product.id), 0);
    });
  });

  group('UI Responsiveness & Layout — No RenderFlex Overflow', () {
    testWidgets('renders cleanly without overflow at 850px desktop width', (tester) async {
      tester.view.physicalSize = const Size(850, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Seed multiple zero-stock and stocked products
      final repo = ProductRepository();
      for (var i = 1; i <= 5; i++) {
        await repo.createProduct(
          productName: 'Product $i',
          unitId: 1,
          sellingPrice: 1000 * i,
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: InventoryListPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Confirm no overflow errors were thrown
      expect(tester.takeException(), isNull);
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Out of Stock'), findsWidgets);
    });

    testWidgets('renders cleanly without overflow at 900px desktop width', (tester) async {
      tester.view.physicalSize = const Size(900, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final repo = ProductRepository();
      await repo.createProduct(
        productName: 'Responsive Item',
        unitId: 1,
        sellingPrice: 500,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: InventoryListPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Responsive Item'), findsOneWidget);
    });
  });

  group('Stock Flow Regression & Movement History', () {
    test('Initial 0 -> Purchase +10 -> Return -2 -> Adjustment +5 -> Adjustment -3 = 10 with accurate Previous/New in history', () async {
      final supplierRepo = SupplierRepository();
      final productRepo = ProductRepository();
      final purchaseRepo = PurchaseRepository();
      final returnRepo = PurchaseReturnRepository();
      final inventoryRepo = InventoryRepository();

      final supplier = await supplierRepo.createSupplier(
        supplierName: 'Parle Distributor',
        mobile: '9876543210',
      );
      final product = await productRepo.createProduct(
        productName: 'Biscuits',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 800,
      );

      // Initial 0
      expect(await stockOf(product.id), 0);

      // 1. Purchase +10 -> 10
      final purchase = await purchaseRepo.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          PurchaseItemInput(
            productId: product.id,
            quantity: 10,
            unitId: 1,
            purchasePrice: 800,
            taxRate: 0,
          ),
        ],
      );
      expect(await stockOf(product.id), 10);

      // 2. Purchase Return -2 -> 8
      await returnRepo.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplier.id,
        returnDate: DateTime(2026, 9, 2),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: product.id,
            returnQuantity: 2,
            purchasePrice: 800,
            taxRate: 0,
          ),
        ],
      );
      expect(await stockOf(product.id), 8);

      // 3. Adjustment +5 -> 13
      await inventoryRepo.createAdjustment(
        productId: product.id,
        direction: StockAdjustmentDirection.increase,
        quantity: 5,
        reason: 'Found extra in stockroom',
        adjustmentDate: DateTime(2026, 9, 3),
      );
      expect(await stockOf(product.id), 13);

      // 4. Adjustment -3 -> 10
      await inventoryRepo.createAdjustment(
        productId: product.id,
        direction: StockAdjustmentDirection.decrease,
        quantity: 3,
        reason: 'Damaged in transit',
        adjustmentDate: DateTime(2026, 9, 4),
      );
      expect(await stockOf(product.id), 10);

      // Verify Movement History
      final movements = (await inventoryRepo.fetchMovements(productId: product.id)).items;
      expect(movements.length, 4);

      // Movements are ordered in reverse chronological order
      final adjDec = movements[0];
      expect(adjDec.transactionType, StockMovementType.stockAdjustment);
      expect(adjDec.quantity, -3);
      expect(adjDec.previousQuantity, 13);
      expect(adjDec.newQuantity, 10);

      final adjInc = movements[1];
      expect(adjInc.transactionType, StockMovementType.stockAdjustment);
      expect(adjInc.quantity, 5);
      expect(adjInc.previousQuantity, 8);
      expect(adjInc.newQuantity, 13);

      final ret = movements[2];
      expect(ret.transactionType, StockMovementType.purchaseReturn);
      expect(ret.quantity, -2);
      expect(ret.previousQuantity, 10);
      expect(ret.newQuantity, 8);

      final pur = movements[3];
      expect(pur.transactionType, StockMovementType.purchase);
      expect(pur.quantity, 10);
      expect(pur.previousQuantity, 0);
      expect(pur.newQuantity, 10);
    });
  });

  group('Legacy Movement Backfill', () {
    test('backfillInventoryTransactionQuantities fills NULL previous/new quantities', () async {
      final db = DatabaseProvider.instance.database;
      final productRepo = ProductRepository();
      final product = await productRepo.createProduct(
        productName: 'Legacy Item',
        unitId: 1,
        sellingPrice: 100,
      );

      // Insert legacy rows with null previous_quantity and new_quantity
      await db.into(db.inventoryTransactions).insert(
        InventoryTransactionsCompanion.insert(
          productId: product.id,
          transactionType: 'PURCHASE',
          quantity: 10,
          transactionDate: DateTime(2026, 1, 1),
          createdAt: Value(DateTime(2026, 1, 1)),
          previousQuantity: const Value.absent(),
          newQuantity: const Value.absent(),
        ),
      );
      await db.into(db.inventoryTransactions).insert(
        InventoryTransactionsCompanion.insert(
          productId: product.id,
          transactionType: 'PURCHASE_RETURN',
          quantity: -3,
          transactionDate: DateTime(2026, 1, 2),
          createdAt: Value(DateTime(2026, 1, 2)),
          previousQuantity: const Value.absent(),
          newQuantity: const Value.absent(),
        ),
      );

      // Run backfill
      await backfillInventoryTransactionQuantities(db);

      final rows = await (db.select(db.inventoryTransactions)
            ..where((t) => t.productId.equals(product.id))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();

      expect(rows[0].previousQuantity, 0);
      expect(rows[0].newQuantity, 10);
      expect(rows[1].previousQuantity, 10);
      expect(rows[1].newQuantity, 7);
    });
  });

  group('Barcode Isolation & Exact Sellable Variant Search', () {
    test('searching barcode of Variant A returns ONLY Variant A and never Variant B', () async {
      final productRepo = ProductRepository();
      final inventoryRepo = InventoryRepository();

      final product = await productRepo.createProduct(
        productName: 'T-Shirt',
        unitId: 1,
        sellingPrice: 50000,
        variants: [
          const VariantInput(variantName: 'Red Small', sellingPrice: 50000, barcode: 'BAR-RED-S'),
          const VariantInput(variantName: 'Blue Large', sellingPrice: 55000, barcode: 'BAR-BLU-L'),
        ],
      );

      final redVariant = product.variants.firstWhere((v) => v.variantName == 'Red Small');
      final blueVariant = product.variants.firstWhere((v) => v.variantName == 'Blue Large');

      // Test adjustmentOptions
      final redOptions = await inventoryRepo.adjustmentOptions(query: 'BAR-RED-S');
      expect(redOptions.length, 1);
      expect(redOptions.first.variantId, redVariant.id);
      expect(redOptions.first.itemName, 'Red Small');

      final blueOptions = await inventoryRepo.adjustmentOptions(query: 'BAR-BLU-L');
      expect(blueOptions.length, 1);
      expect(blueOptions.first.variantId, blueVariant.id);
      expect(blueOptions.first.itemName, 'Blue Large');

      // Test stockItems listing filter
      final redListing = (await inventoryRepo.fetchPage(query: 'BAR-RED-S')).items;
      expect(redListing.length, 1);
      expect(redListing.first.variantId, redVariant.id);
    });
  });

  group('Selling Price Column in Inventory List', () {
    testWidgets('displays "Selling Price" column header and formatted selling price', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final productRepo = ProductRepository();
      await productRepo.createProduct(
        productName: 'Luxury Pen',
        unitId: 1,
        sellingPrice: 125000, // ₹1,250.00
        purchasePrice: 80000,  // ₹800.00
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: InventoryListPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Selling Price'), findsOneWidget);
      expect(find.text('₹1250'), findsOneWidget);
      expect(find.text('₹800.00'), findsNothing);
    });
  });

  group('Stock Adjustment Dialog UI', () {
    testWidgets('Segmented button renders Increase and Decrease without wrapping or overflow', (tester) async {
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final productRepo = ProductRepository();
      await productRepo.createProduct(
        productName: 'Shampoo',
        unitId: 1,
        sellingPrice: 25000,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showStockAdjustmentDialog(context),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Increase'), findsOneWidget);
      expect(find.text('Decrease'), findsOneWidget);
      expect(find.text('Select a product or variant'), findsOneWidget);
    });
  });
}
