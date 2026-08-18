import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/features/master_entry/tax_category/data/repositories/tax_category_repository.dart';
import 'package:retail_erp/features/master_entry/tax_category/domain/entities/tax_category_component.dart';
import 'package:retail_erp/features/master_entry/tax_category/domain/exceptions/tax_category_exceptions.dart';

void main() {
  group('TaxCategoryRepository', () {
    late AppDatabase database;
    late TaxCategoryRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = TaxCategoryRepository(database: database);
    });

    tearDown(() => database.close());

    test('creates a tax category with components', () async {
      final created = await repository.createTaxCategory(
        name: 'Custom GST 18%',
        description: 'Standard Electronics Tax',
        components: const [
          TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 9.0),
          TaxCategoryComponent(taxTypeId: 3, taxTypeName: 'SGST', percentage: 9.0),
        ],
      );

      expect(created.id, greaterThan(0));
      expect(created.taxCategoryName, 'Custom GST 18%');
      expect(created.description, 'Standard Electronics Tax');
      expect(created.components.length, 2);
      expect(created.totalTaxPercentage, 18.0);
    });

    test('trims whitespace on name and description', () async {
      final created = await repository.createTaxCategory(
        name: '   Custom GST 12%   ',
        description: '   Sub category tax   ',
        components: const [
          TaxCategoryComponent(taxTypeId: 4, taxTypeName: 'IGST', percentage: 12.0),
        ],
      );

      expect(created.taxCategoryName, 'Custom GST 12%');
      expect(created.description, 'Sub category tax');
    });

    test('getAllTaxCategories returns tax categories ordered by name', () async {
      await repository.createTaxCategory(
        name: 'Z_Tax',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 5.0)],
      );
      await repository.createTaxCategory(
        name: 'a_Tax',
        components: const [TaxCategoryComponent(taxTypeId: 3, taxTypeName: 'SGST', percentage: 5.0)],
      );

      final categories = await repository.getAllTaxCategories();
      final names = categories.map((c) => c.taxCategoryName).toList();
      expect(names.contains('a_Tax'), isTrue);
      expect(names.contains('Z_Tax'), isTrue);
    });

    test('searchTaxCategories filters by name and description', () async {
      await repository.createTaxCategory(
        name: 'Custom GST 28%',
        description: 'Luxury items tax',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 14.0)],
      );
      await repository.createTaxCategory(
        name: 'Special Tax Free',
        description: 'Zero rate items',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 0.0)],
      );

      final searchByName = await repository.searchTaxCategories('Custom GST 28%');
      expect(searchByName.length, 1);
      expect(searchByName.first.taxCategoryName, 'Custom GST 28%');

      final searchByDesc = await repository.searchTaxCategories('zero rate');
      expect(searchByDesc.length, 1);
      expect(searchByDesc.first.taxCategoryName, 'Special Tax Free');
    });

    test('prevents creating duplicate category name', () async {
      await repository.createTaxCategory(
        name: 'Unique GST 18%',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 9.0)],
      );

      expect(
        () => repository.createTaxCategory(
          name: 'unique gst 18%',
          components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 9.0)],
        ),
        throwsA(isA<TaxCategoryAlreadyExistsException>()),
      );
    });

    test('updates tax category and replaces components', () async {
      final created = await repository.createTaxCategory(
        name: 'Custom GST 5%',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 2.5)],
      );

      final updated = await repository.updateTaxCategory(
        created.id,
        name: 'Custom GST 5% Updated',
        description: 'Updated note',
        components: const [
          TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 2.5),
          TaxCategoryComponent(taxTypeId: 3, taxTypeName: 'SGST', percentage: 2.5),
        ],
      );

      expect(updated.taxCategoryName, 'Custom GST 5% Updated');
      expect(updated.description, 'Updated note');
      expect(updated.components.length, 2);
      expect(updated.totalTaxPercentage, 5.0);
    });

    test('deletes tax category when not in use', () async {
      final created = await repository.createTaxCategory(
        name: 'Temporary Tax',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 1.0)],
      );

      await repository.deleteTaxCategory(created.id);
      final found = await repository.getById(created.id);
      expect(found, isNull);
    });

    test('delete protected when product uses tax category', () async {
      final category = await repository.createTaxCategory(
        name: 'Product Tax',
        components: const [TaxCategoryComponent(taxTypeId: 2, taxTypeName: 'CGST', percentage: 5.0)],
      );

      // Seed a category for productFK
      await database.into(database.categories).insert(
        CategoriesCompanion.insert(id: const Value(1), categoryCode: 'CAT1', categoryName: 'General'),
      );

      // Insert product referencing this taxCategory (brand 1 and units 1 are pre-seeded)
      await database.into(database.products).insert(
        ProductsCompanion.insert(
          id: const Value(100),
          productCode: 'PROD100',
          productName: 'Sample Product',
          categoryId: 1,
          brandId: 1,
          purchaseUnitId: 1,
          salesUnitId: 1,
          stockUnitId: 1,
          taxCategoryId: category.id,
        ),
      );

      expect(
        () => repository.deleteTaxCategory(category.id),
        throwsA(isA<TaxCategoryInUseException>()),
      );
    });
  });
}
