import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openUomConversionPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('UOM Conversion'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UOM Conversion'));
    await tester.pumpAndSettle();
  }

  /// Opens the first picker that still shows the "Select a unit" hint
  /// (the From picker while both are empty, the To picker afterwards),
  /// optionally searches inside the dialog, and selects [unitName].
  Future<void> pickUnit(
    WidgetTester tester,
    String unitName, {
    String? search,
  }) async {
    final hint = find.text('Select a unit').first;
    await tester.ensureVisible(hint);
    await tester.tap(hint);
    await tester.pumpAndSettle();

    if (search != null) {
      final searchField = find.descendant(
        of: find.byType(AlertDialog).last,
        matching: find.byType(TextField),
      );
      await tester.enterText(searchField, search);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text(unitName).last);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('list page shows the seeded conversions', (tester) async {
    await openUomConversionPage(tester);

    // Breadcrumb + sidebar group label.
    expect(find.text('Master Entry'), findsNWidgets(2));
    // Sidebar item + page title + breadcrumb + status bar.
    expect(find.text('UOM Conversion'), findsNWidgets(4));
    expect(find.text('Add Conversion'), findsOneWidget);
    expect(find.text('Search conversions'), findsOneWidget);

    // Top rows of the from-unit-sorted seed (lazy list, keep to on-screen).
    expect(find.text('Bundle'), findsOneWidget);
    expect(find.text('Dozen'), findsOneWidget);
    expect(find.text('Conversion Factor'), findsOneWidget);
    expect(find.text('No conversions yet'), findsNothing);
  });

  testWidgets('creates a conversion through the searchable pickers', (
    tester,
  ) async {
    await openUomConversionPage(tester);
    await tester.tap(find.text('Add Conversion'));
    await tester.pumpAndSettle();

    expect(find.text('Create Conversion'), findsNWidgets(2));
    expect(find.text('From Unit'), findsOneWidget);
    expect(find.text('To Unit'), findsOneWidget);
    expect(find.text('Conversion Factor'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    await pickUnit(tester, 'Box');
    await pickUnit(tester, 'Packet', search: 'packet');

    final factorField = find.byType(TextField).first;
    await tester.enterText(factorField, '10');
    await save(tester);

    expect(find.text('Conversion created successfully.'), findsOneWidget);
    // Back on the list with the new row (sorted: Box sits near the top).
    expect(find.text('Box'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('validates missing selections and the conversion factor', (
    tester,
  ) async {
    await openUomConversionPage(tester);
    await tester.tap(find.text('Add Conversion'));
    await tester.pumpAndSettle();

    await save(tester);
    expect(find.text('Please select a From unit.'), findsOneWidget);
    expect(find.text('Please select a To unit.'), findsOneWidget);

    await pickUnit(tester, 'Box');
    await pickUnit(tester, 'Packet', search: 'packet');

    await tester.enterText(find.byType(TextField).first, '0');
    await save(tester);
    expect(
      find.text('Conversion factor must be greater than zero.'),
      findsOneWidget,
    );
  });

  testWidgets('rejects a conversion that already exists', (tester) async {
    await openUomConversionPage(tester);
    await tester.tap(find.text('Add Conversion'));
    await tester.pumpAndSettle();

    // Kilogram -> Gram is already seeded.
    await pickUnit(tester, 'Kilogram', search: 'kilogram');
    await pickUnit(tester, 'Gram', search: 'gram');

    await tester.enterText(find.byType(TextField).first, '1000');
    await save(tester);

    expect(
      find.text('A conversion between these units already exists.'),
      findsOneWidget,
    );
    expect(find.text('Create Conversion'), findsWidgets);
  });

  testWidgets('edit pre-fills the form and updates the factor', (tester) async {
    await openUomConversionPage(tester);

    // Seeded conversion id 1 is Dozen -> Piece.
    final editButton = find.byKey(const ValueKey('edit-conversion-1'));
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.text('Edit Conversion'), findsNWidgets(2));
    expect(find.text('Dozen (doz)'), findsOneWidget);
    expect(find.text('Piece (pc)'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '6');
    await save(tester);

    expect(find.text('Conversion updated successfully.'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    await openUomConversionPage(tester);

    // Seeded conversion id 3 is Bundle -> Piece (top row).
    final deleteButton = find.byKey(const ValueKey('delete-conversion-3'));
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Delete conversion?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Bundle'), findsNothing);
    expect(find.text('Conversion deleted successfully.'), findsOneWidget);
  });

  testWidgets('adds a new unit from the picker and selects it', (tester) async {
    // Tall viewport so the create-unit dialog and its dropdown menu fit.
    useTallViewport(tester);

    await openUomConversionPage(tester);
    await tester.tap(find.text('Add Conversion'));
    await tester.pumpAndSettle();

    // Use the "+ Add New Unit" action next to the From picker.
    await tester.tap(find.text('+ Add New Unit').first);
    await tester.pumpAndSettle();

    // The "Create Unit" dialog is now on top.
    final createDialog = find.byType(AlertDialog).last;
    final createFields = find.descendant(
      of: createDialog,
      matching: find.byType(TextField),
    );
    await tester.enterText(createFields.at(0), 'Tonne');
    await tester.enterText(createFields.at(1), 't');

    // The Measure In dropdown defaults to "Count".
    await tester.tap(
      find.descendant(of: createDialog, matching: find.text('Count')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(of: createDialog, matching: find.text('Save')),
    );
    await tester.pumpAndSettle();

    // Back on the conversion form: the new unit is auto-selected.
    expect(find.text('Tonne (t)'), findsOneWidget);

    // Finish the conversion: Tonne -> Gram.
    await pickUnit(tester, 'Gram', search: 'gram');
    await tester.enterText(find.byType(TextField).first, '1000');
    await save(tester);

    expect(find.text('Conversion created successfully.'), findsOneWidget);
    expect(find.text('Tonne'), findsOneWidget);
  });
}
