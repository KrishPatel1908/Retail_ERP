import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> seedTestProduct() async {
    final database = DatabaseProvider.instance.database;
    final categoryId = await database.into(database.categories).insert(
      db.CategoriesCompanion.insert(
        categoryCode: 'CAT-TEST',
        categoryName: 'General Category',
      ),
    );
    await database.into(database.products).insert(
      db.ProductsCompanion.insert(
        productCode: 'PROD-1',
        productName: 'Test Biscuit',
        categoryId: Value(categoryId),
        brandId: const Value(1),
        unitId: 1,
      ),
    );
  }

  Future<void> openProductUomPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Product UOM Conversion'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Product UOM Conversion'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders Product UOM Conversion page with empty state', (tester) async {
    await openProductUomPage(tester);

    expect(find.text('Product UOM Conversion'), findsWidgets);
    expect(find.text('No product conversions yet'), findsOneWidget);
    expect(find.text('Add Product Conversion'), findsOneWidget);
  });

  testWidgets('opens Create Product UOM Conversion form', (tester) async {
    await seedTestProduct();
    await openProductUomPage(tester);

    await tester.tap(find.text('Add Product Conversion'));
    await tester.pumpAndSettle();

    expect(find.text('Create Product Conversion'), findsWidgets);
    expect(find.text('Product'), findsWidgets);
    expect(find.text('From Unit'), findsWidgets);
    expect(find.text('To Unit'), findsWidgets);
    expect(find.text('Conversion Factor'), findsWidgets);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('shows empty products warning when no products exist in DB', (tester) async {
    await openProductUomPage(tester);

    await tester.tap(find.text('Add Product Conversion'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select a product'));
    await tester.pumpAndSettle();

    expect(find.text('No products found. Please create a product first.'), findsOneWidget);
    expect(find.text('Go to Product Master'), findsOneWidget);
  });
}
