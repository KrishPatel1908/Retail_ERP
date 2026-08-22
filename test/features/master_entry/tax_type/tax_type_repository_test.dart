import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/tax_type/data/repositories/tax_type_repository.dart';
import 'package:retail_erp/features/master_entry/tax_type/domain/exceptions/tax_type_exceptions.dart';

void main() {
  group('TaxTypeRepository', () {
    late AppDatabase database;
    late TaxTypeRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = TaxTypeRepository(database: database);
    });

    tearDown(() => database.close());

    test('creates a tax type', () async {
      final created = await repository.createTaxType(
        name: 'VAT',
        description: 'Value Added Tax',
      );

      expect(created.id, greaterThan(0));
      expect(created.taxTypeName, 'VAT');
      expect(created.description, 'Value Added Tax');
    });

    test('trims whitespace from name and description', () async {
      final created = await repository.createTaxType(
        name: '  Custom Tax  ',
        description: '  Tax description  ',
      );

      expect(created.taxTypeName, 'Custom Tax');
      expect(created.description, 'Tax description');

      final withoutDescription = await repository.createTaxType(
        name: 'Surcharge',
        description: '   ',
      );
      expect(withoutDescription.description, isNull);
    });

    test('getAllTaxTypes returns tax types ordered by name', () async {
      await repository.createTaxType(name: 'Z_Tax');
      await repository.createTaxType(name: 'a_Tax');
      await repository.createTaxType(name: 'B_Tax');

      final rows = await repository.getAllTaxTypes();
      final customNames = rows
          .where((t) => ['Z_Tax', 'a_Tax', 'B_Tax'].contains(t.taxTypeName))
          .map((t) => t.taxTypeName)
          .toList();
      expect(customNames, ['a_Tax', 'B_Tax', 'Z_Tax']);
    });

    test('updateTaxType updates fields and persists the new values', () async {
      final created = await repository.createTaxType(
        name: 'State Tax',
        description: 'State level tax',
      );

      final updated = await repository.updateTaxType(
        created.id,
        name: 'State Sales Tax',
        description: 'Updated description',
      );

      expect(updated.taxTypeName, 'State Sales Tax');
      expect(updated.description, 'Updated description');

      final reloaded = await repository.getAllTaxTypes();
      expect(
        reloaded.any((t) => t.taxTypeName == 'State Sales Tax'),
        isTrue,
      );
    });

    test(
      'updateTaxType throws TaxTypeNotFoundException for unknown ids',
      () async {
        await expectLater(
          repository.updateTaxType(9999, name: 'Missing'),
          throwsA(isA<TaxTypeNotFoundException>()),
        );
      },
    );

    test('deleteTaxType removes the tax type', () async {
      final created = await repository.createTaxType(name: 'Temp Tax');
      final initialCount = (await repository.getAllTaxTypes()).length;

      await repository.deleteTaxType(created.id);

      final remaining = await repository.getAllTaxTypes();
      expect(remaining.length, initialCount - 1);
    });

    test(
      'deleteTaxType rejects tax types referenced by products',
      () async {
        final taxType = await repository.createTaxType(name: 'Special GST');

        final categories = await database.select(database.categories).get();
        final units = await database.select(database.units).get();
        final brands = await database.select(database.brands).get();

        final categoryId = categories.isNotEmpty
            ? categories.first.id
            : await database.into(database.categories).insert(
                db.CategoriesCompanion.insert(
                  categoryCode: 'CAT-1',
                  categoryName: 'Tech',
                ),
              );

        final unitId = units.first.id;
        final brandId = brands.first.id;

        await database.into(database.products).insert(
          db.ProductsCompanion.insert(
          productCode: 'P-200',
          productName: 'Taxed Product',
          categoryId: Value(categoryId),
          brandId: Value(brandId),
          unitId: unitId,
            taxTypeId: Value(taxType.id),
          ),
        );

        await expectLater(
          repository.deleteTaxType(taxType.id),
          throwsA(isA<TaxTypeInUseException>()),
        );
      },
    );

    test(
      'deleteTaxType rejects tax types referenced by tax category rates',
      () async {
        final taxType = await repository.createTaxType(name: 'Rate Tax');
        final taxCategories =
            await database.select(database.taxCategories).get();
        final taxCatId = taxCategories.first.id;

        await database.into(database.taxCategoryRates).insert(
          db.TaxCategoryRatesCompanion.insert(
            taxCategoryId: taxCatId,
            taxTypeId: taxType.id,
            ratePercent: 18,
          ),
        );

        await expectLater(
          repository.deleteTaxType(taxType.id),
          throwsA(isA<TaxTypeInUseException>()),
        );
      },
    );

    test('searchTaxTypes filters case-insensitively by name or description', () async {
      await repository.createTaxType(name: 'Luxury Tax', description: 'On cars');
      await repository.createTaxType(name: 'Service Tax', description: 'On services');

      expect(
        (await repository.searchTaxTypes('lux')).map((t) => t.taxTypeName),
        ['Luxury Tax'],
      );
      expect(
        (await repository.searchTaxTypes('services')).map((t) => t.taxTypeName),
        ['Service Tax'],
      );
      expect(await repository.searchTaxTypes('zzz'), isEmpty);
    });

    test('existsByName is case-insensitive and honours excludeId', () async {
      final taxType = await repository.createTaxType(name: 'CGST_Custom');

      expect(await repository.existsByName('CGST_CUSTOM'), isTrue);
      expect(await repository.existsByName('cgst_custom'), isTrue);
      expect(await repository.existsByName('SGST_Custom'), isFalse);
      expect(await repository.existsByName('CGST_Custom', excludeId: taxType.id), isFalse);
    });

    test('createTaxType rejects duplicate names', () async {
      await repository.createTaxType(name: 'IGST_Custom');

      await expectLater(
        repository.createTaxType(name: 'igst_custom'),
        throwsA(
          isA<TaxTypeAlreadyExistsException>().having(
            (e) => e.message,
            'message',
            contains('igst_custom'),
          ),
        ),
      );
    });

    test(
      'updateTaxType rejects a name that collides with another tax type',
      () async {
        final first = await repository.createTaxType(name: 'Tax_A');
        await repository.createTaxType(name: 'Tax_B');

        await expectLater(
          repository.updateTaxType(first.id, name: 'TAX_B'),
          throwsA(isA<TaxTypeAlreadyExistsException>()),
        );
      },
    );

    test('persists data across restart (file database)', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_tax_type_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      final firstSession = AppDatabase(NativeDatabase(file));
      await firstSession.customSelect('SELECT 1').get();
      await TaxTypeRepository(
        database: firstSession,
      ).createTaxType(name: 'Persisted Tax');
      await firstSession.close();

      final secondSession = AppDatabase(NativeDatabase(file));
      await secondSession.customSelect('SELECT 1').get();
      final rows = await TaxTypeRepository(
        database: secondSession,
      ).getAllTaxTypes();
      expect(rows.any((t) => t.taxTypeName == 'Persisted Tax'), isTrue);
      await secondSession.close();
    });
  });
}
