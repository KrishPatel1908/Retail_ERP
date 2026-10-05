import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';
import 'package:retail_erp/features/sales/data/repositories/bill_format_repository.dart';
import 'package:retail_erp/features/sales/data/repositories/sales_repository.dart';
import 'package:retail_erp/features/sales/domain/entities/bill_format_settings.dart';
import 'package:retail_erp/features/sales/presentation/dialogs/payment_dialog.dart';
import 'package:retail_erp/features/sales/presentation/widgets/receipt_view.dart';

import '../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  late SalesRepository salesRepo;
  late ProductRepository productRepo;
  late CategoryRepository categoryRepo;
  late UnitRepository unitRepo;

  setUp(() {
    salesRepo = SalesRepository();
    productRepo = ProductRepository();
    categoryRepo = CategoryRepository();
    unitRepo = UnitRepository();
  });

  group('Phase 3 & 6: Category Filtering in SalesRepository', () {
    test('filters sellable products by categoryId in database query', () async {
      final unit = await unitRepo.createUnit(
        name: 'Pieces',
        symbol: 'pcs',
        family: 'COUNT',
      );

      final catBiscuits = await categoryRepo.createCategory(name: 'Biscuits');
      final catBeverages = await categoryRepo.createCategory(name: 'Beverages');

      // Product 1 in Biscuits
      await productRepo.createProduct(
        productName: 'Parle-G 10',
        categoryId: catBiscuits.id,
        unitId: unit.id,
        sellingPrice: 1000,
      );

      // Product 2 in Beverages
      await productRepo.createProduct(
        productName: 'Cold Coffee 200ml',
        categoryId: catBeverages.id,
        unitId: unit.id,
        sellingPrice: 4000,
      );

      // Search all
      final allItems = await salesRepo.searchSellableItems();
      expect(allItems.length, 2);

      // Filter by Biscuits
      final biscuitItems = await salesRepo.searchSellableItems(categoryId: catBiscuits.id);
      expect(biscuitItems.length, 1);
      expect(biscuitItems.first.productName, 'Parle-G 10');
      expect(biscuitItems.first.categoryId, catBiscuits.id);
      expect(biscuitItems.first.categoryName, 'Biscuits');

      // Filter by Beverages
      final beverageItems = await salesRepo.searchSellableItems(categoryId: catBeverages.id);
      expect(beverageItems.length, 1);
      expect(beverageItems.first.productName, 'Cold Coffee 200ml');
      expect(beverageItems.first.categoryId, catBeverages.id);
      expect(beverageItems.first.categoryName, 'Beverages');
    });
  });

  group('Phase 11 & 12: Payment Dialog & Cancel Behavior', () {
    testWidgets('PaymentDialog opens, calculates change for cash, and returns result on confirm', (tester) async {
      PaymentDialogResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await showPaymentDialog(
                      context,
                      grandTotalPaise: 85000, // ₹850.00
                      selectedCustomer: null,
                      currencySymbol: '₹',
                      initialReceivedPaise: 85000,
                    );
                  },
                  child: const Text('Open Pay'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Pay'));
      await tester.pumpAndSettle();

      expect(find.text('Payment / Checkout'), findsOneWidget);
      expect(find.text('₹850.00'), findsWidgets);

      // Tap ₹1000 quick cash button
      await tester.tap(find.text('₹1000'));
      await tester.pumpAndSettle();

      // Change to return should be ₹150.00
      expect(find.text('Change to Return'), findsOneWidget);
      expect(find.text('₹150.00'), findsOneWidget);

      // Confirm Payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.paymentMethod, 'Cash');
      expect(result!.amountReceived, 100000); // 1000.00 in paise
    });

    testWidgets('PaymentDialog Cancel returns null and preserves state', (tester) async {
      PaymentDialogResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await showPaymentDialog(
                      context,
                      grandTotalPaise: 125000,
                      selectedCustomer: null,
                      currencySymbol: '₹',
                    );
                  },
                  child: const Text('Open Pay'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Pay'));
      await tester.pumpAndSettle();

      expect(find.text('Payment / Checkout'), findsOneWidget);

      // Click Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.text('Payment / Checkout'), findsNothing);
    });

    testWidgets('PaymentDialog Credit requires registered customer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => showPaymentDialog(
                    context,
                    grandTotalPaise: 50000,
                    selectedCustomer: null, // Walk-in customer
                    currencySymbol: '₹',
                  ),
                  child: const Text('Open Pay'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Pay'));
      await tester.pumpAndSettle();

      // Switch to Credit
      await tester.tap(find.text('Credit'));
      await tester.pumpAndSettle();

      // Try Confirming
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      // Error message should appear
      expect(find.text('Credit sales require selecting a registered customer.'), findsWidgets);
    });
  });

  group('Phase 16-24: ReceiptView & Paper Width Rendering', () {
    testWidgets('ReceiptView renders 80mm format with items, tax, and custom footer', (tester) async {
      const settings = BillFormatSettings(
        paperSize: ReceiptPaperSize.mm80,
        showLogo: true,
        showCompanyName: true,
        showAddress: true,
        showCustomer: true,
        showHsn: true,
        showTaxBreakdown: true,
        footerMessage: 'Thank you for shopping! Visit Again!',
      );

      final items = [
        const ReceiptLineItem(
          productName: 'Parle-G 10',
          variantName: '100g',
          hsnCode: '1905',
          quantity: 2,
          unitPricePaise: 1000,
          discountPaise: 0,
          lineTotalPaise: 2000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReceiptView(
                saleNumber: 'SAL-000005',
                saleDate: DateTime(2026, 10, 4, 10, 32),
                customerName: 'Walk-in Customer',
                companyName: 'SUPER MART ERP',
                companyAddress: '123 Market Street',
                items: items,
                subtotalPaise: 2000,
                discountPaise: 0,
                taxPaise: 360,
                grandTotalPaise: 2360,
                paidAmountPaise: 2500,
                changeAmountPaise: 140,
                paymentMethod: 'Cash',
                formatSettings: settings,
                currencySymbol: '₹',
              ),
            ),
          ),
        ),
      );

      expect(find.text('SUPER MART ERP'), findsOneWidget);
      expect(find.text('SAL-000005'), findsOneWidget);
      expect(find.text('Parle-G 10 (100g)'), findsOneWidget);
      expect(find.text('Thank you for shopping! Visit Again!'), findsOneWidget);
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('₹23.60'), findsOneWidget);
    });

    testWidgets('ReceiptView renders 58mm format compactly', (tester) async {
      const settings = BillFormatSettings(
        paperSize: ReceiptPaperSize.mm58,
        showLogo: false,
        showHsn: false,
      );

      final items = [
        const ReceiptLineItem(
          productName: 'M4 Air',
          quantity: 1,
          unitPricePaise: 8000000,
          lineTotalPaise: 8000000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReceiptView(
                saleNumber: 'SAL-000006',
                saleDate: DateTime.now(),
                companyName: 'TECH STORE',
                items: items,
                subtotalPaise: 8000000,
                grandTotalPaise: 8000000,
                paidAmountPaise: 8000000,
                paymentMethod: 'UPI',
                formatSettings: settings,
              ),
            ),
          ),
        ),
      );

      expect(find.text('TECH STORE'), findsOneWidget);
      expect(find.text('SAL-000006'), findsOneWidget);
      expect(find.text('M4 Air'), findsOneWidget);
    });
  });

  group('Phase 25-28: Bill Format Settings Repository & Live Config', () {
    test('BillFormatRepository handles serialization and defaults', () {
      final repo = BillFormatRepository.instance;
      repo.resetForTest();

      expect(repo.currentSettings.paperSize, ReceiptPaperSize.mm80);
      expect(repo.currentSettings.showLogo, true);

      final modified = repo.currentSettings.copyWith(
        paperSize: ReceiptPaperSize.mm58,
        showHsn: false,
        footerMessage: 'Custom Test Footer',
      );

      repo.resetForTest(modified);
      expect(repo.currentSettings.paperSize, ReceiptPaperSize.mm58);
      expect(repo.currentSettings.showHsn, false);
      expect(repo.currentSettings.footerMessage, 'Custom Test Footer');

      // Test JSON serialization round-trip
      final json = modified.toJson();
      final restored = BillFormatSettings.fromJson(json);
      expect(restored.paperSize, ReceiptPaperSize.mm58);
      expect(restored.showHsn, false);
      expect(restored.footerMessage, 'Custom Test Footer');
    });
  });
}
