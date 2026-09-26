import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/data/repositories/inventory_repository.dart';
import 'package:retail_erp/features/inventory/domain/entities/inventory.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';

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
}
