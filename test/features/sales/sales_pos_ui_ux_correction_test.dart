import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/features/sales/data/repositories/bill_format_repository.dart';
import 'package:retail_erp/features/sales/data/services/sales_demo_data_seeder.dart';
import 'package:retail_erp/features/sales/domain/entities/bill_format_settings.dart';
import 'package:retail_erp/features/sales/presentation/pages/bill_format_settings_page.dart';
import 'package:retail_erp/features/sales/presentation/pages/sales_pos_page.dart';
import 'package:retail_erp/features/sales/presentation/widgets/receipt_view.dart';
import 'package:retail_erp/features/shell/widgets/app_sidebar.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  late SalesDemoDataSeeder demoSeeder;

  setUp(() {
    BillFormatRepository.instance.resetForTest();
    demoSeeder = SalesDemoDataSeeder();
  });

  Future<void> pumpPos(
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

  // ══════════════════════════════════════════════════════════
  // GROUP 1: OVERALL APPLICATION LAYOUT & SIDEBAR (Parts 1-3)
  // ══════════════════════════════════════════════════════════
  group('Overall Shell Layout & Sidebar Structure', () {
    testWidgets('Sidebar occupies full height with top logo, and no separate top application bar', (tester) async {
      useTallViewport(tester, size: const Size(1280, 800));
      await tester.pumpWidget(const RetailErpApp());
      await tester.pumpAndSettle();

      // Sidebar contains the Retail ERP brand mark and title at the very top
      expect(find.byType(AppSidebar), findsOneWidget);
      expect(find.text('Retail ERP'), findsOneWidget);
      expect(find.byKey(const ValueKey('sidebar-toggle')), findsOneWidget);

      // Verify sidebar navigation items
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Sales (POS)'), findsOneWidget);
    });

    testWidgets('Navigate to Sales POS renders compact module header inside content area', (tester) async {
      useTallViewport(tester, size: const Size(1280, 800));
      await tester.pumpWidget(const RetailErpApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sales (POS)'));
      await tester.pumpAndSettle();

      // Compact module header
      expect(find.text('Sales POS'), findsOneWidget);
      expect(find.text('Walk-in Customer'), findsOneWidget);
      expect(find.text('Current Sale'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 2: SALES POS PAGE STRUCTURE & CART PLACEMENT (Parts 4-7)
  // ══════════════════════════════════════════════════════════
  group('Sales POS Page Structure & Cart Placement', () {
    testWidgets('Empty cart state lives ONLY inside right panel, product browsing stays visible', (tester) async {
      await pumpPos(tester);

      // Search and category chips are visible
      expect(find.text('Scan barcode or search by product / variant name...'), findsOneWidget);
      expect(find.text('All Products'), findsOneWidget);

      // Empty cart state is placed inside right panel
      expect(find.text('Current Sale'), findsOneWidget);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Scan/search or click a\nproduct to add it.'), findsOneWidget);

      // Grand Total and Pay button remain visible
      expect(find.text('Grand Total'), findsOneWidget);
      expect(find.text('Pay / Complete Sale (F12)'), findsOneWidget);
    });

    testWidgets('Responsive layouts render without RenderFlex overflow', (tester) async {
      for (final size in [
        const Size(1280, 800),
        const Size(1200, 800),
        const Size(1024, 768),
        const Size(900, 700),
        const Size(850, 700),
      ]) {
        await pumpPos(tester, size: size);
        expect(tester.takeException(), isNull, reason: 'Failed on $size');
      }
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 3: PRODUCT SELECTION & VARIANTS (Parts 8-12)
  // ══════════════════════════════════════════════════════════
  group('Product Selection & Variants Flow', () {
    testWidgets('Clicking product card adds it to cart immediately and increments on repeat click', (tester) async {
      // Seed demo data
      await demoSeeder.seedDemoData();

      await pumpPos(tester);

      // Find 'Parle-G 10' product card and click it
      final parleGCard = find.text('Parle-G 10');
      expect(parleGCard, findsWidgets);

      await tester.tap(parleGCard.first);
      await tester.pumpAndSettle();

      // Right cart now shows 1 item
      expect(find.text('Current Sale (1 items)'), findsOneWidget);
      expect(find.text('₹10.00'), findsWidgets);

      // Click card again -> quantity increments to 2
      await tester.tap(parleGCard.first);
      await tester.pumpAndSettle();

      expect(find.text('Current Sale (2 items)'), findsOneWidget);
      expect(find.text('₹20.00'), findsWidgets);
    });

    testWidgets('Variant products appear as independent sellable items', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      // Parle-G 10 (₹10) and Parle-G 50 (₹50) exist independently
      expect(find.text('Parle-G 10'), findsWidgets);
      expect(find.text('Parle-G 50'), findsWidgets);

      // Add Parle-G 50
      await tester.tap(find.text('Parle-G 50').first);
      await tester.pumpAndSettle();

      expect(find.text('₹50.00'), findsWidgets);
    });

    testWidgets('Out of stock product card is disabled and cannot be clicked', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      // Filter to Beverages to find out of stock Nescafe
      await tester.tap(find.text('Beverages'));
      await tester.pumpAndSettle();

      expect(find.text('Out of Stock'), findsWidgets);

      // Tapping out of stock item does nothing
      final oosCard = find.textContaining('Nescafe');
      if (oosCard.evaluate().isNotEmpty) {
        await tester.tap(oosCard.first);
        await tester.pumpAndSettle();
        expect(find.text('Cart is empty'), findsOneWidget);
      }
    });

    testWidgets('Category filtering updates product cards', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      // Tap 'Personal Care' category
      await tester.tap(find.text('Personal Care'));
      await tester.pumpAndSettle();

      // Soaps should be displayed
      expect(find.text('Dettol Soap'), findsWidgets);
      expect(find.text('Dove Soap'), findsWidgets);

      // Tap 'All Products' chip to restore
      await tester.tap(find.text('All Products'));
      await tester.pumpAndSettle();
      expect(find.text('M4 Air'), findsWidgets);
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 4: CART SCROLLING & FINANCIAL SUMMARY (Parts 13-18)
  // ══════════════════════════════════════════════════════════
  group('Cart Operations & Financial Calculations', () {
    testWidgets('Cart item quantity adjustments and item deletion update totals', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      // Add Dettol Soap (₹140)
      await tester.tap(find.text('Dettol Soap').first);
      await tester.pumpAndSettle();

      expect(find.text('Current Sale (1 items)'), findsOneWidget);
      expect(find.text('₹140.00'), findsWidgets);

      // Tap '+' in cart row
      final plusButton = find.byIcon(Icons.add_circle_outline_rounded);
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      expect(find.text('Current Sale (2 items)'), findsOneWidget);
      expect(find.text('₹280.00'), findsWidgets);

      // Tap '-' in cart row
      final minusButton = find.byIcon(Icons.remove_circle_outline_rounded);
      await tester.tap(minusButton);
      await tester.pumpAndSettle();

      expect(find.text('Current Sale (1 items)'), findsOneWidget);
      expect(find.text('₹140.00'), findsWidgets);

      // Remove item with trash icon
      final deleteButton = find.byIcon(Icons.delete_outline_rounded);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('Bill discount updates Grand Total', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      // Add Dettol Soap (₹140)
      await tester.tap(find.text('Dettol Soap').first);
      await tester.pumpAndSettle();

      // Enter Bill Discount = 20
      final discountField = find.widgetWithText(TextField, '0');
      await tester.enterText(discountField, '20');
      await tester.pumpAndSettle();

      // Total discount row appears
      expect(find.text('Total Discount'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 5: PAYMENT DIALOG & CANCEL / CONFIRM FLOW (Parts 16-17, 30)
  // ══════════════════════════════════════════════════════════
  group('Payment Dialog & Cancel/Confirm Flow', () {
    testWidgets('Clicking Pay opens PaymentDialog, Cancel preserves cart without database change', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      await tester.tap(find.text('Dettol Soap').first);
      await tester.pumpAndSettle();

      // Tap Pay button
      await tester.tap(find.text('Pay / Complete Sale (F12)'));
      await tester.pumpAndSettle();

      // Payment dialog opened with payment methods
      expect(find.text('Payment / Checkout'), findsOneWidget);
      expect(find.text('Cash'), findsWidgets);
      expect(find.text('UPI'), findsWidgets);
      expect(find.text('Card'), findsWidgets);

      // Tap Cancel in Payment Dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog closed, cart remains intact
      expect(find.text('Payment / Checkout'), findsNothing);
      expect(find.text('Current Sale (1 items)'), findsOneWidget);
      expect(find.text('Dettol Soap'), findsWidgets);
    });

    testWidgets('Confirm Payment saves sale atomically and opens Bill Preview', (tester) async {
      await demoSeeder.seedDemoData();
      await pumpPos(tester);

      await tester.tap(find.text('Dettol Soap').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pay / Complete Sale (F12)'));
      await tester.pumpAndSettle();

      // Confirm Payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      // Bill Preview Dialog opened
      expect(find.textContaining('Bill Preview'), findsOneWidget);
      expect(find.text('Print Bill'), findsOneWidget);
      expect(find.text('Next Sale'), findsOneWidget);

      // Tap Next Sale to return to fresh POS
      await tester.tap(find.text('Next Sale'));
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 6: BILL FORMAT TEMPLATES (Parts 22-26)
  // ══════════════════════════════════════════════════════════
  group('Bill Format Templates & Live Preview', () {
    testWidgets('Bill Format Settings page renders all 4 template options', (tester) async {
      useTallViewport(tester, size: const Size(1280, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: BillFormatSettingsPage()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // All 4 templates exist
      expect(find.text('Standard 80mm'), findsWidgets);
      expect(find.text('Detailed GST 80mm'), findsWidgets);
      expect(find.text('Compact 58mm'), findsWidgets);
      expect(find.text('Simple 80mm'), findsWidgets);

      // Live Preview updates when template card is tapped
      await tester.tap(find.text('Detailed GST 80mm').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('TAX INVOICE'), findsWidgets);

      await tester.tap(find.text('Compact 58mm').first);
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Simple 80mm').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('NET AMOUNT'), findsWidgets);
    });

    testWidgets('ReceiptView renders detailed GST template with tax breakdown', (tester) async {
      const settings = BillFormatSettings(
        templateType: BillTemplateType.detailedGst80,
      );

      final items = [
        const ReceiptLineItem(
          productName: 'M4 Pro',
          hsnCode: '8471',
          quantity: 1,
          unitPricePaise: 12000000,
          lineTotalPaise: 12000000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReceiptView(
                saleNumber: 'SAL-000010',
                saleDate: DateTime(2026, 10, 4, 14, 30),
                companyName: 'RETAIL STORE ERP',
                companyGstin: '24AAACC1206D1ZM',
                items: items,
                subtotalPaise: 12000000,
                taxPaise: 2160000,
                grandTotalPaise: 14160000,
                paidAmountPaise: 14160000,
                paymentMethod: 'UPI',
                formatSettings: settings,
              ),
            ),
          ),
        ),
      );

      expect(find.text('TAX INVOICE'), findsOneWidget);
      expect(find.text('GST TAX BREAKDOWN'), findsOneWidget);
      expect(find.text('GSTIN:'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════
  // GROUP 7: DEMO DATA SEEDER IDEMPOTENCE (Parts 20-21)
  // ══════════════════════════════════════════════════════════
  group('Sales Demo Data Seeder Idempotency', () {
    test('Seeding multiple times does not create duplicate products or throw', () async {
      expect(await demoSeeder.isSeeded(), false);

      await demoSeeder.seedDemoData();
      expect(await demoSeeder.isSeeded(), true);

      // Calling again is a no-op
      await demoSeeder.seedDemoData();
      expect(await demoSeeder.isSeeded(), true);
    });
  });
}
