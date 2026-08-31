import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/brand/data/repositories/brand_repository.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openProductPage(WidgetTester tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Product Master'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Product Master'));
    await tester.pumpAndSettle();
  }

  Future<void> seedPrerequisites() async {
    final unitRepo = UnitRepository();
    await unitRepo.createUnit(name: 'Pieces', symbol: 'pcs', family: 'Unit');

    final catRepo = CategoryRepository();
    await catRepo.createCategory(name: 'Biscuits');

    final brandRepo = BrandRepository();
    await brandRepo.createBrand(name: 'Parle');
  }

  testWidgets('renders Product Master page without overflow', (tester) async {
    await seedPrerequisites();
    final productRepo = ProductRepository();
    await productRepo.createProduct(
      productName: 'Parle-G',
      unitId: 1,
      sellingPrice: 1000,
    );

    await openProductPage(tester);
    expect(find.text('Product Master'), findsWidgets);
    expect(find.text('Parle-G'), findsOneWidget);
    expect(find.text('PROD00001'), findsOneWidget);
  });

  testWidgets('clicking Add Variant adds and removes variant rows dynamically', (
    tester,
  ) async {
    await seedPrerequisites();
    await openProductPage(tester);

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    expect(find.text('Create Product'), findsWidgets);
    expect(find.text('Add Variant'), findsOneWidget);

    // Click Add Variant to add first variant
    await tester.tap(find.text('Add Variant'));
    await tester.pumpAndSettle();

    expect(find.text('Variant 1'), findsOneWidget);
    expect(find.text('Variant Name'), findsOneWidget);

    // Click Add Variant again to add second variant
    await tester.tap(find.text('Add Variant'));
    await tester.pumpAndSettle();

    expect(find.text('Variant 2'), findsOneWidget);

    // Remove first variant
    await tester.tap(find.byTooltip('Remove variant').first);
    await tester.pumpAndSettle();

    expect(find.text('Variant 1'), findsOneWidget);
    expect(find.text('Variant 2'), findsNothing);
  });

  testWidgets('creates a product with variants and saves to database', (
    tester,
  ) async {
    await seedPrerequisites();
    await openProductPage(tester);

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    // Fill Product Name
    await tester.enterText(
      find.byKey(const ValueKey('product-name')),
      'Parle-G Biscuits',
    );

    // Fill Barcode & HSN Code
    await tester.enterText(
      find.byKey(const ValueKey('product-barcode')),
      '8901234567890',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-hsn-code')),
      '1905',
    );

    // Fill Product Selling Price, Purchase Price, MRP, Wholesale
    await tester.enterText(
      find.byKey(const ValueKey('product-selling-price')),
      '20',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-purchase-price')),
      '15',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-mrp')),
      '22',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-wholesale-price')),
      '18',
    );

    // Select Unit
    await tester.tap(find.byKey(const ValueKey('product-unit-int')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pieces (pcs)').last);
    await tester.pumpAndSettle();

    // Add Variant
    await tester.tap(find.byKey(const ValueKey('add-variant-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('variant-0-name')),
      '50g Pack',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-price')),
      '10',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-purchase-price')),
      '8',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-mrp')),
      '11',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-wholesale-price')),
      '9',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-barcode')),
      '8901234567891',
    );
    await tester.enterText(
      find.byKey(const ValueKey('variant-0-hsn-code')),
      '1905',
    );

    // Save Product
    await tester.tap(find.text('Save Product'));
    await tester.pumpAndSettle();

    expect(find.text('Product created successfully.'), findsOneWidget);
    expect(find.text('Parle-G Biscuits'), findsOneWidget);
    expect(find.text('₹20'), findsOneWidget);
  });

  testWidgets('Tax dropdown lists Tax Categories, not Tax Types', (
    tester,
  ) async {
    await seedPrerequisites();
    await openProductPage(tester);

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    // The Tax dropdown offers existing Tax Categories (created in Tax Category
    // Master) by their exact name.
    await tester.ensureVisible(find.byKey(const ValueKey('product-tax-int')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('product-tax-int')));
    await tester.pumpAndSettle();

    expect(find.text('GST 5%'), findsOneWidget);
    expect(find.text('GST 12%'), findsOneWidget);
    expect(find.text('GST 18%'), findsOneWidget);
    expect(find.text('GST 28%'), findsOneWidget);
    expect(find.text('Tax Free'), findsOneWidget);

    // Atomic Tax Types must NOT be offered in the product form.
    expect(find.text('IGST'), findsNothing);
    expect(find.text('CGST'), findsNothing);
    expect(find.text('SGST'), findsNothing);
  });

  testWidgets('selecting a Tax Category saves it and reflects its name', (
    tester,
  ) async {
    await seedPrerequisites();
    await openProductPage(tester);

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('product-name')),
      'Parle-G Biscuits',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-selling-price')),
      '20',
    );
    await tester.tap(find.byKey(const ValueKey('product-unit-int')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pieces (pcs)').last);
    await tester.pumpAndSettle();

    // Pick GST 18% (seeded tax category id 4).
    await tester.ensureVisible(find.byKey(const ValueKey('product-tax-int')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('product-tax-int')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GST 18%').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save Product'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Product'));
    await tester.pumpAndSettle();

    expect(find.text('Product created successfully.'), findsOneWidget);

    final products = await ProductRepository().fetchAllWithVariants();
    final product = products.single;
    // The selected Tax Category is stored and its name displayed exactly.
    expect(product.taxCategoryId, 4);
    expect(product.taxCategoryName, 'GST 18%');
    // And its configured total (CGST 9 + SGST 9) resolves to 18%.
    final db = DatabaseProvider.instance.database;
    final rates = await db.select(db.taxCategoryRates).get();
    final total = rates
        .where((r) => r.taxCategoryId == 4)
        .fold<double>(0, (sum, r) => sum + r.ratePercent);
    expect(total, 18.0);
  });


  testWidgets('validates required fields on Save Product', (tester) async {
    await openProductPage(tester);

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Product'));
    await tester.pumpAndSettle();

    expect(find.text('Product name is required.'), findsOneWidget);
    expect(find.text('Unit is required.'), findsOneWidget);
    expect(find.text('Selling price is required.'), findsOneWidget);
  });

  testWidgets('expands row and edits a variant via dialog', (tester) async {
    await seedPrerequisites();
    final productRepo = ProductRepository();
    final product = await productRepo.createProduct(
      productName: 'Good Day',
      unitId: 1,
      sellingPrice: 1000,
    );
    await productRepo.createVariant(
      product.id,
      variantName: '50g Small',
      sellingPrice: 500,
    );

    await openProductPage(tester);
    expect(find.text('Good Day'), findsOneWidget);

    // Expand the product row
    await tester.tap(find.byIcon(Icons.keyboard_arrow_right_rounded));
    await tester.pumpAndSettle();

    expect(find.text('50g Small'), findsOneWidget);
    expect(find.byTooltip('Edit Variant'), findsOneWidget);

    // Open Edit Variant dialog
    await tester.ensureVisible(find.byTooltip('Edit Variant'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit Variant'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Variant'), findsOneWidget);

    // Change variant name and price
    await tester.enterText(find.widgetWithText(TextField, '50g Small'), '100g Large');
    await tester.enterText(find.widgetWithText(TextField, '5'), '15');

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('Variant updated successfully.'), findsOneWidget);
    expect(find.text('100g Large'), findsOneWidget);
  });
}
