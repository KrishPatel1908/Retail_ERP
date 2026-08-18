import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';

import 'helpers/test_database.dart';

void main() {
  // Every widget test starts with a fresh in-memory database so pages backed
  // by repositories render real state.
  setUp(resetTestDatabase);

  testWidgets('shell renders brand, sidebar and status bar', (tester) async {
    await tester.pumpWidget(const RetailErpApp());

    // Brand in the top bar.
    expect(find.text('Retail ERP'), findsOneWidget);
    // Sidebar top-level destinations.
    expect(find.text('Purchase'), findsOneWidget);
    expect(find.text('Sales (POS)'), findsOneWidget);
    // Status bar.
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('selecting a sidebar item updates the content area', (
    tester,
  ) async {
    await tester.pumpWidget(const RetailErpApp());

    await tester.tap(find.text('Purchase'));
    await tester.pumpAndSettle();

    // The title appears in the sidebar, the content area and the status bar.
    expect(find.text('Purchase'), findsNWidgets(3));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('page-title'))).data,
      'Purchase',
    );
  });

  testWidgets('master entry expands and a child page can be selected', (
    tester,
  ) async {
    await tester.pumpWidget(const RetailErpApp());

    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    expect(find.text('Product Master'), findsOneWidget);

    // The deepest child sits below the fold in the test viewport.
    await tester.ensureVisible(find.text('Product Master'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Product Master'));
    await tester.pumpAndSettle();

    // Sidebar + content area + status bar.
    expect(find.text('Product Master'), findsNWidgets(3));
  });

  testWidgets('sidebar can be collapsed and expanded', (tester) async {
    await tester.pumpWidget(const RetailErpApp());

    final toggle = find.byKey(const ValueKey('sidebar-toggle'));
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    // Collapsed: only icons remain, labels are hidden.
    expect(find.text('Purchase'), findsNothing);

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Purchase'), findsOneWidget);
  });

  group('Category module', () {
    Future<void> openCategoryPage(WidgetTester tester) async {
      await tester.pumpWidget(const RetailErpApp());
      await tester.tap(find.text('Master Entry'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Category'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
    }

    testWidgets('list page shows breadcrumb, title, search and add button', (
      tester,
    ) async {
      await openCategoryPage(tester);

      // Breadcrumb + sidebar group label.
      expect(find.text('Master Entry'), findsNWidgets(2));
      // Sidebar item + page title + breadcrumb + status bar.
      expect(find.text('Category'), findsNWidgets(4));
      expect(find.text('Add Category'), findsOneWidget);
      expect(find.text('Search categories'), findsOneWidget);
      expect(find.text('No categories yet'), findsOneWidget);
    });

    testWidgets('add category opens the create page with all fields', (
      tester,
    ) async {
      await openCategoryPage(tester);

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Breadcrumb + page title.
      expect(find.text('Create Category'), findsNWidgets(2));
      expect(find.text('Category Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel returns to the category list', (tester) async {
      await openCategoryPage(tester);
      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Create Category'), findsNothing);
      expect(find.text('No categories yet'), findsOneWidget);
    });

    testWidgets('save creates the category and returns to the list', (
      tester,
    ) async {
      await openCategoryPage(tester);
      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Electronics');
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Back on the list, showing the persisted category and a success note.
      expect(find.text('Create Category'), findsNothing);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('No categories yet'), findsNothing);
      expect(find.text('Category created successfully.'), findsOneWidget);
    });
  });

  group('Unit module', () {
    Future<void> openUnitPage(WidgetTester tester) async {
      await tester.pumpWidget(const RetailErpApp());
      await tester.tap(find.text('Master Entry'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Unit Master'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unit Master'));
      await tester.pumpAndSettle();
    }

    testWidgets('list page shows breadcrumb, title, search and add button', (
      tester,
    ) async {
      await openUnitPage(tester);

      // Breadcrumb + sidebar group label.
      expect(find.text('Master Entry'), findsNWidgets(2));
      // Sidebar item + page title + breadcrumb + status bar.
      expect(find.text('Unit Master'), findsNWidgets(4));
      expect(find.text('Add Unit'), findsOneWidget);
      expect(find.text('Search units'), findsOneWidget);
    });

    testWidgets('add unit opens the create page with all fields', (
      tester,
    ) async {
      await openUnitPage(tester);

      await tester.tap(find.text('Add Unit'));
      await tester.pumpAndSettle();

      // Breadcrumb + page title.
      expect(find.text('Create Unit'), findsNWidgets(2));
      expect(find.text('Unit Name'), findsOneWidget);
      expect(find.text('Unit Symbol'), findsOneWidget);
      expect(find.text('Measure In'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel returns to the unit list', (tester) async {
      await openUnitPage(tester);
      await tester.tap(find.text('Add Unit'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Create Unit'), findsNothing);
      expect(find.text('Unit Master'), findsWidgets);
    });

    testWidgets('save creates the unit and returns to the list', (
      tester,
    ) async {
      await openUnitPage(tester);
      await tester.tap(find.text('Add Unit'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Aardvark');
      await tester.enterText(find.byType(TextField).at(1), 'aa');
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Back on the list, showing the persisted unit and a success note.
      expect(find.text('Create Unit'), findsNothing);
      expect(find.text('Aardvark'), findsOneWidget);
      expect(find.text('Unit created successfully.'), findsOneWidget);
    });
  });

  group('UOM Conversion module', () {
    Future<void> openUomConversionPage(WidgetTester tester) async {
      await tester.pumpWidget(const RetailErpApp());
      await tester.tap(find.text('Master Entry'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('UOM Conversion'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('UOM Conversion'));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'list page shows breadcrumb, title, search and add button',
      (tester) async {
        await openUomConversionPage(tester);

        // Breadcrumb + sidebar group label.
        expect(find.text('Master Entry'), findsNWidgets(2));
        // Sidebar item + page title + breadcrumb + status bar.
        expect(find.text('UOM Conversion'), findsNWidgets(4));
        expect(find.text('Add Conversion'), findsOneWidget);
        expect(find.text('Search conversions'), findsOneWidget);
      },
    );

    testWidgets('add conversion opens the create page with all fields', (
      tester,
    ) async {
      await openUomConversionPage(tester);

      await tester.tap(find.text('Add Conversion'));
      await tester.pumpAndSettle();

      // Breadcrumb + page title.
      expect(find.text('Create Conversion'), findsNWidgets(2));
      expect(find.text('From Unit'), findsOneWidget);
      expect(find.text('To Unit'), findsOneWidget);
      expect(find.text('Conversion Factor'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel returns to the conversion list', (tester) async {
      await openUomConversionPage(tester);
      await tester.tap(find.text('Add Conversion'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Create Conversion'), findsNothing);
      expect(find.text('UOM Conversion'), findsWidgets);
    });
  });
}