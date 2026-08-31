import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/presentation/pages/create_purchase_page.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> seedSupplier() async {
    await SupplierRepository().createSupplier(
      supplierName: 'Acme Supplies',
      mobile: '9876543210',
    );
  }

  Future<void> seedParleG() async {
    await ProductRepository().createProduct(
      productName: 'Parle-G',
      unitId: 1,
      sellingPrice: 1000,
      purchasePrice: 800,
      variants: [
        VariantInput(
          variantName: 'Parle-G 5',
          sellingPrice: 600,
          purchasePrice: 500,
          barcode: 'BAR5',
        ),
        VariantInput(
          variantName: 'Parle-G 10',
          sellingPrice: 1200,
          purchasePrice: 1000,
          barcode: 'BAR10',
        ),
      ],
    );
  }

  Future<void> pumpPurchasePage(WidgetTester tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CreatePurchasePage(
            onSave: () {},
            onCancel: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The Barcode text field in the first product row, located by its hint text.
  Finder barcodeField() => find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Scan or enter barcode',
      );

  /// The Product dropdown in the first row.
  Finder productDropdown() => find.byWidgetPredicate(
        (w) =>
            w is DropdownButtonFormField<String> &&
            (w.key as ValueKey<String>?)?.value.startsWith('product-0') == true,
      );

  group('product dropdown', () {
    testWidgets(
        'shows the main product together with all its sellable variants',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      await tester.tap(productDropdown());
      await tester.pumpAndSettle();

      // The main product AND every variant are each independently selectable.
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Parle-G'),
          findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Parle-G 5'),
          findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Parle-G 10'),
          findsOneWidget);
      // Parent and variant names are never combined.
      expect(find.text('Parle-G 5 - Parle-G 10'), findsNothing);
    });
  });

  group('barcode scanning', () {
    testWidgets('existing barcode selects the exact variant and fills fields',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'BAR10');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // The scanned barcode value appears in the Barcode field.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == 'Scan or enter barcode' &&
              w.controller?.text == 'BAR10',
        ),
        findsOneWidget,
      );
      // The exact variant is selected.
      expect(barcodeField(), findsWidgets);
      expect(find.text('Parle-G 10'), findsWidgets);
      // Purchase price defaulted from the variant (₹10.00).
      expect(find.text('10'), findsWidgets);
      // Quantity defaulted to 1 for a scan.
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('barcode A picks Parle-G 5 and Barcode B picks Parle-G 10',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Parle-G 5'), findsWidgets);

      // A second row for the other variant.
      await tester.tap(find.text('Add Product'));
      await tester.pumpAndSettle();

      await tester.enterText(barcodeField().last, 'BAR10');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Parle-G 10'), findsWidgets);
    });

    testWidgets(
        'scanning a different barcode replaces previous product details',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      // Scan BAR5 first.
      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Parle-G 5'), findsWidgets);
      expect(find.text('5'), findsWidgets);

      // Modify quantity to 4.
      final qtyFinder = find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.decoration?.hintText == '0' &&
            w.controller?.text == '1',
      );
      await tester.enterText(qtyFinder, '4');
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);

      // Now scan BAR10 in the same row.
      await tester.enterText(barcodeField(), 'BAR10');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Details must be completely replaced by BAR10.
      expect(find.text('Parle-G 10'), findsWidgets);
      expect(find.text('10'), findsWidgets);
      expect(find.text('1'), findsWidgets);
      expect(find.text('4'), findsNothing);
    });

    testWidgets('unknown barcode shows a red error and is not accepted',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'UNKNOWN123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(
        find.text('Barcode not found. Please add this product first.'),
        findsOneWidget,
      );
      // No product is selected for the unknown code.
      expect(find.text('Parle-G 5'), findsNothing);
      expect(find.text('Parle-G 10'), findsNothing);
      // The unknown code is not retained on the line as a saved item.
      await tester.tap(find.text('Save Purchase'));
      await tester.pumpAndSettle();
      expect(find.text('Select a product.'), findsWidgets);
    });

    testWidgets('scanning an existing barcode never creates a duplicate product',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      final db = DatabaseProvider.instance.database;
      final before = await db.select(db.products).get();
      expect(before, hasLength(1));

      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final after = await db.select(db.products).get();
      expect(after, hasLength(1));
      final variants = await ProductRepository().getVariants(before.single.id);
      expect(variants, hasLength(2));
    });
  });

  group('purchase price', () {
    testWidgets('price is defaulted and can be edited', (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Variant purchase price defaulted to ₹5.00.
      expect(find.text('5'), findsWidgets);

      // User can still change it for this purchase.
      Finder priceField() => find.byWidgetPredicate(
            (w) =>
                w is TextField &&
                w.decoration?.hintText == '0.00' &&
                (w.controller?.text == '5'),
          );
      await tester.tap(priceField());
      await tester.enterText(priceField(), '7');
      await tester.pumpAndSettle();
      expect(find.text('7'), findsWidgets);
    });
  });

  group('tax auto-population', () {
    testWidgets('scan fills the tax rate from the product Tax Category total',
        (tester) async {
      await seedSupplier();
      // Seeded GST 18% (category id 4) = CGST 9 + SGST 9, total 18.
      await ProductRepository().createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 800,
        taxCategoryId: 4,
        variants: [
          VariantInput(
            variantName: 'Parle-G 5',
            sellingPrice: 600,
            purchasePrice: 500,
            barcode: 'BAR5',
          ),
        ],
      );

      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tax rate auto-populated from the Tax Category's configured total (18%).
      Finder taxField() => find.byWidgetPredicate(
            (w) =>
                w is TextField &&
                w.decoration?.hintText == '0' &&
                w.controller?.text == '18',
          );
      expect(taxField(), findsOneWidget);
    });

    testWidgets('a product without a Tax Category leaves the tax field manual',
        (tester) async {
      await seedSupplier();
      await ProductRepository().createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 800,
        variants: [
          VariantInput(
            variantName: 'Parle-G 5',
            sellingPrice: 600,
            purchasePrice: 500,
            barcode: 'BAR5',
          ),
        ],
      );

      await pumpPurchasePage(tester);

      await tester.enterText(barcodeField(), 'BAR5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // No tax rate was auto-filled for a product with no Tax Category.
      expect(find.text('18'), findsNothing);
    });
  });

  group('dropdown selection sync', () {
    testWidgets('selecting from the dropdown fills barcode, price and tax',
        (tester) async {
      await seedSupplier();
      // Seeded GST 18% (category id 4); the variant inherits the parent tax.
      await ProductRepository().createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 800,
        taxCategoryId: 4,
        variants: [
          VariantInput(
            variantName: 'Parle-G 5',
            sellingPrice: 600,
            purchasePrice: 500,
            barcode: 'BAR5',
          ),
          VariantInput(
            variantName: 'Parle-G 10',
            sellingPrice: 1200,
            purchasePrice: 1000,
            barcode: 'BAR10',
          ),
        ],
      );

      await pumpPurchasePage(tester);

      // Pick the variant from the dropdown.
      await tester.tap(productDropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parle-G 5').last);
      await tester.pumpAndSettle();

      // Barcode field kept in sync with the selected variant.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == 'Scan or enter barcode' &&
              w.controller?.text == 'BAR5',
        ),
        findsOneWidget,
      );
      // Price defaulted from the variant.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == '0.00' &&
              w.controller?.text == '5',
        ),
        findsOneWidget,
      );
      // Tax defaulted from the resolved rate.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == '0' &&
              w.controller?.text == '18',
        ),
        findsOneWidget,
      );
    });
  });

  group('add new product', () {
    testWidgets(
        'creates a product, returns to the same row and auto-selects it',
        (tester) async {
      await seedSupplier();
      await UnitRepository().createUnit(name: 'Pieces', symbol: 'pcs',
          family: 'Unit');
      await pumpPurchasePage(tester);

      // Open the product dropdown and choose "+ Add New Product".
      await tester.tap(productDropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add New Product'));
      await tester.pumpAndSettle();

      expect(find.text('Create Product'), findsWidgets);

      await tester.enterText(
        find.byKey(const ValueKey('product-name')),
        'Parle-G 10',
      );
      await tester.ensureVisible(find.text('Select unit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select unit'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pieces (pcs)').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('product-selling-price')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('product-selling-price')),
        '100',
      );
      await tester.ensureVisible(find.text('Save Product'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Product'));
      await tester.pumpAndSettle();

      // Back on the purchase page, the same row is still present and the new
      // product is auto-selected in the Product dropdown.
      expect(find.text('Purchase Entry'), findsWidgets);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Parle-G 10'), findsWidgets);

      // The new product is immediately available in the catalogue.
      final products = await ProductRepository().fetchAllWithVariants();
      expect(products.any((p) => p.productName == 'Parle-G 10'), isTrue);
    });
  });

  group('edit mode', () {
    testWidgets('loads the existing purchase data when editing',
        (tester) async {
      await seedSupplier();
      await seedParleG();

      // Find the 'Parle-G 10' variant id.
      final variants = await ProductRepository().getVariants(1);
      final parleG10 = variants.firstWhere((v) => v.variantName == 'Parle-G 10');

      // Create a purchase with a variant line.
      final repo = PurchaseRepository();
      final created = await repo.createPurchase(
        supplierId: 1,
        purchaseDate: DateTime(2026, 8, 4),
        invoiceNumber: 'INV-100',
        paidAmount: 500,
        notes: 'Edit me',
        items: [
          PurchaseItemInput(
            productId: 1,
            variantId: parleG10.id,
            quantity: 3,
            unitId: 1,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      // Load the full purchase with items and open the edit form.
      final full = await repo.getById(created.id);
      useTallViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: CreatePurchasePage(
              purchase: full,
              onSave: () {},
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title indicates edit mode.
      expect(find.text('Edit Purchase'), findsWidgets);

      // Product row is populated (variant name shown).
      expect(find.text('Parle-G 10'), findsWidgets);
      // Quantity populated.
      expect(
        find.byWidgetPredicate(
          (w) => w is TextField && w.controller?.text == '3',
        ),
        findsOneWidget,
      );
      // Notes populated.
      expect(
        find.byWidgetPredicate(
          (w) => w is TextField && w.controller?.text == 'Edit me',
        ),
        findsWidgets,
      );
    });
  });

  group('currency from company settings', () {
    testWidgets('discount type selector uses a percentage and currency symbol',
        (tester) async {
      await seedSupplier();
      await seedParleG();
      await pumpPurchasePage(tester);

      // Open the discount-type selector (keyed per row) and confirm both the
      // percentage and the currency-symbol options are offered.
      await tester.tap(find.byKey(const ValueKey('discount-type-0')));
      await tester.pumpAndSettle();
      expect(find.text('%'), findsWidgets);
      expect(find.text('₹'), findsWidgets);
    });
  });
}
