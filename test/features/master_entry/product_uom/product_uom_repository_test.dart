import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/features/master_entry/product_uom/data/repositories/product_uom_repository.dart';
import 'package:retail_erp/features/master_entry/product_uom/domain/exceptions/product_uom_exceptions.dart';

void main() {
  group('ProductUomRepository', () {
    late db.AppDatabase database;
    late ProductUomRepository repository;
    late int productId;

    setUp(() async {
      database = db.AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = ProductUomRepository(database: database);

      final categoryId = await database
          .into(database.categories)
          .insert(
            db.CategoriesCompanion.insert(
              categoryCode: 'CAT-1',
              categoryName: 'Produce',
            ),
          );
      productId = await database
          .into(database.products)
          .insert(
            db.ProductsCompanion.insert(
              productCode: 'P-1',
              productName: 'Banana',
              categoryId: Value(categoryId),
              brandId: const Value(1),
              unitId: 1,
            ),
          );
    });

    tearDown(() => database.close());

    test('getAllProducts fetches products directly from the DB products table', () async {
      final products = await repository.getAllProducts();
      expect(products, hasLength(1));
      expect(products.first.productName, equals('Banana'));
      expect(products.first.productCode, equals('P-1'));
    });

    test('the first conversion for a product becomes the default', () async {
      final created = await repository.createConversion(
        productId: productId,
        fromUnitId: 2, // Dozen
        toUnitId: 1, // Piece
        conversionFactor: 12,
      );

      expect(created.isDefault, isTrue);

      final rows = await repository.getForProduct(productId);
      expect(rows, hasLength(1));
      expect(rows.single.isDefault, isTrue);
    });

    test('a second conversion is not default by itself', () async {
      await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );
      final second = await repository.createConversion(
        productId: productId,
        fromUnitId: 3, // Pair
        toUnitId: 1,
        conversionFactor: 2,
      );

      expect(second.isDefault, isFalse);
      final rows = await repository.getForProduct(productId);
      expect(rows.where((r) => r.isDefault), hasLength(1));
    });

    test('creating with isDefault moves the default', () async {
      final first = await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );
      final second = await repository.createConversion(
        productId: productId,
        fromUnitId: 3,
        toUnitId: 1,
        conversionFactor: 2,
        isDefault: true,
      );

      expect(first.isDefault, isTrue);
      expect(second.isDefault, isTrue);

      final rows = await repository.getForProduct(productId);
      expect(rows.where((r) => r.isDefault), hasLength(1));
      expect(rows.firstWhere((r) => r.id == second.id).isDefault, isTrue);
      expect(rows.firstWhere((r) => r.id == first.id).isDefault, isFalse);
    });

    test('setDefault clears the previous default', () async {
      final first = await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );
      final second = await repository.createConversion(
        productId: productId,
        fromUnitId: 3,
        toUnitId: 1,
        conversionFactor: 2,
      );

      await repository.setDefault(second.id);

      final rows = await repository.getForProduct(productId);
      expect(rows.where((r) => r.isDefault), hasLength(1));
      expect(rows.firstWhere((r) => r.id == second.id).isDefault, isTrue);
      expect(rows.firstWhere((r) => r.id == first.id).isDefault, isFalse);
    });

    test('rejects exact duplicates but allows different factors', () async {
      await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );

      await expectLater(
        repository.createConversion(
          productId: productId,
          fromUnitId: 2,
          toUnitId: 1,
          conversionFactor: 12,
        ),
        throwsA(isA<ProductUomAlreadyExistsException>()),
      );

      final other = await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 24,
      );
      expect(other.conversionFactor, 24.0);
    });

    test('rejects identical from/to units and non-positive factors', () async {
      await expectLater(
        repository.createConversion(
          productId: productId,
          fromUnitId: 1,
          toUnitId: 1,
          conversionFactor: 1,
        ),
        throwsArgumentError,
      );
      await expectLater(
        repository.createConversion(
          productId: productId,
          fromUnitId: 2,
          toUnitId: 1,
          conversionFactor: 0,
        ),
        throwsArgumentError,
      );
    });

    test('deleting default conversion assigns default to oldest remaining', () async {
      final first = await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );
      final second = await repository.createConversion(
        productId: productId,
        fromUnitId: 3,
        toUnitId: 1,
        conversionFactor: 2,
      );

      expect(first.isDefault, isTrue);
      expect(second.isDefault, isFalse);

      await repository.deleteConversion(first.id);

      final rows = await repository.getForProduct(productId);
      expect(rows, hasLength(1));
      expect(rows.single.id, equals(second.id));
      expect(rows.single.isDefault, isTrue);
    });

    test('resolveFactor uses the product row and derives the reverse', () async {
      await repository.createConversion(
        productId: productId,
        fromUnitId: 2,
        toUnitId: 1,
        conversionFactor: 12,
      );

      expect(await repository.resolveFactor(productId, 2, 1), 12.0);
      expect(
        await repository.resolveFactor(productId, 1, 2),
        closeTo(1 / 12, 1e-9),
      );
      expect(await repository.resolveFactor(productId, 1, 1), 1.0);
      expect(await repository.resolveFactor(productId, 2, 5), isNull);
    });
  });
}
