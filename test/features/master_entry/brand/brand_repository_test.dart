import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/brand/data/repositories/brand_repository.dart';
import 'package:retail_erp/features/master_entry/brand/domain/exceptions/brand_exceptions.dart';

void main() {
  group('BrandRepository', () {
    late AppDatabase database;
    late BrandRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = BrandRepository(database: database);
    });

    tearDown(() => database.close());

    test('creates a brand without brand code or active status', () async {
      final created = await repository.createBrand(
        name: 'Apple',
        description: 'Tech brand',
      );

      expect(created.id, greaterThan(0));
      expect(created.brandName, 'Apple');
      expect(created.description, 'Tech brand');
      expect(created.productCount, 0);
    });

    test('trims whitespace from name and description', () async {
      final created = await repository.createBrand(
        name: '  Samsung  ',
        description: '  Electronics  ',
      );

      expect(created.brandName, 'Samsung');
      expect(created.description, 'Electronics');

      final withoutDescription = await repository.createBrand(
        name: 'Nike',
        description: '   ',
      );
      expect(withoutDescription.description, isNull);
    });

    test('getAllBrands returns brands ordered by name', () async {
      await repository.createBrand(name: 'Zebra');
      await repository.createBrand(name: 'apple');
      await repository.createBrand(name: 'Banana');

      final rows = await repository.getAllBrands();
      final customNames = rows
          .where((b) => b.brandName != 'Generic / No Brand')
          .map((b) => b.brandName)
          .toList();
      expect(customNames, ['apple', 'Banana', 'Zebra']);
    });

    test('updateBrand updates fields and persists the new values', () async {
      final created = await repository.createBrand(
        name: 'Samsung',
        description: 'Phones',
      );

      final updated = await repository.updateBrand(
        created.id,
        name: 'Samsung Electronics',
        description: 'TVs and phones',
      );

      expect(updated.brandName, 'Samsung Electronics');
      expect(updated.description, 'TVs and phones');

      final reloaded = await repository.getAllBrands();
      expect(reloaded.any((b) => b.brandName == 'Samsung Electronics'), isTrue);
    });

    test('updateBrand throws BrandNotFoundException for unknown ids', () async {
      await expectLater(
        repository.updateBrand(9999, name: 'Missing'),
        throwsA(isA<BrandNotFoundException>()),
      );
    });

    test('deleteBrand removes the brand', () async {
      final created = await repository.createBrand(name: 'Sony');
      final initialCount = (await repository.getAllBrands()).length;

      await repository.deleteBrand(created.id);

      final remaining = await repository.getAllBrands();
      expect(remaining.length, initialCount - 1);
    });

    test('deleteBrand rejects brands referenced by products', () async {
      final brand = await repository.createBrand(name: 'Apple');

      final categoryId = await database
          .into(database.categories)
          .insert(
            db.CategoriesCompanion.insert(
              categoryCode: 'CAT-1',
              categoryName: 'Tech',
            ),
          );
      final units = await database.select(database.units).get();

      final unitId = units.first.id;

      await database
          .into(database.products)
          .insert(
            db.ProductsCompanion.insert(
              productCode: 'P-100',
              productName: 'iPhone 15',
              categoryId: Value(categoryId),
              brandId: Value(brand.id),
              unitId: unitId,
            ),
          );

      await expectLater(
        repository.deleteBrand(brand.id),
        throwsA(isA<BrandInUseException>()),
      );
    });

    test(
      'calculates real-time product count dynamically from products table',
      () async {
        final brand = await repository.createBrand(name: 'Samsung');

        final categoryId = await database
            .into(database.categories)
            .insert(
              db.CategoriesCompanion.insert(
                categoryCode: 'CAT-1',
                categoryName: 'Tech',
              ),
            );
        final units = await database.select(database.units).get();

        final unitId = units.first.id;

        // Initially product count is 0
        var brands = await repository.getAllBrands();
        var fetched = brands.firstWhere((b) => b.id == brand.id);
        expect(fetched.productCount, 0);

        // Add product 1
        await database
            .into(database.products)
            .insert(
              db.ProductsCompanion.insert(
                productCode: 'P-101',
                productName: 'Galaxy S24',
                categoryId: Value(categoryId),
                brandId: Value(brand.id),
                unitId: unitId,
              ),
            );

        // Add product 2
        await database
            .into(database.products)
            .insert(
              db.ProductsCompanion.insert(
                productCode: 'P-102',
                productName: 'Galaxy Tab',
                categoryId: Value(categoryId),
                brandId: Value(brand.id),
                unitId: unitId,
              ),
            );

        brands = await repository.getAllBrands();
        fetched = brands.firstWhere((b) => b.id == brand.id);
        expect(fetched.productCount, 2);
      },
    );

    test(
      'searchBrands filters case-insensitively by name or description',
      () async {
        await repository.createBrand(name: 'Apple', description: 'Smartphones');
        await repository.createBrand(name: 'Samsung', description: 'Displays');

        expect((await repository.searchBrands('app')).map((b) => b.brandName), [
          'Apple',
        ]);
        expect(
          (await repository.searchBrands('display')).map((b) => b.brandName),
          ['Samsung'],
        );
        expect(await repository.searchBrands('zzz'), isEmpty);
      },
    );

    test('existsByName is case-insensitive and honours excludeId', () async {
      final brand = await repository.createBrand(name: 'Nike');

      expect(await repository.existsByName('NIKE'), isTrue);
      expect(await repository.existsByName('nike'), isTrue);
      expect(await repository.existsByName('Adidas'), isFalse);
      expect(
        await repository.existsByName('Nike', excludeId: brand.id),
        isFalse,
      );
    });

    test('createBrand rejects duplicate names', () async {
      await repository.createBrand(name: 'Puma');

      await expectLater(
        repository.createBrand(name: 'puma'),
        throwsA(
          isA<BrandAlreadyExistsException>().having(
            (e) => e.message,
            'message',
            contains('puma'),
          ),
        ),
      );
    });

    test(
      'updateBrand rejects a name that collides with another brand',
      () async {
        final first = await repository.createBrand(name: 'Nike');
        await repository.createBrand(name: 'Adidas');

        await expectLater(
          repository.updateBrand(first.id, name: 'ADIDAS'),
          throwsA(isA<BrandAlreadyExistsException>()),
        );
      },
    );

    test('persists data across restart (file database)', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_brand_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      final firstSession = AppDatabase(NativeDatabase(file));
      await firstSession.customSelect('SELECT 1').get();
      await BrandRepository(
        database: firstSession,
      ).createBrand(name: 'Persisted Brand');
      await firstSession.close();

      final secondSession = AppDatabase(NativeDatabase(file));
      await secondSession.customSelect('SELECT 1').get();
      final rows = await BrandRepository(
        database: secondSession,
      ).getAllBrands();
      expect(rows.any((b) => b.brandName == 'Persisted Brand'), isTrue);
      await secondSession.close();
    });
  });
}
