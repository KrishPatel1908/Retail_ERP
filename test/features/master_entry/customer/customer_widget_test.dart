import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/features/master_entry/customer/data/repositories/customer_repository.dart';
import 'package:retail_erp/features/master_entry/customer/domain/entities/customer.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_viewport.dart';

void main() {
  setUp(resetTestDatabase);

  Future<void> openCustomerPage(WidgetTester tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.tap(find.text('Master Entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Customer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customer'));
    await tester.pumpAndSettle();
  }

  Future<void> openCreateCustomerForm(WidgetTester tester) async {
    await openCustomerPage(tester);
    await tester.tap(find.byKey(const ValueKey('add-customer-button')));
    await tester.pumpAndSettle();
  }

  Future<Customer> seedCustomer(
    String name, {
    String? mobile,
    String? gst,
    String? city,
  }) async {
    final repository = CustomerRepository();
    return repository.createCustomer(
      customerName: name,
      mobile: mobile,
      gstNumber: gst,
      city: city,
    );
  }

  Future<void> settleSearch(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('shows seeded customers in the table', (tester) async {
    useTallViewport(tester);
    await seedCustomer('Acme Traders', mobile: '9876543210');
    await seedCustomer('Beta Stores');

    await openCustomerPage(tester);

    expect(find.text('Acme Traders'), findsOneWidget);
    expect(find.text('Beta Stores'), findsOneWidget);
    expect(find.text('CUS00001'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(find.text('No customers yet'), findsNothing);
  });

  testWidgets('search filters customers while typing', (tester) async {
    useTallViewport(tester);
    await seedCustomer('NikeFootwear', city: 'Mumbai');
    await seedCustomer('AdidasSport', city: 'Pune');

    await openCustomerPage(tester);
    expect(find.text('NikeFootwear'), findsOneWidget);
    expect(find.text('AdidasSport'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nike');
    await settleSearch(tester);

    expect(find.text('NikeFootwear'), findsOneWidget);
    expect(find.text('AdidasSport'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await settleSearch(tester);

    expect(find.text('No customers found'), findsOneWidget);
  });

  testWidgets('creates a customer with auto code and shows it in the list', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateCustomerForm(tester);

    expect(find.text('Create Customer'), findsWidgets);

    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Acme Traders',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer-mobile')),
      '9876543210',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Customer created successfully.'), findsOneWidget);
    expect(find.text('Acme Traders'), findsOneWidget);
    expect(find.text('CUS00001'), findsOneWidget);
  });

  testWidgets('requires customer name and mobile', (tester) async {
    useTallViewport(tester);
    await openCreateCustomerForm(tester);

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Customer name is required.'), findsOneWidget);
    expect(find.text('Mobile number is required.'), findsOneWidget);
  });

  testWidgets(
    'validates the mobile number format and enforces 10-digit limit',
    (tester) async {
      useTallViewport(tester);
      await openCreateCustomerForm(tester);

      await tester.enterText(
        find.byKey(const ValueKey('customer-name')),
        'Acme',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-mobile')),
        '1234567890123', // Trying 13 digits
      );

      // Form should cap input to 10 digits
      final mobileField = tester.widget<TextField>(
        find.byKey(const ValueKey('customer-mobile')),
      );
      expect(mobileField.controller?.text.length, equals(10));

      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Enter a valid 10-digit mobile number.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'validates invalid email, GST, PAN, pincode and alternate mobile',
    (tester) async {
      useTallViewport(tester);
      await openCreateCustomerForm(tester);

      await tester.enterText(
        find.byKey(const ValueKey('customer-name')),
        'Valid Name',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-mobile')),
        '9876543210',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-alternate-mobile')),
        '123',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-email')),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-gst')),
        'INVALIDGST',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-pan')),
        'INVALIDPAN',
      );
      await tester.enterText(
        find.byKey(const ValueKey('customer-pincode')),
        '123',
      );

      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Enter a valid 10-digit mobile number.'),
        findsOneWidget,
      );
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(
        find.text('Enter a valid 15-character GST number.'),
        findsOneWidget,
      );
      expect(find.text('Enter a valid PAN (e.g. ABCDE1234F).'), findsOneWidget);
      expect(find.text('Enter a valid 6-digit pincode.'), findsOneWidget);
    },
  );

  testWidgets('focuses the first invalid field when Save validation fails', (
    tester,
  ) async {
    useTallViewport(tester);
    await openCreateCustomerForm(tester);

    // Save with customer name empty
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Check Customer Name is focused
    final nameField = tester.widget<TextField>(
      find.byKey(const ValueKey('customer-name')),
    );
    expect(nameField.focusNode?.hasFocus, isTrue);
  });

  testWidgets(
    'opens read-only customer view displaying complete customer details',
    (tester) async {
      useTallViewport(tester);
      final customer = await seedCustomer(
        'Acme View Test',
        mobile: '9876543210',
        gst: '27ABCDE1234F1Z5',
        city: 'Mumbai',
      );

      await openCustomerPage(tester);
      await tester.ensureVisible(
        find.byKey(ValueKey('view-customer-${customer.id}')),
      );
      await tester.tap(find.byKey(ValueKey('view-customer-${customer.id}')));
      await tester.pumpAndSettle();

      expect(find.text('Acme View Test'), findsWidgets);
      expect(
        find.text('Customer Code: ${customer.customerCode}'),
        findsOneWidget,
      );
      expect(find.text('Basic Info'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Financial Details'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(
        find.text('Customer Code: ${customer.customerCode}'),
        findsNothing,
      );
    },
  );

  testWidgets('rejects a duplicate GST number inline', (tester) async {
    useTallViewport(tester);
    await seedCustomer('First', gst: '27ABCDE1234F1Z5');

    await openCreateCustomerForm(tester);

    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Second',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer-mobile')),
      '9876543210',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer-gst')),
      '27abcde1234f1z5',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('A customer with this GST number already exists.'),
      findsOneWidget,
    );
    expect(find.text('Create Customer'), findsWidgets);
  });

  testWidgets('edit pre-fills the form and updates the record', (tester) async {
    useTallViewport(tester);
    final customer = await seedCustomer('SonyAudio', mobile: '9876543210');

    await openCustomerPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('edit-customer-${customer.id}')),
    );
    await tester.tap(find.byKey(ValueKey('edit-customer-${customer.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Customer'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Sony Electronics',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Customer updated successfully.'), findsOneWidget);
    expect(find.text('Sony Electronics'), findsOneWidget);
    expect(find.text('SonyAudio'), findsNothing);
  });

  testWidgets('delete asks for confirmation and removes the row', (
    tester,
  ) async {
    useTallViewport(tester);
    final customer = await seedCustomer('UniqueTestCustomer');

    await openCustomerPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-customer-${customer.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-customer-${customer.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete customer?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Customer deleted successfully.'), findsOneWidget);
    expect(find.text('UniqueTestCustomer'), findsNothing);
  });

  testWidgets('delete can be cancelled without removing the row', (
    tester,
  ) async {
    useTallViewport(tester);
    final customer = await seedCustomer('CancelTestCustomer');

    await openCustomerPage(tester);
    await tester.ensureVisible(
      find.byKey(ValueKey('delete-customer-${customer.id}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-customer-${customer.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('CancelTestCustomer'), findsOneWidget);
  });
}
