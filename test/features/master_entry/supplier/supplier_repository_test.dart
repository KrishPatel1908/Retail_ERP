import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/party/domain/party_enums.dart';
import 'package:retail_erp/features/master_entry/party/domain/party_query.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/domain/exceptions/supplier_exceptions.dart';

void main() {
  group('SupplierRepository', () {
    late AppDatabase database;
    late SupplierRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = SupplierRepository(database: database);
    });

    tearDown(() => database.close());

    Future<db.Supplier> insertSupplierRaw(
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
      return database
          .into(database.suppliers)
          .insertReturning(
            db.SuppliersCompanion.insert(
              supplierCode: code,
              supplierName: name,
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

    test('creates a supplier with a sequential auto-generated code', () async {
      final first = await repository.createSupplier(supplierName: 'Acme');
      final second = await repository.createSupplier(supplierName: 'Beta');

      expect(first.supplierCode, 'SUP00001');
      expect(second.supplierCode, 'SUP00002');
      expect(first.id, greaterThan(0));
    });

    test('stores supplier-specific fields', () async {
      final created = await repository.createSupplier(
        supplierName: 'Wholesale Ltd',
        contactPerson: 'Rajesh Kumar',
        paymentTerms: 'Net 30',
        openingBalance: 75000,
        balanceType: BalanceType.credit,
      );

      expect(created.contactPerson, 'Rajesh Kumar');
      expect(created.paymentTerms, 'Net 30');
      expect(created.openingBalance, 75000);
      expect(created.outstandingBalance, 75000);
      expect(created.balanceType, BalanceType.credit);
    });

    test('trims values and normalizes GST/email/PAN casing', () async {
      final created = await repository.createSupplier(
        supplierName: '  Acme Supplies  ',
        contactPerson: '  Jane Doe  ',
        gstNumber: '27aabcd1234f1z5',
        email: '  SUPPLY@acme.COM ',
        panNumber: 'abcde1234f',
      );

      expect(created.supplierName, 'Acme Supplies');
      expect(created.contactPerson, 'Jane Doe');
      expect(created.gstNumber, '27AABCD1234F1Z5');
      expect(created.email, 'supply@acme.com');
      expect(created.panNumber, 'ABCDE1234F');
    });

    test('fetchPage searches code, name, mobile, GST and city', () async {
      await repository.createSupplier(
        supplierName: 'Mega Supply',
        mobile: '9876543210',
        gstNumber: '27ABCDE1234F1Z5',
        city: 'Mumbai',
      );
      await repository.createSupplier(supplierName: 'Other Supply');

      expect((await repository.fetchPage(query: 'SUP00001')).totalCount, 1);
      expect((await repository.fetchPage(query: 'mega')).totalCount, 1);
      expect((await repository.fetchPage(query: '98765')).totalCount, 1);
      expect((await repository.fetchPage(query: '27ABCD')).totalCount, 1);
      expect((await repository.fetchPage(query: 'mumbai')).totalCount, 1);
      expect((await repository.fetchPage(query: 'zzz')).totalCount, 0);
    });

    test('fetchPage filters by status, city and state', () async {
      await insertSupplierRaw(
        'SUP-F1',
        'Active Mumbai',
        city: 'Mumbai',
        state: 'Maharashtra',
      );
      await insertSupplierRaw(
        'SUP-F2',
        'Inactive Pune',
        city: 'Pune',
        state: 'Maharashtra',
        isActive: false,
      );
      await insertSupplierRaw(
        'SUP-F3',
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
    });

    test('fetchPage filters by created date range', () async {
      await insertSupplierRaw(
        'SUP-D1',
        'January',
        createdAt: DateTime(2026, 1, 15),
      );
      await insertSupplierRaw(
        'SUP-D2',
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
      expect(january.items.single.supplierName, 'January');
    });

    test('fetchPage sorts server-side and paginates', () async {
      for (final name in ['Zebra', 'apple', 'Mango', 'banana', 'kiwi']) {
        await repository.createSupplier(supplierName: name);
      }

      final sorted = await repository.fetchPage(
        sort: PartySortColumn.name,
        sortAscending: true,
        pageSize: 50,
      );
      expect(sorted.items.map((s) => s.supplierName), [
        'apple',
        'banana',
        'kiwi',
        'Mango',
        'Zebra',
      ]);

      final firstPage = await repository.fetchPage(page: 1, pageSize: 2);
      expect(firstPage.items, hasLength(2));
      expect(firstPage.totalCount, 5);

      final lastPage = await repository.fetchPage(page: 3, pageSize: 2);
      expect(lastPage.items, hasLength(1));
    });

    test('rejects a duplicate GST number case-insensitively', () async {
      await repository.createSupplier(
        supplierName: 'First',
        gstNumber: '27ABCDE1234F1Z5',
      );

      await expectLater(
        repository.createSupplier(
          supplierName: 'Second',
          gstNumber: '27abcde1234f1z5',
        ),
        throwsA(
          isA<SupplierDuplicateException>().having(
            (e) => e.field,
            'field',
            SupplierDuplicateField.gstNumber,
          ),
        ),
      );
    });

    test('rejects a duplicate email case-insensitively', () async {
      await repository.createSupplier(
        supplierName: 'First',
        email: 'dupe@example.com',
      );

      await expectLater(
        repository.createSupplier(
          supplierName: 'Second',
          email: 'DUPE@example.com',
        ),
        throwsA(
          isA<SupplierDuplicateException>().having(
            (e) => e.field,
            'field',
            SupplierDuplicateField.email,
          ),
        ),
      );
    });

    test('updateSupplier updates fields and persists changes', () async {
      final created = await repository.createSupplier(
        supplierName: 'Old Name',
        city: 'Old City',
      );

      final updated = await repository.updateSupplier(
        created.id,
        supplierName: 'New Name',
        contactPerson: 'New Contact',
        paymentTerms: 'COD',
        city: 'New City',
      );

      expect(updated.supplierName, 'New Name');
      expect(updated.contactPerson, 'New Contact');
      expect(updated.paymentTerms, 'COD');
      expect(updated.city, 'New City');
      expect(updated.supplierCode, 'SUP00001');

      final reloaded = (await repository.fetchPage()).items.single;
      expect(reloaded.supplierName, 'New Name');
    });

    test(
      'updateSupplier rejects a GST collision with another supplier',
      () async {
        await repository.createSupplier(
          supplierName: 'First',
          gstNumber: '27ABCDE1234F1Z5',
        );
        final second = await repository.createSupplier(supplierName: 'Second');

        await expectLater(
          repository.updateSupplier(
            second.id,
            supplierName: 'Second',
            gstNumber: '27ABCDE1234F1Z5',
          ),
          throwsA(isA<SupplierDuplicateException>()),
        );
      },
    );

    test('updateSupplier keeps its own GST number when unchanged', () async {
      final first = await repository.createSupplier(
        supplierName: 'First',
        gstNumber: '27ABCDE1234F1Z5',
      );

      final updated = await repository.updateSupplier(
        first.id,
        supplierName: 'First Updated',
        gstNumber: '27ABCDE1234F1Z5',
      );

      expect(updated.supplierName, 'First Updated');
    });

    test(
      'updateSupplier throws SupplierNotFoundException for unknown ids',
      () async {
        await expectLater(
          repository.updateSupplier(9999, supplierName: 'Missing'),
          throwsA(isA<SupplierNotFoundException>()),
        );
      },
    );

    test('deleteSupplier removes the supplier', () async {
      final created = await repository.createSupplier(supplierName: 'Gone');

      await repository.deleteSupplier(created.id);

      expect((await repository.fetchPage()).totalCount, 0);
    });

    test(
      'creates supplier with credit limit, bank details and payment due date',
      () async {
        final dueDate = DateTime(2026, 10, 20);
        final created = await repository.createSupplier(
          supplierName: 'Bank Supplier',
          creditLimit: 5000000,
          paymentDueDate: dueDate,
          accountName: 'Beta Supplies',
          accountNumber: '9876543210',
          bankName: 'ICICI Bank',
          branchName: 'Andheri Branch',
          ifscCode: 'icic0004321',
        );

        expect(created.creditLimit, 5000000);
        expect(created.paymentDueDate, dueDate);
        expect(created.accountName, 'Beta Supplies');
        expect(created.accountNumber, '9876543210');
        expect(created.bankName, 'ICICI Bank');
        expect(created.branchName, 'Andheri Branch');
        expect(created.ifscCode, 'ICIC0004321');
      },
    );

    test('updateSupplier preserves original createdAt timestamp', () async {
      final initialCreated = DateTime(2025, 4, 1, 10, 0);
      final raw = await insertSupplierRaw(
        'SUP-OLD',
        'Old Supplier',
        createdAt: initialCreated,
      );

      final updated = await repository.updateSupplier(
        raw.id,
        supplierName: 'Updated Supplier',
      );

      expect(updated.createdAt, initialCreated);
      expect(updated.updatedAt.isAfter(initialCreated), isTrue);
    });

    test(
      'distinctCities and distinctStates return sorted unique values',
      () async {
        await insertSupplierRaw('SUP-C1', 'One', city: 'Mumbai', state: 'MH');
        await insertSupplierRaw('SUP-C2', 'Two', city: 'Pune', state: 'MH');
        await insertSupplierRaw('SUP-C3', 'Three', city: 'mumbai', state: 'KA');

        expect(await repository.distinctCities(), ['Mumbai', 'Pune']);
        expect(await repository.distinctStates(), ['KA', 'MH']);
      },
    );
  });
}
