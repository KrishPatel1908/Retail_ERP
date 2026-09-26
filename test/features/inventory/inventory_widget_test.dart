import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> pumpInventoryPage(WidgetTester tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: InventoryListPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> seedOnePurchase() async {
    final supplier = await SupplierRepository().createSupplier(
      supplierName: 'Acme',
      mobile: '9876543210',
    );
    final product = await ProductRepository().createProduct(
      productName: 'Parle-G',
      unitId: 1,
      sellingPrice: 1000,
      purchasePrice: 500,
      barcode: '890123',
      minimumStock: 5,
    );
    await PurchaseRepository().createPurchase(
      supplierId: supplier.id,
      purchaseDate: DateTime(2026, 9, 1),
      items: [
        PurchaseItemInput(
          productId: product.id,
          quantity: 20,
          unitId: 1,
          purchasePrice: 500,
          taxRate: 0,
        ),
      ],
    );
  }

  testWidgets('renders stock rows from purchases', (tester) async {
    await seedOnePurchase();
    await pumpInventoryPage(tester);

    expect(find.text('Parle-G'), findsOneWidget);
    expect(find.text('890123'), findsOneWidget);
    expect(find.text('In Stock'), findsOneWidget);
    expect(find.text('Piece'), findsOneWidget);
  });

  testWidgets('shows an empty state when nothing is stocked', (tester) async {
    await pumpInventoryPage(tester);

    expect(find.text('No stock items yet'), findsOneWidget);
  });

  testWidgets('search filters rows database-side', (tester) async {
    await seedOnePurchase();
    await pumpInventoryPage(tester);

    await tester.enterText(find.byType(TextField).first, 'nomatch');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('No matching stock items'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '890');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Parle-G'), findsOneWidget);
  });

  testWidgets('view stock opens the detail dialog with movement history',
      (tester) async {
    await seedOnePurchase();
    await pumpInventoryPage(tester);

    await tester.tap(find.byTooltip('View Stock'));
    await tester.pumpAndSettle();

    // The detail dialog is rendered by showDialog with the movement history.
    expect(find.text('Stock Movement History'), findsOneWidget);
    expect(find.text('Purchase'), findsOneWidget);
    expect(find.text('+20'), findsOneWidget);
    expect(find.byTooltip('Close'), findsOneWidget);
  });
}
