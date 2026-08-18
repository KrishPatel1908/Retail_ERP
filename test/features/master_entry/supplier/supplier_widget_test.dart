import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/domain/entities/supplier.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openSupplierPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Supplier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supplier'));
    await tester.pumpAndSettle();
  }

  Future<void> openCreateSupplierForm(WidgetTester tester) async {
    await openSupplierPage(tester);
    await tester.tap(find.byKey(const ValueKey('add-supplier-button')));
    await tester.pumpAndSettle();
  }

  Future<Supplier> seedSupplier(
    String name, {
    String? mobile,
    String? gst,
    String? city,
  }) async {
    final repository = SupplierRepository();
    return repository.createSupplier(
      supplierName: name,
      mobile: mobile,
      gstNumber: gst,
      city: city,
    );
  }

  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows seeded suppliers in the table', (tester) async {
    useTallViewport(tester);
    await seedSupplier('Acme Supplies', mobile: '9876543210');
    await seedSupplier('Beta Distribution');

    await openSupplierPage(tester);

    expect(find.text('Acme Supplies'), findsOneWidget);
    expect(find.text('Beta Distribution'), findsOneWidget);
    expect(find.text('SUP00001'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(find.text('No suppliers yet'), findsNothing);
  });

  testWidgets('search filters suppliers while typing', (tester) async {
    useTallViewport(tester);
    await seedSupplier('NikeWholesale', city: 'Mumbai');
    await seedSupplier('AdidasDistributor', city: 'Pune');

    await openSupplierPage(tester);
    expect(find.text('NikeWholesale'), findsOneWidget);
    expect(find.text('AdidasDistributor'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nike');
    await settleSearch(tester);

    expect(find.text('NikeWholesale'), findsOneWidget);
    expect(find.text('AdidasDistributor'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No suppliers found'), findsOneWidget);
  });

  testWidgets('creates a supplier with auto code and shows it in the list', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateSupplierForm(tester);

    expect(find.text('Create Supplier'), findsWidgets);

    await tester.enterText(
      find.byKey(const ValueKey('supplier-name')),
      'Acme Supplies',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-mobile')),
      '9876543210',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Supplier created successfully.'), findsOneWidget);
    expect(find.text('Acme Supplies'), findsOneWidget);
    expect(find.text('SUP00001'), findsOneWidget);
  });

  testWidgets('requires business name and mobile', (tester) async {
    useTallViewport(tester);
    await openCreateSupplierForm(tester);

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Business name is required.'), findsOneWidget);
    expect(find.text('Mobile number is required.'), findsOneWidget);
  });

  testWidgets('validates the mobile number format and enforces 10-digit limit', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateSupplierForm(tester);

    await tester.enterText(
      find.byKey(const ValueKey('supplier-name')),
      'Acme',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-mobile')),
      '1234567890123',
    );

    final mobileField = tester.widget<TextField>(
      find.byKey(const ValueKey('supplier-mobile')),
    );
    expect(mobileField.controller?.text.length, equals(10));

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Enter a valid 10-digit mobile number.'),
      findsOneWidget,
    );
  });

  testWidgets('validates invalid email, GST, PAN, pincode and alternate mobile', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateSupplierForm(tester);

    await tester.enterText(
      find.byKey(const ValueKey('supplier-name')),
      'Valid Supplier',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-mobile')),
      '9876543210',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-alternate-mobile')),
      '123',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-email')),
      'invalid-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-gst')),
      'INVALIDGST',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-pan')),
      'INVALIDPAN',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-pincode')),
      '123',
    );

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid 10-digit mobile number.'), findsOneWidget);
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Enter a valid 15-character GST number.'), findsOneWidget);
    expect(find.text('Enter a valid PAN (e.g. ABCDE1234F).'), findsOneWidget);
    expect(find.text('Enter a valid 6-digit pincode.'), findsOneWidget);
  });

  testWidgets('focuses the first invalid field when Save validation fails', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateSupplierForm(tester);

    // Save with business name empty
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final nameField = tester.widget<TextField>(
      find.byKey(const ValueKey('supplier-name')),
    );
    expect(nameField.focusNode?.hasFocus, isTrue);
  });

  testWidgets('opens read-only supplier view displaying complete supplier details', (
    tester,
  ) async {
    useTallViewport(tester);
    final supplier = await seedSupplier(
      'Acme Supplier View Test',
      mobile: '9876543210',
      gst: '27ABCDE1234F1Z5',
      city: 'Mumbai',
    );

    await openSupplierPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('view-supplier-${supplier.id}')),
    );
    await tester.tap(find.byKey(ValueKey('view-supplier-${supplier.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Acme Supplier View Test'), findsWidgets);
    expect(find.text('Supplier Code: ${supplier.supplierCode}'), findsOneWidget);
    expect(find.text('Basic Info'), findsOneWidget);
    expect(find.text('Contact Information'), findsOneWidget);
    expect(find.text('Financial Details'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Supplier Code: ${supplier.supplierCode}'), findsNothing);
  });

  testWidgets('rejects a duplicate GST number inline', (tester) async {
    useTallViewport(tester);
    await seedSupplier('First', gst: '27ABCDE1234F1Z5');

    await openCreateSupplierForm(tester);

    await tester.enterText(
      find.byKey(const ValueKey('supplier-name')),
      'Second',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-mobile')),
      '9876543210',
    );
    await tester.enterText(
      find.byKey(const ValueKey('supplier-gst')),
      '27abcde1234f1z5',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('A supplier with this GST number already exists.'),
      findsOneWidget,
    );
    expect(find.text('Create Supplier'), findsWidgets);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    useTallViewport(tester);
    final supplier = await seedSupplier('SonyDistributor', mobile: '9876543210');

    await openSupplierPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('edit-supplier-${supplier.id}')),
    );
    await tester.tap(find.byKey(ValueKey('edit-supplier-${supplier.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Supplier'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const ValueKey('supplier-name')),
      'Sony Wholesale',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Supplier updated successfully.'), findsOneWidget);
    expect(find.text('Sony Wholesale'), findsOneWidget);
    expect(find.text('SonyDistributor'), findsNothing);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    useTallViewport(tester);
    final supplier = await seedSupplier('UniqueTestSupplier');

    await openSupplierPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-supplier-${supplier.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-supplier-${supplier.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete supplier?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Supplier deleted successfully.'), findsOneWidget);
    expect(find.text('UniqueTestSupplier'), findsNothing);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    useTallViewport(tester);
    final supplier = await seedSupplier('CancelTestSupplier');

    await openSupplierPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-supplier-${supplier.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-supplier-${supplier.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('CancelTestSupplier'), findsOneWidget);
  });
}
