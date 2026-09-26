import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/brand/data/repositories/brand_repository.dart';
import 'package:retail_erp/features/master_entry/brand/domain/entities/brand.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openBrandPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Brand'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Brand'));
    await tester.pumpAndSettle();
  }

  Future<Brand> seedBrand(String name, {String? description}) async {
    final repository = BrandRepository();
    return repository.createBrand(name: name, description: description);
  }

  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows seeded brands in the table', (tester) async {
    await seedBrand('Apple', description: 'Tech');
    await seedBrand('Samsung');

    await openBrandPage(tester);

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Samsung'), findsWidgets); // May match seed or brand name
    expect(find.text('Tech'), findsOneWidget);
    expect(find.text('No brands yet'), findsNothing);
  });

  testWidgets('search filters results while typing', (tester) async {
    await seedBrand('NikeFootwear');
    await seedBrand('AdidasSport');

    await openBrandPage(tester);
    expect(find.text('NikeFootwear'), findsOneWidget);
    expect(find.text('AdidasSport'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nike');
    await settleSearch(tester);

    expect(find.text('NikeFootwear'), findsOneWidget);
    expect(find.text('AdidasSport'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No brands found'), findsOneWidget);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    final brand = await seedBrand('SonyAudio');

    await openBrandPage(tester);
    await tester.ensureVisible(find.byKey(ValueKey('edit-brand-${brand.id}')));
    await tester.tap(find.byKey(ValueKey('edit-brand-${brand.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Brand'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'SonyAudio'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Sony Electronics');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Sony Electronics'), findsOneWidget);
    expect(find.text('SonyAudio'), findsNothing);
    expect(find.text('Brand updated successfully.'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    final brand = await seedBrand('UniqueTestBrand');

    await openBrandPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-brand-${brand.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-brand-${brand.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete brand?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('UniqueTestBrand'), findsNothing);
    expect(find.text('Brand deleted successfully.'), findsOneWidget);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    final brand = await seedBrand('CancelTestBrand');

    await openBrandPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-brand-${brand.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-brand-${brand.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('CancelTestBrand'), findsOneWidget);
  });

  testWidgets('save requires a brand name', (tester) async {
    await openBrandPage(tester);
    await tester.tap(find.text('Add Brand'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Brand name is required.'), findsOneWidget);
    expect(find.text('Create Brand'), findsWidgets);
  });

  testWidgets('duplicate names are rejected inline', (tester) async {
    await seedBrand('DupBrand');

    await openBrandPage(tester);
    await tester.tap(find.text('Add Brand'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'dupbrand');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('A brand with this name already exists.'), findsOneWidget);
    expect(find.text('Create Brand'), findsWidgets);
  });
}
