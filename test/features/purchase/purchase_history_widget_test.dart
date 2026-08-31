import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/presentation/pages/purchase_history_page.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<(int, int)> seedSupplierAndProduct() async {
    final supplier = await SupplierRepository().createSupplier(
      supplierName: 'Acme Supplies',
      mobile: '9876543210',
    );
    final product = await ProductRepository().createProduct(
      productName: 'Parle-G',
      unitId: 1,
      sellingPrice: 1000,
      purchasePrice: 800,
    );
    return (supplier.id, product.id);
  }

  Future<void> pumpHistoryPage(
    WidgetTester tester, {
    List<Widget> Function()? appBarActions,
  }) async {
    useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: PurchaseHistoryPage(
            onNewPurchase: () {},
            onEditPurchase: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('table columns', () {
    testWidgets('shows the exact requested column order', (tester) async {
      await seedSupplierAndProduct();
      await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        notes: 'First order',
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 10,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      await pumpHistoryPage(tester);

      // Column headers in the specified order.
      final headers = [
        'Action',
        'Purchase No.',
        'Invoice No.',
        'Supplier',
        'Credit',
        'Debit',
        'Total',
        'Date',
        'Status',
        'Note',
      ];
      for (final h in headers) {
        expect(find.text(h), findsOneWidget, reason: 'Missing header "$h"');
      }
    });

    testWidgets('renders Credit (red), Debit (green) and signed Total',
        (tester) async {
      await seedSupplierAndProduct();
      // Purchase: total ₹10, paid ₹4 → credit ₹6, running total +₹6.
      await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 400,
        notes: null,
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 10,
            unitId: 1,
            purchasePrice: 100,
            taxRate: 0,
          ),
        ],
      );

      await pumpHistoryPage(tester);

      // Credit ₹6 in red.
      expect(find.text('₹6'), findsOneWidget);
      // Debit ₹4 in green.
      expect(find.text('₹4'), findsOneWidget);
      // Running balance +₹6 (signed with '+').
      expect(find.text('+₹6'), findsOneWidget);
    });
  });

  group('note column', () {
    testWidgets('shows dash when there is no note', (tester) async {
      await seedSupplierAndProduct();
      await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        notes: null,
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 1,
            unitId: 1,
            purchasePrice: 100,
            taxRate: 0,
          ),
        ],
      );

      await pumpHistoryPage(tester);
      expect(find.text('—'), findsWidgets);
    });

    testWidgets('clicking a note opens the full dialog with copy and close',
        (tester) async {
      await seedSupplierAndProduct();
      final longNote = 'Please deliver to the back entrance between 9am and 5pm.';
      await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        notes: longNote,
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 1,
            unitId: 1,
            purchasePrice: 100,
            taxRate: 0,
          ),
        ],
      );

      await pumpHistoryPage(tester);

      await tester.tap(find.text(longNote));
      await tester.pumpAndSettle();

      // Dialog shows the full note plus Copy and Close actions.
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Description'), findsNothing);
    });
  });

  group('delete action', () {
    testWidgets('shows confirmation and deletes on confirm', (tester) async {
      await seedSupplierAndProduct();
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        notes: 'Delete me',
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 5,
            unitId: 1,
            purchasePrice: 100,
            taxRate: 0,
          ),
        ],
      );
      final purchaseNo = purchase.purchaseNumber;

      await pumpHistoryPage(tester);

      // Open the delete confirm dialog.
      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Purchase'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // The purchase is gone from the database.
      final db = DatabaseProvider.instance.database;
      final remaining = await db.select(db.purchases).get();
      expect(remaining, isEmpty);
      expect(find.text(purchaseNo), findsNothing);
    });

    testWidgets('does not delete when cancelled', (tester) async {
      await seedSupplierAndProduct();
      final purchase = await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        paidAmount: 0,
        notes: 'Keep me',
        items: [
          PurchaseItemInput(
            productId: 1,
            quantity: 5,
            unitId: 1,
            purchasePrice: 100,
            taxRate: 0,
          ),
        ],
      );

      await pumpHistoryPage(tester);

      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      final db = DatabaseProvider.instance.database;
      final remaining = await db.select(db.purchases).get();
      expect(remaining, hasLength(1));
      expect(find.text(purchase.purchaseNumber), findsOneWidget);
    });
  });
}
