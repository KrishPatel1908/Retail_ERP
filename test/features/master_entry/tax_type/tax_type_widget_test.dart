import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/tax_type/data/repositories/tax_type_repository.dart';
import 'package:retail_erp/features/master_entry/tax_type/domain/entities/tax_type.dart';
import 'package:retail_erp/features/shell/widgets/sidebar_item.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openTaxTypePage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    final itemFinder = find.widgetWithText(SidebarItem, 'Tax Type');
    await tester.ensureVisible(itemFinder);
    await tester.pumpAndSettle();
    await tester.tap(itemFinder);
    await tester.pumpAndSettle();
  }

  Future<TaxType> seedTaxType(String name, {String? description}) async {
    final repository = TaxTypeRepository();
    return repository.createTaxType(name: name, description: description);
  }

  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows seeded tax types in the table', (tester) async {
    await seedTaxType('AAA_CustomVAT', description: 'Value Added Tax');

    await openTaxTypePage(tester);

    expect(find.text('AAA_CustomVAT'), findsOneWidget);
    expect(find.text('Value Added Tax'), findsOneWidget);
    expect(find.text('No tax types yet'), findsNothing);
  });

  testWidgets('search filters results while typing', (tester) async {
    await seedTaxType('AAA_UniqueTaxOne');
    await seedTaxType('AAA_UniqueTaxTwo');

    await openTaxTypePage(tester);
    expect(find.text('AAA_UniqueTaxOne'), findsOneWidget);
    expect(find.text('AAA_UniqueTaxTwo'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'one');
    await settleSearch(tester);

    expect(find.text('AAA_UniqueTaxOne'), findsOneWidget);
    expect(find.text('AAA_UniqueTaxTwo'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No tax types found'), findsOneWidget);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    final taxType = await seedTaxType('AAA_OldTaxName');

    await openTaxTypePage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('edit-tax-type-${taxType.id}')),
    );
    await tester.tap(find.byKey(ValueKey('edit-tax-type-${taxType.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Tax Type'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'AAA_OldTaxName'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'AAA_NewTaxName',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('AAA_NewTaxName'), findsOneWidget);
    expect(find.text('AAA_OldTaxName'), findsNothing);
    expect(find.text('Tax type updated successfully.'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    final taxType = await seedTaxType('AAA_TaxToDelete');

    await openTaxTypePage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-tax-type-${taxType.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-tax-type-${taxType.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete tax type?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('AAA_TaxToDelete'), findsNothing);
    expect(find.text('Tax type deleted successfully.'), findsOneWidget);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    final taxType = await seedTaxType('AAA_TaxToCancel');

    await openTaxTypePage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-tax-type-${taxType.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-tax-type-${taxType.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('AAA_TaxToCancel'), findsOneWidget);
  });

  testWidgets('save requires a tax type name', (tester) async {
    await openTaxTypePage(tester);
    await tester.tap(find.text('Add Tax Type'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Tax type name is required.'), findsOneWidget);
    expect(find.text('Create Tax Type'), findsWidgets);
  });

  testWidgets('duplicate names are rejected inline', (tester) async {
    await seedTaxType('AAA_DupTaxName');

    await openTaxTypePage(tester);
    await tester.tap(find.text('Add Tax Type'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'aaa_duptaxname');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('A tax type with this name already exists.'),
      findsOneWidget,
    );
    expect(find.text('Create Tax Type'), findsWidgets);
  });
}
