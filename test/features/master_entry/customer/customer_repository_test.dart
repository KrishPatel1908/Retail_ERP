import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/customer/data/repositories/customer_repository.dart';
import 'package:retail_erp/features/master_entry/customer/domain/exceptions/customer_exceptions.dart';
import 'package:retail_erp/features/master_entry/party/domain/party_enums.dart';
import 'package:retail_erp/features/master_entry/party/domain/party_query.dart';

void main() {
  group('CustomerRepository', () {
    late AppDatabase database;
    late CustomerRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = CustomerRepository(database: database);
    });

    tearDown(() => database.close());

    Future<db.Customer> insertCustomerRaw(
      String code,
      String name, {
      String? gst,
      String? email,
      String? city,
      String? state,
      DateTime? createdAt,
      bool isActive = true,
      int openingBalance = 0,
    }) {
      return database.into(database.customers).insertReturning(
        db.CustomersCompanion.insert(
          customerCode: code,
          customerName: name,
          gstNumber: Value(gst),
          email: Value(email),
          city: Value(city),
          state: Value(state),
          openingBalance: Value(openingBalance),
          isActive: Value(isActive),
          createdAt: Value(createdAt ?? DateTime(2026, 1, 1, 12)),
          updatedAt: Value(createdAt ?? DateTime(2026, 1, 1, 12)),
        ),
      );
    }

    test('creates a customer with a sequential auto-generated code', () async {
      final first = await repository.createCustomer(customerName: 'Acme');
      final second = await repository.createCustomer(customerName: 'Beta');

      expect(first.customerCode, 'CUS00001');
      expect(second.customerCode, 'CUS00002');
      expect(first.id, greaterThan(0));
    });

    test('trims values and normalizes GST/email/PAN casing', () async {
      final created = await repository.createCustomer(
        customerName: '  Acme Traders  ',
        mobile: ' 9876543210 ',
        gstNumber: '27aabcd1234f1z5',
        email: '  CONTACT@acme.COM ',
        panNumber: 'abcde1234f',
        notes: '   ',
      );

      expect(created.customerName, 'Acme Traders');
      expect(created.mobile, '9876543210');
      expect(created.gstNumber, '27AABCD1234F1Z5');
      expect(created.email, 'contact@acme.com');
      expect(created.panNumber, 'ABCDE1234F');
      expect(created.notes, isNull);
    });

    test('stores balances in paise and initialises outstanding balance', () async {
      final created = await repository.createCustomer(
        customerName: 'Balance Co',
        openingBalance: 500000, // ₹5,000
        creditLimit: 1000000, // ₹10,000
        balanceType: BalanceType.credit,
      );

      expect(created.openingBalance, 500000);
      expect(created.creditLimit, 1000000);
      expect(created.outstandingBalance, 500000);
      expect(created.balanceType, BalanceType.credit);
    });

    test('fetchPage returns every row with the total count', () async {
      await insertCustomerRaw('CUS-X1', 'Alpha', city: 'Mumbai');
      await insertCustomerRaw('CUS-X2', 'Beta', city: 'Pune');

      final page = await repository.fetchPage();

      expect(page.totalCount, 2);
      expect(page.items.map((c) => c.customerName), ['Alpha', 'Beta']);
    });

    test('fetchPage searches code, name, mobile, GST and city', () async {
      await repository.createCustomer(
        customerName: 'Mega Store',
        mobile: '9876543210',
        gstNumber: '27ABCDE1234F1Z5',
        city: 'Mumbai',
      );
      await repository.createCustomer(customerName: 'Other Shop');

      expect((await repository.fetchPage(query: 'CUS00001')).totalCount, 1);
      expect((await repository.fetchPage(query: 'mega')).totalCount, 1);
      expect((await repository.fetchPage(query: '98765')).totalCount, 1);
      expect((await repository.fetchPage(query: '27ABCD')).totalCount, 1);
      expect((await repository.fetchPage(query: 'mumbai')).totalCount, 1);
      expect((await repository.fetchPage(query: 'zzz')).totalCount, 0);
    });

    test('fetchPage filters by status, city and state', () async {
      await insertCustomerRaw(
        'CUS-F1',
        'Active Mumbai',
        city: 'Mumbai',
        state: 'Maharashtra',
      );
      await insertCustomerRaw(
        'CUS-F2',
        'Inactive Pune',
        city: 'Pune',
        state: 'Maharashtra',
        isActive: false,
      );
      await insertCustomerRaw(
        'CUS-F3',
        'Active Delhi',
        city: 'Delhi',
        state: 'Delhi',
      );

      expect(
        (await repository.fetchPage(
          filters: const PartyFilters(isActive: true),
        )).totalCount,
        2,
      );
      expect(
        (await repository.fetchPage(
          filters: const PartyFilters(city: 'Pune'),
        )).totalCount,
        1,
      );
      expect(
        (await repository.fetchPage(
          filters: const PartyFilters(state: 'Maharashtra'),
        )).totalCount,
        2,
      );
      expect(
        (await repository.fetchPage(
          filters: PartyFilters(isActive: false, city: 'Pune'),
        )).totalCount,
        1,
      );
    });

    test('fetchPage filters by created date range', () async {
      await insertCustomerRaw(
        'CUS-D1',
        'January',
        createdAt: DateTime(2026, 1, 15),
      );
      await insertCustomerRaw(
        'CUS-D2',
        'March',
        createdAt: DateTime(2026, 3, 10),
      );

      final january = await repository.fetchPage(
        filters: PartyFilters(
          createdFrom: DateTime(2026, 1, 1),
          createdTo: DateTime(2026, 1, 31),
        ),
      );
      expect(january.totalCount, 1);
      expect(january.items.single.customerName, 'January');

      final all2026 = await repository.fetchPage(
        filters: PartyFilters(
          createdFrom: DateTime(2026, 1, 1),
          createdTo: DateTime(2026, 12, 31),
        ),
      );
      expect(all2026.totalCount, 2);
    });

    test('fetchPage sorts server-side and paginates', () async {
      for (final name in ['Zebra', 'apple', 'Mango', 'banana', 'kiwi']) {
        await repository.createCustomer(customerName: name);
      }

      final sorted = await repository.fetchPage(
        sort: PartySortColumn.name,
        sortAscending: true,
        pageSize: 50,
      );
      expect(
        sorted.items.map((c) => c.customerName),
        ['apple', 'banana', 'kiwi', 'Mango', 'Zebra'],
      );

      final firstPage = await repository.fetchPage(page: 1, pageSize: 2);
      expect(firstPage.items, hasLength(2));
      expect(firstPage.totalCount, 5);

      final lastPage = await repository.fetchPage(page: 3, pageSize: 2);
      expect(lastPage.items, hasLength(1));
    });

    test('rejects a duplicate GST number case-insensitively', () async {
      await repository.createCustomer(
        customerName: 'First',
        gstNumber: '27ABCDE1234F1Z5',
      );

      await expectLater(
        repository.createCustomer(
          customerName: 'Second',
          gstNumber: '27abcde1234f1z5',
        ),
        throwsA(
          isA<CustomerDuplicateException>().having(
            (e) => e.field,
            'field',
            CustomerDuplicateField.gstNumber,
          ),
        ),
      );
    });

    test('rejects a duplicate email case-insensitively', () async {
      await repository.createCustomer(
        customerName: 'First',
        email: 'dupe@example.com',
      );

      await expectLater(
        repository.createCustomer(
          customerName: 'Second',
          email: 'DUPE@example.com',
        ),
        throwsA(
          isA<CustomerDuplicateException>().having(
            (e) => e.field,
            'field',
            CustomerDuplicateField.email,
          ),
        ),
      );
    });

    test('updateCustomer updates fields and persists changes', () async {
      final created = await repository.createCustomer(
        customerName: 'Old Name',
        city: 'Old City',
      );

      final updated = await repository.updateCustomer(
        created.id,
        customerName: 'New Name',
        mobile: '9876543210',
        city: 'New City',
        openingBalance: 25000,
      );

      expect(updated.customerName, 'New Name');
      expect(updated.city, 'New City');
      expect(updated.mobile, '9876543210');
      expect(updated.openingBalance, 25000);
      expect(updated.customerCode, 'CUS00001');

      final reloaded = (await repository.fetchPage()).items.single;
      expect(reloaded.customerName, 'New Name');
    });

    test('updateCustomer rejects a GST collision with another customer', () async {
      await repository.createCustomer(
        customerName: 'First',
        gstNumber: '27ABCDE1234F1Z5',
      );
      final second = await repository.createCustomer(customerName: 'Second');

      await expectLater(
        repository.updateCustomer(
          second.id,
          customerName: 'Second',
          gstNumber: '27ABCDE1234F1Z5',
        ),
        throwsA(isA<CustomerDuplicateException>()),
      );
    });

    test('updateCustomer keeps its own GST number when unchanged', () async {
      final first = await repository.createCustomer(
        customerName: 'First',
        gstNumber: '27ABCDE1234F1Z5',
      );

      final updated = await repository.updateCustomer(
        first.id,
        customerName: 'First Updated',
        gstNumber: '27ABCDE1234F1Z5',
      );

      expect(updated.customerName, 'First Updated');
    });

    test('updateCustomer throws CustomerNotFoundException for unknown ids', () async {
      await expectLater(
        repository.updateCustomer(9999, customerName: 'Missing'),
        throwsA(isA<CustomerNotFoundException>()),
      );
    });

    test('deleteCustomer removes the customer', () async {
      final created = await repository.createCustomer(customerName: 'Gone');

      await repository.deleteCustomer(created.id);

      expect((await repository.fetchPage()).totalCount, 0);
    });

    test('creates customer with bank fields and payment due date', () async {
      final dueDate = DateTime(2026, 9, 15);
      final created = await repository.createCustomer(
        customerName: 'Bank Customer',
        paymentDueDate: dueDate,
        accountName: 'Acme Traders',
        accountNumber: '1234567890',
        bankName: 'HDFC Bank',
        branchName: 'Main Branch',
        ifscCode: 'hdfc0001234',
      );

      expect(created.paymentDueDate, dueDate);
      expect(created.accountName, 'Acme Traders');
      expect(created.accountNumber, '1234567890');
      expect(created.bankName, 'HDFC Bank');
      expect(created.branchName, 'Main Branch');
      expect(created.ifscCode, 'HDFC0001234');
    });

    test('updateCustomer preserves original createdAt timestamp', () async {
      final initialCreated = DateTime(2025, 5, 10, 8, 30);
      final raw = await insertCustomerRaw(
        'CUS-OLD',
        'Old Entry',
        createdAt: initialCreated,
      );

      final updated = await repository.updateCustomer(
        raw.id,
        customerName: 'Updated Entry',
      );

      expect(updated.createdAt, initialCreated);
      expect(updated.updatedAt.isAfter(initialCreated), isTrue);
    });

    test('distinctCities and distinctStates return sorted unique values', () async {
      await insertCustomerRaw('CUS-C1', 'One', city: 'Mumbai', state: 'MH');
      await insertCustomerRaw('CUS-C2', 'Two', city: 'Pune', state: 'MH');
      await insertCustomerRaw('CUS-C3', 'Three', city: 'mumbai', state: 'KA');

      expect(await repository.distinctCities(), ['Mumbai', 'Pune']);
      expect(await repository.distinctStates(), ['KA', 'MH']);
    });
  });
}
