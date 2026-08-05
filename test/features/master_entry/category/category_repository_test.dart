import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/category/domain/exceptions/category_exceptions.dart';

void main() {
  group('CategoryRepository', () {
    late AppDatabase database;
    late CategoryRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = CategoryRepository(database: database);
    });

    tearDown(() => database.close());

    test('creates a category with a generated code', () async {
      final created = await repository.createCategory(
        name: 'Electronics',
        description: 'Devices',
      );

      expect(created.id, greaterThan(0));
      expect(created.categoryCode, 'CAT-0001');
      expect(created.categoryName, 'Electronics');
      expect(created.description, 'Devices');
      expect(created.isActive, isTrue);
    });

    test('creates sequential codes', () async {
      final first = await repository.createCategory(name: 'Electronics');
      final second = await repository.createCategory(name: 'Groceries');

      expect(first.categoryCode, 'CAT-0001');
      expect(second.categoryCode, 'CAT-0002');
    });

    test('trims whitespace from name and description', () async {
      final created = await repository.createCategory(
        name: '  Groceries  ',
        description: '  Food items  ',
      );

      expect(created.categoryName, 'Groceries');
      expect(created.description, 'Food items');

      final withoutDescription = await repository.createCategory(
        name: 'Clothing',
        description: '   ',
      );
      expect(withoutDescription.description, isNull);
    });

    test('getAllCategories returns categories ordered by name', () async {
      await repository.createCategory(name: 'Zebra');
      await repository.createCategory(name: 'apple');
      await repository.createCategory(name: 'Banana');

      final rows = await repository.getAllCategories();
      expect(rows.map((c) => c.categoryName), ['apple', 'Banana', 'Zebra']);
    });

    test('updateCategory updates fields and persists the new values', () async {
      final created = await repository.createCategory(
        name: 'Electronics',
        description: 'Devices',
      );

      final updated = await repository.updateCategory(
        created.id,
        name: 'Consumer Electronics',
        description: 'TVs and phones',
        isActive: false,
      );

      expect(updated.categoryName, 'Consumer Electronics');
      expect(updated.description, 'TVs and phones');
      expect(updated.isActive, isFalse);
      expect(updated.categoryCode, created.categoryCode);

      final reloaded = await repository.getAllCategories();
      expect(reloaded.single.categoryName, 'Consumer Electronics');
    });

    test(
      'updateCategory throws CategoryNotFoundException for unknown ids',
      () async {
        await expectLater(
          repository.updateCategory(9999, name: 'Missing'),
          throwsA(isA<CategoryNotFoundException>()),
        );
      },
    );

    test('deleteCategory removes the category', () async {
      final created = await repository.createCategory(name: 'Electronics');
      expect(await repository.getAllCategories(), hasLength(1));

      await repository.deleteCategory(created.id);

      expect(await repository.getAllCategories(), isEmpty);
    });

    test(
      'deleteCategory rejects categories referenced by sub-categories',
      () async {
        final created = await repository.createCategory(name: 'Electronics');

        // A sub-category referencing the category blocks the delete via FK.
        await database
            .into(database.subCategories)
            .insert(
              db.SubCategoriesCompanion.insert(
                categoryId: created.id,
                subCategoryCode: 'SUB-0001',
                subCategoryName: 'Keyboards',
              ),
            );

        await expectLater(
          repository.deleteCategory(created.id),
          throwsA(isA<CategoryInUseException>()),
        );
        // The category is still present.
        expect(await repository.getAllCategories(), hasLength(1));
      },
    );

    test('searchCategories filters case-insensitively by name', () async {
      await repository.createCategory(name: 'Electronics');
      await repository.createCategory(name: 'Groceries');

      expect(
        (await repository.searchCategories('elec')).map((c) => c.categoryName),
        ['Electronics'],
      );
      expect(
        (await repository.searchCategories('GROC')).map((c) => c.categoryName),
        ['Groceries'],
      );
      expect(await repository.searchCategories('zzz'), isEmpty);
      expect(await repository.searchCategories(''), hasLength(2));
    });

    test('existsByName is case-insensitive and honours excludeId', () async {
      await repository.createCategory(name: 'Electronics');

      expect(await repository.existsByName('ELECTRONICS'), isTrue);
      expect(await repository.existsByName('electronics'), isTrue);
      expect(await repository.existsByName('Groceries'), isFalse);

      final row = (await repository.getAllCategories()).single;
      expect(
        await repository.existsByName('Electronics', excludeId: row.id),
        isFalse,
      );
    });

    test('createCategory rejects duplicate names', () async {
      await repository.createCategory(name: 'Electronics');

      await expectLater(
        repository.createCategory(name: 'electronics'),
        throwsA(
          isA<CategoryAlreadyExistsException>().having(
            (e) => e.message,
            'message',
            contains('electronics'),
          ),
        ),
      );
    });

    test(
      'updateCategory rejects a name that collides with another category',
      () async {
        final first = await repository.createCategory(name: 'Electronics');
        await repository.createCategory(name: 'Groceries');

        await expectLater(
          repository.updateCategory(first.id, name: 'GROCERIES'),
          throwsA(isA<CategoryAlreadyExistsException>()),
        );
      },
    );

    test('persists data across restart (file database)', () async {
      // Two sequential AppDatabase sessions on the same file are intentional
      // here; the warning below is only relevant for overlapping databases.
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_category_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      // First session: create a category, then close the database.
      final firstSession = AppDatabase(NativeDatabase(file));
      await firstSession.customSelect('SELECT 1').get();
      await CategoryRepository(
        database: firstSession,
      ).createCategory(name: 'Persisted');
      await firstSession.close();

      // Second session: the same file reopens and still contains the data.
      final secondSession = AppDatabase(NativeDatabase(file));
      await secondSession.customSelect('SELECT 1').get();
      final rows = await CategoryRepository(
        database: secondSession,
      ).getAllCategories();
      expect(rows, hasLength(1));
      expect(rows.single.categoryName, 'Persisted');
      await secondSession.close();
    });
  });
}
