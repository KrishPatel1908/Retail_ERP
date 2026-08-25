import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import 'package:retail_erp/features/master_entry/brand/data/repositories/brand_repository.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/product/domain/exceptions/product_exceptions.dart';
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';

import '../../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  late ProductRepository repository;
  late int unitId;
  late int categoryId;
  late int brandId;

  setUp(() async {
    repository = ProductRepository();
    final unitRepo = UnitRepository();
    final u = await unitRepo.createUnit(
      name: 'Pieces',
      symbol: 'pcs',
      family: 'Unit',
    );
    unitId = u.id;

    final catRepo = CategoryRepository();
    final c = await catRepo.createCategory(name: 'Groceries');
    categoryId = c.id;

    final brandRepo = BrandRepository();
    final b = await brandRepo.createBrand(name: 'Nestle');
    brandId = b.id;
  });

  group('ProductRepository with new fields', () {
    test('creates product with purchasePrice, mrp, wholesalePrice, barcode, hsnCode and variants', () async {
      final product = await repository.createProduct(
        productName: 'Maggi Noodles',
        productCode: 'MAGGI01',
        categoryId: categoryId,
        brandId: brandId,
        unitId: unitId,
        sellingPrice: 1400,
        purchasePrice: 1000,
        mrp: 1500,
        wholesalePrice: 1200,
        barcode: '8901058852341',
        hsnCode: '19023010',
        variants: [
          const VariantInput(
            variantName: 'Single Pack 70g',
            sellingPrice: 1400,
            purchasePrice: 1000,
            mrp: 1500,
            wholesalePrice: 1200,
            barcode: '8901058852342',
            hsnCode: '19023010',
          ),
          const VariantInput(
            variantName: 'Special 4-Pack 280g',
            sellingPrice: 5200,
            purchasePrice: 4000,
            mrp: 5600,
            wholesalePrice: 4600,
            barcode: '8901058852343',
            hsnCode: '19023010',
          ),
        ],
      );

      expect(product.productName, 'Maggi Noodles');
      expect(product.sellingPrice, 1400);
      expect(product.purchasePrice, 1000);
      expect(product.mrp, 1500);
      expect(product.wholesalePrice, 1200);
      expect(product.barcode, '8901058852341');
      expect(product.hsnCode, '19023010');
      expect(product.variants.length, 2);

      final v1 = product.variants[0];
      expect(v1.variantName, 'Single Pack 70g');
      expect(v1.purchasePrice, 1000);
      expect(v1.mrp, 1500);
      expect(v1.wholesalePrice, 1200);
      expect(v1.barcode, '8901058852342');
      expect(v1.hsnCode, '19023010');

      final v2 = product.variants[1];
      expect(v2.variantName, 'Special 4-Pack 280g');
      expect(v2.sellingPrice, 5200);
      expect(v2.purchasePrice, 4000);
      expect(v2.mrp, 5600);
      expect(v2.wholesalePrice, 4600);
      expect(v2.barcode, '8901058852343');
    });

    test('updates product with new fields and updates variants', () async {
      final created = await repository.createProduct(
        productName: 'KitKat',
        unitId: unitId,
        sellingPrice: 2000,
      );

      final updated = await repository.updateProduct(
        created.id,
        productName: 'KitKat 4 Finger',
        unitId: unitId,
        sellingPrice: 2500,
        purchasePrice: 1800,
        mrp: 3000,
        wholesalePrice: 2200,
        barcode: '8901058899999',
        hsnCode: '18063200',
      );

      expect(updated.productName, 'KitKat 4 Finger');
      expect(updated.sellingPrice, 2500);
      expect(updated.purchasePrice, 1800);
      expect(updated.mrp, 3000);
      expect(updated.wholesalePrice, 2200);
      expect(updated.barcode, '8901058899999');
      expect(updated.hsnCode, '18063200');
    });

    test('searches products by barcode and hsn code', () async {
      await repository.createProduct(
        productName: 'Dairy Milk Silk',
        unitId: unitId,
        sellingPrice: 8000,
        barcode: '8901233445566',
        hsnCode: '18069010',
      );

      final resultByBarcode = await repository.fetchPage(query: '8901233445566');
      expect(resultByBarcode.items.length, 1);
      expect(resultByBarcode.items.first.productName, 'Dairy Milk Silk');

      final resultByHsn = await repository.fetchPage(query: '18069010');
      expect(resultByHsn.items.length, 1);
      expect(resultByHsn.items.first.productName, 'Dairy Milk Silk');
    });

    test('enforces unique barcode across products and variants', () async {
      await repository.createProduct(
        productName: 'Item A',
        unitId: unitId,
        sellingPrice: 100,
        barcode: 'BARCODE123',
      );

      expect(
        () => repository.createProduct(
          productName: 'Item B',
          unitId: unitId,
          sellingPrice: 200,
          barcode: 'BARCODE123',
        ),
        throwsA(isA<ProductDuplicateException>()),
      );
    });

    test('creates and updates variant with new fields', () async {
      final product = await repository.createProduct(
        productName: 'Pepsi',
        unitId: unitId,
        sellingPrice: 4000,
      );

      final variant = await repository.createVariant(
        product.id,
        variantName: '500ml Bottle',
        sellingPrice: 4000,
        purchasePrice: 3000,
        mrp: 4500,
        wholesalePrice: 3500,
        barcode: '890200000001',
        hsnCode: '22021010',
      );

      expect(variant.variantName, '500ml Bottle');
      expect(variant.purchasePrice, 3000);
      expect(variant.mrp, 4500);
      expect(variant.wholesalePrice, 3500);
      expect(variant.barcode, '890200000001');
      expect(variant.hsnCode, '22021010');

      final updatedVariant = await repository.updateVariant(
        variant.id,
        variantName: '500ml PET Bottle',
        sellingPrice: 4200,
        purchasePrice: 3200,
        mrp: 4800,
        wholesalePrice: 3700,
        barcode: '890200000002',
        hsnCode: '22021010',
      );

      expect(updatedVariant.variantName, '500ml PET Bottle');
      expect(updatedVariant.sellingPrice, 4200);
      expect(updatedVariant.purchasePrice, 3200);
      expect(updatedVariant.mrp, 4800);
      expect(updatedVariant.wholesalePrice, 3700);
      expect(updatedVariant.barcode, '890200000002');
    });
  });
}
