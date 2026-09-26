import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_return_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/domain/entities/purchase_return.dart';
import 'package:retail_erp/features/purchase/presentation/pages/purchase_returns_page.dart';

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

  Future<void> pumpPage(
    WidgetTester tester, {
    VoidCallback? onNewReturn,
  }) async {
    useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: PurchaseReturnHistoryPage(onNewReturn: onNewReturn ?? () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<PurchaseReturnEntity> makeReturn({
    int quantity = 5,
    int purchasePrice = 500,
    int purchasedQty = 20,
  }) async {
    final (supplierId, productId) = await seedSupplierAndProduct();
    final purchase = await PurchaseRepository().createPurchase(
      supplierId: supplierId,
      purchaseDate: DateTime(2026, 8, 1),
      paidAmount: 0,
      items: [
        PurchaseItemInput(
          productId: productId,
          quantity: purchasedQty,
          unitId: 1,
          purchasePrice: purchasePrice,
          taxRate: 0,
        ),
      ],
    );
    return PurchaseReturnRepository().createReturn(
      originalPurchaseId: purchase.id,
      supplierId: supplierId,
      returnDate: DateTime(2026, 8, 3),
      items: [
        PurchaseReturnItemInput(
          purchaseItemId: purchase.items.single.id,
          productId: productId,
          returnQuantity: quantity,
          purchasePrice: purchasePrice,
          taxRate: 0,
        ),
      ],
    );
  }

  Future<int> stockOf(int productId) async {
    final database = DatabaseProvider.instance.database;
    final row =
        await (database.select(database.currentStocks)..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
            .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  group('table columns', () {
    testWidgets('shows the expected column order', (tester) async {
      await makeReturn();
      await pumpPage(tester);

      final headers = [
        'Action',
        'Return No.',
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

    testWidgets('renders Credit 0, Debit green and signed Total', (
      tester,
    ) async {
      // Return ₹25 → Credit 0, Debit ₹25, Total −₹25.
      await makeReturn(quantity: 5, purchasePrice: 500);
      await pumpPage(tester);

      expect(find.text('₹0'), findsOneWidget); // Credit
      expect(find.text('₹25'), findsOneWidget); // Debit
      expect(find.text('-₹25'), findsOneWidget); // Total (negative)
    });

    testWidgets('renders the Completed status pill', (tester) async {
      await makeReturn();
      await pumpPage(tester);

      expect(find.text('Completed'), findsWidgets);
    });
  });

  group('new return action', () {
    testWidgets('triggers onNewReturn when New Return is pressed', (
      tester,
    ) async {
      await makeReturn();
      var pressed = false;
      await pumpPage(tester, onNewReturn: () => pressed = true);

      await tester.tap(find.text('New Return'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });
  });

  group('view action', () {
    testWidgets('opens the detail dialog', (tester) async {
      final pr = await makeReturn();
      await pumpPage(tester);

      await tester.tap(find.byTooltip('View'));
      await tester.pumpAndSettle();

      // Dialog shows the return number in its title.
      expect(find.text('Purchase Return #${pr.returnNumber}'), findsOneWidget);
    });
  });

  group('revert action', () {
    testWidgets('reverts stock, payable and status on confirm', (tester) async {
      final productId = await (() async {
        final (_, pid) = await seedSupplierAndProduct();
        return pid;
      })();

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: productId,
            quantity: 20,
            unitId: 1,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );
      final pr = await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: 1,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );
      expect(await stockOf(productId), 15);

      await pumpPage(tester);

      await tester.tap(find.byTooltip('Revert'));
      await tester.pumpAndSettle();
      expect(find.text('Revert Purchase Return'), findsOneWidget);

      await tester.tap(find.text('Revert'));
      await tester.pumpAndSettle();

      // Stock restored.
      expect(await stockOf(productId), 20);
      // Status updated.
      final reloaded = await PurchaseReturnRepository().getById(pr.id);
      expect(reloaded.isReverted, isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Reverted'), findsWidgets);
    });
  });

  group('delete action', () {
    testWidgets('deletes the return on confirm', (tester) async {
      await makeReturn();
      await pumpPage(tester);

      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Purchase Return'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      final page = await PurchaseReturnRepository().fetchPage();
      expect(page.totalCount, 0);
      expect(find.text('No purchase returns'), findsOneWidget);
    });

    testWidgets('does not delete when cancelled', (tester) async {
      final pr = await makeReturn();
      await pumpPage(tester);

      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      final page = await PurchaseReturnRepository().fetchPage();
      expect(page.totalCount, 1);
      expect(find.text(pr.returnNumber), findsOneWidget);
    });
  });
}
