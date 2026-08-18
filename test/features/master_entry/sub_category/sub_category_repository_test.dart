import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/sub_category/data/repositories/sub_category_repository.dart';
import 'package:retail_erp/features/master_entry/sub_category/domain/exceptions/sub_category_exceptions.dart';

void main() {
  group('SubCategoryRepository', () {
    late AppDatabase database;
    late CategoryRepository categoryRepository;
    late SubCategoryRepository repository;

    late int electronicsId;
    late int furnitureId;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      categoryRepository = CategoryRepository(database: database);
      repository = SubCategoryRepository(database: database);

      final cat1 = await categoryRepository.createCategory(name: 'Electronics');
      final cat2 = await categoryRepository.createCategory(name: 'Furniture');
      electronicsId = cat1.id;
      furnitureId = cat2.id;
    });

    tearDown(() => database.close());

    test('creates a sub-category with a generated code', () async {
      final created = await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Mobile Phones',
        description: 'Smartphones & feature phones',
      );

      expect(created.id, greaterThan(0));
      expect(created.categoryId, electronicsId);
      expect(created.categoryName, 'Electronics');
      expect(created.subCategoryCode, 'SUB-0001');
      expect(created.subCategoryName, 'Mobile Phones');
      expect(created.description, 'Smartphones & feature phones');
      expect(created.isActive, isTrue);
    });

    test('allows same sub-category name under different categories', () async {
      final sub1 = await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Mobile',
      );
      final sub2 = await repository.createSubCategory(
        categoryId: furnitureId,
        name: 'Mobile',
      );

      expect(sub1.subCategoryName, 'Mobile');
      expect(sub1.categoryId, electronicsId);

      expect(sub2.subCategoryName, 'Mobile');
      expect(sub2.categoryId, furnitureId);

      final all = await repository.getAllSubCategories();
      expect(all, hasLength(2));
    });

    test('rejects duplicate sub-category names under the same category', () async {
      await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Mobile',
      );

      await expectLater(
        repository.createSubCategory(
          categoryId: electronicsId,
          name: 'mobile',
        ),
        throwsA(isA<SubCategoryAlreadyExistsException>()),
      );
    });

    test('getAllSubCategories returns items ordered by sub-category name', () async {
      await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Zebra',
      );
      await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'apple',
      );
      await repository.createSubCategory(
        categoryId: furnitureId,
        name: 'Banana',
      );

      final rows = await repository.getAllSubCategories();
      expect(rows.map((s) => s.subCategoryName), ['apple', 'Banana', 'Zebra']);
    });

    test('updateSubCategory updates fields and persists new values', () async {
      final created = await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Mobile',
      );

      final updated = await repository.updateSubCategory(
        created.id,
        categoryId: furnitureId,
        name: 'Smartphones',
        description: 'Updated desc',
        isActive: false,
      );

      expect(updated.categoryId, furnitureId);
      expect(updated.categoryName, 'Furniture');
      expect(updated.subCategoryName, 'Smartphones');
      expect(updated.description, 'Updated desc');
      expect(updated.isActive, isFalse);
    });

    test('deleteSubCategory removes the sub-category', () async {
      final created = await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Mobile',
      );
      expect(await repository.getAllSubCategories(), hasLength(1));

      await repository.deleteSubCategory(created.id);

      expect(await repository.getAllSubCategories(), isEmpty);
    });

    test('searchSubCategories filters by category, sub-category, code, or description', () async {
      await repository.createSubCategory(
        categoryId: electronicsId,
        name: 'Smartphones',
        code: 'SUB-MOBILE',
        description: 'Android & iOS',
      );
      await repository.createSubCategory(
        categoryId: furnitureId,
        name: 'Chairs',
        code: 'SUB-CHAIR',
        description: 'Office chairs',
      );

      expect(
        (await repository.searchSubCategories('Electronics')).map((s) => s.subCategoryName),
        ['Smartphones'],
      );
      expect(
        (await repository.searchSubCategories('chair')).map((s) => s.subCategoryName),
        ['Chairs'],
      );
      expect(
        (await repository.searchSubCategories('SUB-MOBILE')).map((s) => s.subCategoryName),
        ['Smartphones'],
      );
      expect(
        (await repository.searchSubCategories('Android')).map((s) => s.subCategoryName),
        ['Smartphones'],
      );
    });

    test('persists data across restart (file database)', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_sub_category_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      final firstSession = AppDatabase(NativeDatabase(file));
      await firstSession.customSelect('SELECT 1').get();
      final cat = await CategoryRepository(database: firstSession)
          .createCategory(name: 'Persisted Category');
      await SubCategoryRepository(database: firstSession).createSubCategory(
        categoryId: cat.id,
        name: 'Persisted SubCategory',
      );
      await firstSession.close();

      final secondSession = AppDatabase(NativeDatabase(file));
      await secondSession.customSelect('SELECT 1').get();
      final rows = await SubCategoryRepository(database: secondSession)
          .getAllSubCategories();
      expect(rows, hasLength(1));
      expect(rows.single.subCategoryName, 'Persisted SubCategory');
      expect(rows.single.categoryName, 'Persisted Category');
      await secondSession.close();
    });
  });
}
