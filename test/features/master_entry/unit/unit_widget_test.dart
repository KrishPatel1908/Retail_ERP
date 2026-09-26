import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';
import 'package:retail_erp/features/master_entry/unit/domain/entities/unit.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openUnitPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Unit Master'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unit Master'));
    await tester.pumpAndSettle();
  }

  Future<Unit> seedUnit(String name, {String symbol = 'xx'}) async {
    final repository = UnitRepository();
    return repository.createUnit(
      name: name,
      symbol: symbol,
      family: UnitType.count.dbValue,
    );
  }

  /// Advances fake time past the search debounce, then settles the load.
  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the seeded reference units and the new columns', (
    tester,
  ) async {
    await openUnitPage(tester);

    // Seeded units that sit near the top of the name-sorted list (the table
    // lazily builds rows, so only assert rows that are definitely on screen).
    expect(find.text('Bag'), findsOneWidget);
    expect(find.text('Bottle'), findsOneWidget);
    expect(find.text('Box'), findsOneWidget);
    // The final column set: no Unit Code / Base Unit / Status / Created Date.
    expect(find.text('Unit Code'), findsNothing);
    expect(find.text('Base Unit'), findsNothing);
    expect(find.text('Status'), findsNothing);
    expect(find.text('Created Date'), findsNothing);
    expect(find.text('Measure In'), findsOneWidget);
    expect(find.text('No units yet'), findsNothing);
  });

  testWidgets('search filters results while typing (name and symbol)', (
    tester,
  ) async {
    await openUnitPage(tester);
    expect(find.text('Box'), findsOneWidget);

    // "kg" matches the symbol of Kilogram, not its name.
    await tester.enterText(find.byType(TextField), 'kg');
    await settleSearch(tester);

    expect(find.text('Kilogram'), findsOneWidget);
    expect(find.text('Piece'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No units found'), findsOneWidget);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    final unit = await seedUnit('Aardvark', symbol: 'aa');

    await openUnitPage(tester);
    await tester.ensureVisible(find.byKey(ValueKey('edit-unit-${unit.id}')));
    await tester.tap(find.byKey(ValueKey('edit-unit-${unit.id}')));
    await tester.pumpAndSettle();

    // Breadcrumb + title, pre-filled name field.
    expect(find.text('Edit Unit'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Aardvark'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Aardvark Two');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Aardvark Two'), findsOneWidget);
    expect(find.text('Aardvark'), findsNothing);
    expect(find.text('Unit updated successfully.'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    final unit = await seedUnit('Aardvark');

    await openUnitPage(tester);
    await tester.ensureVisible(find.byKey(ValueKey('delete-unit-${unit.id}')));
    await tester.tap(find.byKey(ValueKey('delete-unit-${unit.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete unit?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Aardvark'), findsNothing);
    expect(find.text('Unit deleted successfully.'), findsOneWidget);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    final unit = await seedUnit('Aardvark');

    await openUnitPage(tester);
    await tester.ensureVisible(find.byKey(ValueKey('delete-unit-${unit.id}')));
    await tester.tap(find.byKey(ValueKey('delete-unit-${unit.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Aardvark'), findsOneWidget);
  });

  testWidgets('save requires a unit name and symbol', (tester) async {
    await openUnitPage(tester);
    await tester.tap(find.text('Add Unit'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Unit name is required.'), findsOneWidget);
    expect(find.text('Unit symbol is required.'), findsOneWidget);
    // Still on the form.
    expect(find.text('Create Unit'), findsWidgets);
  });

  testWidgets('duplicate names are rejected inline', (tester) async {
    await seedUnit('Aardvark');

    await openUnitPage(tester);
    await tester.tap(find.text('Add Unit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'aardvark');
    await tester.enterText(find.byType(TextField).at(1), 'zz');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('A unit with this name already exists.'), findsOneWidget);
    expect(find.text('Create Unit'), findsWidgets);
  });

  testWidgets('creates a unit with a measure and description', (tester) async {
    // Tall viewport so the measure dropdown menu fully fits on screen.
    useTallViewport(tester);

    await openUnitPage(tester);
    await tester.tap(find.text('Add Unit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Kilowatt Hour');
    await tester.enterText(find.byType(TextField).at(1), 'kwh');

    // Pick a measure from the dropdown (it defaults to "Count").
    await tester.ensureVisible(find.text('Count'));
    await tester.tap(find.text('Count'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Time').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).at(2),
      'Used for energy metering',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Kilowatt Hour'), findsOneWidget);
    expect(find.text('Unit created successfully.'), findsOneWidget);

    final saved = (await UnitRepository().getAllUnits()).firstWhere(
      (u) => u.unitName == 'Kilowatt Hour',
    );
    expect(saved.unitFamily, UnitType.time.dbValue);
    expect(saved.description, 'Used for energy metering');
  });
}
