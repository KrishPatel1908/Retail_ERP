import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/tax_category/domain/entities/tax_category.dart';
import 'package:retail_erp/features/master_entry/tax_category/domain/entities/tax_category_component.dart';
import 'package:retail_erp/features/master_entry/tax_category/presentation/pages/create_tax_category_page.dart';
import 'package:retail_erp/features/master_entry/tax_category/presentation/pages/tax_category_list_page.dart';

void main() {
  setUp(() async {
    await DatabaseProvider.instance.initialize(
      connection: NativeDatabase.memory(),
    );
  });

  tearDown(() async {
    await DatabaseProvider.instance.close();
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('TaxCategoryListPage Widget Tests', () {
    testWidgets('renders header and add button', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        wrapWithMaterial(
          TaxCategoryListPage(
            onAddTaxCategory: () {},
            onEditTaxCategory: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Tax Category Master'), findsOneWidget);
      expect(find.text('Add Tax Category'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search field
    });

    testWidgets('triggers onAddTaxCategory callback when clicking Add Tax Category', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool added = false;
      await tester.pumpWidget(
        wrapWithMaterial(
          TaxCategoryListPage(
            onAddTaxCategory: () => added = true,
            onEditTaxCategory: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Tax Category'));
      await tester.pumpAndSettle();

      expect(added, isTrue);
    });
  });

  group('CreateTaxCategoryPage Widget Tests', () {
    testWidgets('renders Create Tax Category form fields', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        wrapWithMaterial(
          CreateTaxCategoryPage(
            onSave: () {},
            onCancel: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Tax Category Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Tax Components *'), findsOneWidget);
      expect(find.text('Add Component'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('shows validation error when tax category name is empty', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        wrapWithMaterial(
          CreateTaxCategoryPage(
            onSave: () {},
            onCancel: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      final saveBtn = find.text('Save');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Tax Category Name is required.'), findsOneWidget);
    });

    testWidgets('pre-fills data when editing existing Tax Category', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final category = TaxCategory(
        id: 1,
        taxCategoryName: 'GST 18%',
        description: 'Electronics tax',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        components: const [
          TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 9.0),
          TaxCategoryComponent(taxTypeId: 3, taxTypeName: 'SGST', percentage: 9.0),
        ],
      );

      await tester.pumpWidget(
        wrapWithMaterial(
          CreateTaxCategoryPage(
            onSave: () {},
            onCancel: () {},
            category: category,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('GST 18%'), findsWidgets);
      expect(find.text('Electronics tax'), findsOneWidget);
      expect(find.text('Total Tax: 18%'), findsOneWidget);
    });

    testWidgets('triggers onCancel when Cancel button is pressed', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool cancelled = false;
      await tester.pumpWidget(
        wrapWithMaterial(
          CreateTaxCategoryPage(
            onSave: () {},
            onCancel: () => cancelled = true,
          ),
        ),
      );

      await tester.pumpAndSettle();
      final cancelBtn = find.text('Cancel');
      await tester.ensureVisible(cancelBtn);
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
    });
  });
}
