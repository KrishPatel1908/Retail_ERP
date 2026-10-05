import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/sales/data/repositories/sales_repository.dart';
import 'package:retail_erp/features/sales/presentation/pages/sales_pos_page.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  late ProductRepository productRepo;
  late SupplierRepository supplierRepo;
  late PurchaseRepository purchaseRepo;
  late SalesRepository salesRepo;
  late StockService stockService;

  setUp(() {
    productRepo = ProductRepository();
    supplierRepo = SupplierRepository();
    purchaseRepo = PurchaseRepository();
    salesRepo = SalesRepository();
    stockService = StockService();
  });

  Future<void> addStock({
    required int productId,
    int? variantId,
    required int quantity,
    int purchasePrice = 500,
  }) async {
    final supplier = await supplierRepo.createSupplier(
      supplierName: 'Acme Dist',
      mobile: '98${(DateTime.now().microsecondsSinceEpoch % 100000000).toString().padLeft(8, '0')}',
    );

    await purchaseRepo.createPurchase(
      supplierId: supplier.id,
      purchaseDate: DateTime(2026, 1, 1),
      paidAmount: quantity * purchasePrice,
      items: [
        PurchaseItemInput(
          productId: productId,
          variantId: variantId,
          quantity: quantity,
          unitId: 1, // Piece
          purchasePrice: purchasePrice,
          taxRate: 0,
        ),
      ],
    );
  }

  Future<void> pumpSalesPosPage(
    WidgetTester tester, {
    Size size = const Size(1280, 850),
  }) async {
    useTallViewport(tester, size: size);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: SalesPosPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Sales POS UI Layout & Responsiveness', () {
    testWidgets('Renders cleanly on 1280x800 without RenderFlex overflow', (tester) async {
      await pumpSalesPosPage(tester, size: const Size(1280, 800));

      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Walk-in Customer'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('Scan barcode or search by product / variant name...'), findsOneWidget);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Current Sale'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 1200x800 without RenderFlex overflow', (tester) async {
      await pumpSalesPosPage(tester, size: const Size(1200, 800));

      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 1024x768 without RenderFlex overflow', (tester) async {
      await pumpSalesPosPage(tester, size: const Size(1024, 768));

      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 900x700 without RenderFlex overflow', (tester) async {
      await pumpSalesPosPage(tester, size: const Size(900, 700));

      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 850x700 without RenderFlex overflow', (tester) async {
      await pumpSalesPosPage(tester, size: const Size(850, 700));

      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Barcode and Product Search Flow', () {
    testWidgets('Scanning valid barcode adds product to cart and updates totals', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Parle-G 10',
        unitId: 1,
        sellingPrice: 1000, // ₹10.00
        barcode: '8901234567893',
      );
      await addStock(productId: p.id, quantity: 20);

      await pumpSalesPosPage(tester);

      // Enter barcode in search field
      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, '8901234567893');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Cart should now show Parle-G 10 with quantity 1
      expect(find.text('Parle-G 10'), findsWidgets);
      expect(find.text('₹10.00'), findsWidgets);
      expect(find.text('Grand Total'), findsOneWidget);

      // Scan barcode again -> quantity increases to 2
      await tester.enterText(searchInput, '8901234567893');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('₹20.00'), findsWidgets);
    });

    testWidgets('Unknown barcode shows clear error message and preserves cart', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Existing Pen',
        unitId: 1,
        sellingPrice: 1500,
        barcode: 'VALID-PEN',
      );
      await addStock(productId: p.id, quantity: 10);

      await pumpSalesPosPage(tester);

      // Add one valid product
      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'VALID-PEN');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Existing Pen'), findsWidgets);

      // Scan unknown barcode
      await tester.enterText(searchInput, 'UNKNOWN-999');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Clear message shown
      expect(
        find.text('Product not found. Please add this product first.'),
        findsOneWidget,
      );
      // Cart items preserved
      expect(find.text('Existing Pen'), findsWidgets);
    });

    testWidgets('Out of stock product cannot be added to cart', (tester) async {
      await productRepo.createProduct(
        productName: 'Out of Stock Biscuit',
        unitId: 1,
        sellingPrice: 500,
        barcode: 'ZERO-STK',
      );

      await pumpSalesPosPage(tester);

      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'ZERO-STK');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.textContaining('is out of stock'), findsOneWidget);
      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });

  group('Cart Operations & Validation', () {
    testWidgets('Quantity changes update totals and reject exceeding stock', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Notebook',
        unitId: 1,
        sellingPrice: 5000, // ₹50.00
        barcode: 'NOTE-1',
      );
      await addStock(productId: p.id, quantity: 5);

      await pumpSalesPosPage(tester);

      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'NOTE-1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('₹50.00'), findsWidgets);

      // Tap '+' to increase quantity to 2
      final plusButton = find.byIcon(Icons.add_circle_outline_rounded);
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      expect(find.text('₹100.00'), findsWidgets);

      // Change quantity directly exceeding stock (e.g. 10)
      final qtyInput = find.widgetWithText(TextField, '2');
      if (qtyInput.evaluate().isNotEmpty) {
        await tester.enterText(qtyInput, '10');
        await tester.pumpAndSettle();
        expect(find.textContaining('Available stock: 5'), findsOneWidget);
      }
    });

    testWidgets('Removing cart item removes row and updates totals', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Eraser',
        unitId: 1,
        sellingPrice: 500,
        barcode: 'ERASER-1',
      );
      await addStock(productId: p.id, quantity: 10);

      await pumpSalesPosPage(tester);

      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'ERASER-1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Eraser'), findsWidgets);

      // Remove item
      final deleteIcon = find.byIcon(Icons.delete_outline_rounded);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
    });

    testWidgets('Clear cart confirms with dialog before clearing', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Ruler',
        unitId: 1,
        sellingPrice: 1000,
        barcode: 'RULER-1',
      );
      await addStock(productId: p.id, quantity: 10);

      await pumpSalesPosPage(tester);

      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'RULER-1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tap "Clear"
      final clearCartBtn = find.text('Clear');
      await tester.tap(clearCartBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('Clear all items from this sale?'), findsOneWidget);

      // Confirm clear
      final confirmBtn = find.widgetWithText(FilledButton, 'Clear Cart');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });

  group('Payment & Completion Flow', () {
    testWidgets('Full Cash payment completes sale, reduces stock, and shows success dialog', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'M4 Air',
        unitId: 1,
        sellingPrice: 8000000, // ₹80,000.00
        barcode: 'MAC-AIR-1',
      );
      await addStock(productId: p.id, quantity: 5);

      await pumpSalesPosPage(tester);

      // Add product
      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'MAC-AIR-1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Enter amount received (₹80,000)
      final receivedInput = find.widgetWithText(TextField, '0.00');
      if (receivedInput.evaluate().isNotEmpty) {
        await tester.enterText(receivedInput, '80000');
        await tester.pumpAndSettle();
      }

      // Tap "Pay / Complete Sale"
      final completeBtn = find.text('Pay / Complete Sale (F12)');
      await tester.tap(completeBtn);
      await tester.pumpAndSettle();

      // Payment Dialog opens
      expect(find.text('Payment / Checkout'), findsOneWidget);

      // Confirm Payment
      final confirmBtn = find.text('Confirm Payment');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Bill Preview shown
      expect(find.text('Sale Completed — Bill Preview'), findsOneWidget);
      expect(find.text('₹80000.00'), findsWidgets);

      // Click "Next Sale" resets POS
      final nextSaleBtn = find.text('Next Sale');
      await tester.tap(nextSaleBtn);
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);

      // Verify stock in database reduced from 5 to 4
      final stock = await stockService.currentStock(p.id, null);
      expect(stock, 4);
    });

    testWidgets('Double clicking Complete Sale triggers only one sale', (tester) async {
      final p = await productRepo.createProduct(
        productName: 'Single Sale Item',
        unitId: 1,
        sellingPrice: 1000,
        barcode: 'SINGLE-1',
      );
      await addStock(productId: p.id, quantity: 10);

      await pumpSalesPosPage(tester);

      final searchInput = find.byType(TextField).first;
      await tester.enterText(searchInput, 'SINGLE-1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final completeBtn = find.text('Pay / Complete Sale (F12)');
      await tester.tap(completeBtn);
      await tester.pumpAndSettle();

      final confirmBtn = find.text('Confirm Payment');
      await tester.ensureVisible(confirmBtn);
      await tester.pumpAndSettle();

      // Rapid double tap on Confirm Payment
      await tester.tap(confirmBtn);
      await tester.tap(confirmBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Exactly one sale created in database
      final sales = await salesRepo.fetchPage();
      expect(sales.totalCount, 1);
      // Stock reduced by exactly 1 (10 -> 9)
      expect(await stockService.currentStock(p.id, null), 9);
    });
  });
}
