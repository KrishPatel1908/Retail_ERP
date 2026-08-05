import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/category/domain/entities/category.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openCategoryPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Category'));
    await tester.pumpAndSettle();
  }

  Future<Category> seedCategory(String name, {String? description}) async {
    final repository = CategoryRepository();
    return repository.createCategory(name: name, description: description);
  }

  /// Advances fake time past the search debounce, then settles the load.
  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows seeded categories in the table', (tester) async {
    await seedCategory('Electronics', description: 'Devices');
    await seedCategory('Groceries');

    await openCategoryPage(tester);

    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('Active'), findsNWidgets(2));
    expect(find.text('No categories yet'), findsNothing);
  });

  testWidgets('search filters results while typing', (tester) async {
    await seedCategory('Electronics');
    await seedCategory('Groceries');

    await openCategoryPage(tester);
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'elec');
    await settleSearch(tester);

    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No categories found'), findsOneWidget);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    final category = await seedCategory('Electronics');

    await openCategoryPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('edit-category-${category.id}')),
    );
    await tester.tap(find.byKey(ValueKey('edit-category-${category.id}')));
    await tester.pumpAndSettle();

    // Breadcrumb + title, pre-filled name field.
    expect(find.text('Edit Category'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Electronics'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'Consumer Electronics',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Consumer Electronics'), findsOneWidget);
    expect(find.text('Electronics'), findsNothing);
    expect(find.text('Category updated successfully.'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    final category = await seedCategory('Electronics');

    await openCategoryPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-category-${category.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-category-${category.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete category?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Electronics'), findsNothing);
    expect(find.text('Category deleted successfully.'), findsOneWidget);
    expect(find.text('No categories yet'), findsOneWidget);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    final category = await seedCategory('Electronics');

    await openCategoryPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-category-${category.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-category-${category.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Electronics'), findsOneWidget);
  });

  testWidgets('save requires a category name', (tester) async {
    await openCategoryPage(tester);
    await tester.tap(find.text('Add Category'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Category name is required.'), findsOneWidget);
    // Still on the form.
    expect(find.text('Create Category'), findsWidgets);
  });

  testWidgets('duplicate names are rejected inline', (tester) async {
    await seedCategory('Electronics');

    await openCategoryPage(tester);
    await tester.tap(find.text('Add Category'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'electronics');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('A category with this name already exists.'),
      findsOneWidget,
    );
    expect(find.text('Create Category'), findsWidgets);
    expect(find.text('Electronics'), findsNothing);
  });
}
