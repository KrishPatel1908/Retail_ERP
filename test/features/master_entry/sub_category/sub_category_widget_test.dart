import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/sub_category/data/repositories/sub_category_repository.dart';
import 'package:retail_erp/features/master_entry/sub_category/domain/entities/sub_category.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openSubCategoryPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Sub Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sub Category'));
    await tester.pumpAndSettle();
  }

  Future<int> seedCategory(String name) async {
    final catRepo = CategoryRepository();
    final cat = await catRepo.createCategory(name: name);
    return cat.id;
  }

  Future<SubCategory> seedSubCategory(
    int categoryId,
    String name, {
    String? description,
  }) async {
    final subRepo = SubCategoryRepository();
    return subRepo.createSubCategory(
      categoryId: categoryId,
      name: name,
      description: description,
    );
  }

  testWidgets('shows seeded sub-categories in the table', (tester) async {
    final catId = await seedCategory('Electronics');
    await seedSubCategory(catId, 'Mobile Phones', description: 'Smartphones');
    await seedSubCategory(catId, 'Laptops', description: 'Portable computers');

    await openSubCategoryPage(tester);

    expect(find.text('Electronics'), findsNWidgets(2));
    expect(find.text('Mobile Phones'), findsOneWidget);
    expect(find.text('Laptops'), findsOneWidget);
    expect(find.text('Smartphones'), findsOneWidget);
    expect(find.text('No sub-categories yet'), findsNothing);
  });

  testWidgets('search filters sub-categories by query', (tester) async {
    final catId = await seedCategory('Electronics');
    await seedSubCategory(catId, 'Mobile Phones');
    await seedSubCategory(catId, 'Laptops');

    await openSubCategoryPage(tester);

    await tester.enterText(find.byType(TextField), 'Mobile');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Mobile Phones'), findsOneWidget);
    expect(find.text('Laptops'), findsNothing);
  });

  testWidgets('edit pre-fills form and updates sub-category', (tester) async {
    final catId = await seedCategory('Electronics');
    final sub = await seedSubCategory(catId, 'Mobile Phones');

    await openSubCategoryPage(tester);

    await tester.ensureVisible(
      find.byKey(ValueKey('edit-sub-category-${sub.id}')),
    );
    await tester.tap(find.byKey(ValueKey('edit-sub-category-${sub.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Sub Category'), findsNWidgets(2));

    await tester.enterText(
      find.byType(TextField).first,
      'Smart Phones',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Sub category updated successfully.'), findsOneWidget);
    expect(find.text('Smart Phones'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes sub-category', (
    tester,
  ) async {
    final catId = await seedCategory('Electronics');
    final sub = await seedSubCategory(catId, 'DeleteMe');

    await openSubCategoryPage(tester);

    await tester.ensureVisible(
      find.byKey(ValueKey('delete-sub-category-${sub.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-sub-category-${sub.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete sub category?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Sub category deleted successfully.'), findsOneWidget);
    expect(find.text('DeleteMe'), findsNothing);
  });
}
