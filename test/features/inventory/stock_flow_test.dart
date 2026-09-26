import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/data/repositories/inventory_repository.dart';
import 'package:retail_erp/features/inventory/domain/entities/inventory.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/brand/data/repositories/brand_repository.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_return_repository.dart';
import 'package:retail_erp/features/purchase/domain/entities/purchase.dart';

import '../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  late SupplierRepository supplierRepository;
  late ProductRepository productRepository;
  late PurchaseRepository purchaseRepository;
  late PurchaseReturnRepository returnRepository;
  late InventoryRepository inventoryRepository;

  setUp(() {
    supplierRepository = SupplierRepository();
    productRepository = ProductRepository();
    purchaseRepository = PurchaseRepository();
    returnRepository = PurchaseReturnRepository();
    inventoryRepository = InventoryRepository();
  });

  Future<int> stockOf(int productId, {int? variantId}) async {
    final database = DatabaseProvider.instance.database;
    final row = await (database.select(database.currentStocks)..where(
          (t) =>
              t.productId.equals(productId) &
              (variantId != null
                  ? t.variantId.equals(variantId)
                  : t.variantId.isNull()),
        ))
            .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  PurchaseItemInput item(
    int productId, {
    int? variantId,
    int quantity = 10,
    int price = 500,
  }) =>
      PurchaseItemInput(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
        unitId: 1,
        purchasePrice: price,
        taxRate: 0,
      );

  PurchaseReturnItemInput returnItem(
    PurchaseItemEntity original, {
    int? quantity,
  }) =>
      PurchaseReturnItemInput(
        purchaseItemId: original.id,
        productId: original.productId,
        variantId: original.variantId,
        returnQuantity: quantity ?? original.quantity,
        purchasePrice: original.purchasePrice,
        taxRate: original.taxRate,
      );

  group('stock service', () {
    test('rejects a change that would make stock negative', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 1000,
      );
      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 5)],
      );

      // Editing the purchase to a quantity of 8 against 0 available stock
      // after a full return is a negative-stock attempt; here we exercise the
      // direct decrease path instead via a return of more than stock.
      await returnRepository.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplier.id,
        returnDate: DateTime(2026, 9, 2),
        items: [returnItem(purchase.items.single, quantity: 5)],
      );

      final service = StockService();
      await expectLater(
        () => DatabaseProvider.instance.database.transaction(() async {
          await service.applyStockChange(
            productId: product.id,
            delta: -1,
            transactionType: StockMovementType.sale,
            transactionDate: DateTime(2026, 9, 3),
          );
        }),
        throwsA(
          isA<InsufficientStockException>().having(
            (e) => e.message,
            'message',
            'Insufficient stock. Available stock: 0.',
          ),
        ),
      );
      expect(await stockOf(product.id), 0);
    });

    test('barcode resolves the exact variant, not the parent', () async {
      final product = await productRepository.createProduct(
        productName: 'iPhone 16',
        unitId: 1,
        sellingPrice: 80000,
        barcode: 'PARENT-BAR',
        variants: [
          const VariantInput(
            variantName: '128GB',
            sellingPrice: 80000,
            barcode: 'IPH-128',
          ),
          const VariantInput(
            variantName: '256GB',
            sellingPrice: 90000,
            barcode: 'IPH-256',
          ),
        ],
      );

      final service = StockService();
      final resolved = await service.resolveStockItem('IPH-128');

      expect(resolved, isNotNull);
      expect(resolved!.productId, product.id);
      expect(resolved.variantId, product.variants[0].id);

      // Unknown barcodes resolve to nothing.
      expect(await service.resolveStockItem('NOPE'), isNull);
    });
  });

  group('purchase → stock', () {
    test('multiple products increase independently', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final a = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      final b = await productRepository.createProduct(
        productName: 'B',
        unitId: 1,
        sellingPrice: 100,
      );

      await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          item(a.id, quantity: 20),
          item(b.id, quantity: 10),
        ],
      );

      expect(await stockOf(a.id), 20);
      expect(await stockOf(b.id), 10);
    });

    test('variant stock is independent', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 1000,
        variants: [
          const VariantInput(variantName: '5', sellingPrice: 500),
          const VariantInput(variantName: '10', sellingPrice: 900),
        ],
      );

      await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          item(product.id, quantity: 20), // parent
          item(product.id, variantId: product.variants[0].id, quantity: 20),
          item(product.id, variantId: product.variants[1].id, quantity: 15),
        ],
      );

      expect(await stockOf(product.id), 20);
      expect(await stockOf(product.id, variantId: product.variants[0].id), 20);
      expect(await stockOf(product.id, variantId: product.variants[1].id), 15);
    });

    test('failed purchase leaves stock untouched', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 20)],
      );
      expect(await stockOf(product.id), 20);

      // A purchase paying more than the total fails and must not add stock.
      await expectLater(
        purchaseRepository.createPurchase(
          supplierId: supplier.id,
          purchaseDate: DateTime(2026, 9, 2),
          paidAmount: 999999,
          items: [item(product.id, quantity: 5)],
        ),
        throwsA(isA<PurchaseValidationException>()),
      );
      expect(await stockOf(product.id), 20);
    });

    test('duplicate submission does not double-change stock', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 10)],
      );

      // Re-applying the same purchase's items through the same repository
      // path is not possible via the UI; instead re-saving the purchase with
      // identical items must not change stock (delta = 0).
      await purchaseRepository.updatePurchase(
        purchase.id,
        supplierId: supplier.id,
        purchaseDate: purchase.purchaseDate,
        items: [
          item(product.id, quantity: 10),
        ],
      );
      expect(await stockOf(product.id), 10);
    });
  });

  group('purchase edit → stock', () {
    test('edit from +10 to +15 applies +5, not +25', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 10)],
      );
      expect(await stockOf(product.id), 10);

      await purchaseRepository.updatePurchase(
        purchase.id,
        supplierId: supplier.id,
        purchaseDate: purchase.purchaseDate,
        items: [item(product.id, quantity: 15)],
      );

      expect(await stockOf(product.id), 15);
    });

    test('removing an item reverses its stock', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final a = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      final b = await productRepository.createProduct(
        productName: 'B',
        unitId: 1,
        sellingPrice: 100,
      );
      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(a.id, quantity: 10), item(b.id, quantity: 5)],
      );

      await purchaseRepository.updatePurchase(
        purchase.id,
        supplierId: supplier.id,
        purchaseDate: purchase.purchaseDate,
        items: [item(a.id, quantity: 10)],
      );

      expect(await stockOf(a.id), 10);
      expect(await stockOf(b.id), 0);
    });
  });

  group('purchase return → stock', () {
    test('full spec scenario: purchase, return, revert, edit, adjust', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final productA = await productRepository.createProduct(
        productName: 'Product A',
        unitId: 1,
        sellingPrice: 1000,
      );
      final productB = await productRepository.createProduct(
        productName: 'Product B',
        unitId: 1,
        sellingPrice: 1000,
      );
      final variantProduct = await productRepository.createProduct(
        productName: 'Variant Product',
        unitId: 1,
        sellingPrice: 1000,
        variants: [const VariantInput(variantName: 'V1', sellingPrice: 1000)],
      );

      // 1–3. Opening stocks: A = 20, B = 10, variant = 15.
      await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          item(productA.id, quantity: 20),
          item(productB.id, quantity: 10),
          item(
            variantProduct.id,
            variantId: variantProduct.variants.single.id,
            quantity: 15,
          ),
        ],
      );
      expect(await stockOf(productA.id), 20);
      expect(await stockOf(productB.id), 10);
      expect(
        await stockOf(
          variantProduct.id,
          variantId: variantProduct.variants.single.id,
        ),
        15,
      );

      // 4. Purchase Product A +10 → 30.
      final secondPurchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 2),
        items: [item(productA.id, quantity: 10)],
      );
      expect(await stockOf(productA.id), 30);

      // 6. Return Product A 5 → 25.
      final returned = await returnRepository.createReturn(
        originalPurchaseId: secondPurchase.id,
        supplierId: supplier.id,
        returnDate: DateTime(2026, 9, 3),
        items: [
          returnItem(secondPurchase.items.single, quantity: 5),
        ],
      );
      expect(await stockOf(productA.id), 25);

      // 8. Revert return → 30.
      await returnRepository.revertReturn(
        returned.id,
        revertDate: DateTime(2026, 9, 3, 12),
      );
      expect(await stockOf(productA.id), 30);

      // 10–11. Edit original purchase from +10 to +15: final effect +15 only.
      await purchaseRepository.updatePurchase(
        secondPurchase.id,
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 3, 18),
        items: [item(productA.id, quantity: 15)],
      );
      expect(await stockOf(productA.id), 35); // 20 (first purchase) + 15.

      // 12. Stock adjustment −3 → 32.
      final newStock = await inventoryRepository.createAdjustment(
        productId: productA.id,
        direction: StockAdjustmentDirection.decrease,
        quantity: 3,
        reason: 'Damaged goods',
        adjustmentDate: DateTime(2026, 9, 4),
      );
      expect(newStock, 32);
      expect(await stockOf(productA.id), 32);

      // 14–15. Decreasing more than available is rejected.
      await expectLater(
        inventoryRepository.createAdjustment(
          productId: productA.id,
          direction: StockAdjustmentDirection.decrease,
          quantity: 100,
          reason: 'Too much',
          adjustmentDate: DateTime(2026, 9, 5),
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      expect(await stockOf(productA.id), 32);

      // 20. Every stock change is in the movement history in order.
      final movements = <StockMovementEntity>[];
      var page = 1;
      while (true) {
        final result = await inventoryRepository.fetchMovements(
          productId: productA.id,
          page: page,
          pageSize: 10,
        );
        movements.addAll(result.items);
        if (movements.length >= result.totalCount) break;
        page++;
      }

      // The last movement in chronological order (first in newest-first order)
      // is the −3 adjustment with previous 35 → new 32.
      expect(movements.first.quantity, -3);
      expect(movements.first.previousQuantity, 35);
      expect(movements.first.newQuantity, 32);
      expect(
        movements.first.transactionType,
        StockMovementType.stockAdjustment,
      );

      // Every movement's previous/new chain is consistent: previous equals
      // the previous movement's new stock when they target the same item.
      for (var i = 1; i < movements.length; i++) {
        expect(movements[i].newQuantity, movements[i - 1].previousQuantity);
      }

      // The purchase-edit movement applies only the +5 delta (not +25).
      final editMovement = movements
          .where(
            (m) =>
                m.transactionType == StockMovementType.purchaseAdjustment,
          )
          .toList();
      expect(editMovement, hasLength(1));
      expect(editMovement.single.quantity, 5); // +15 − 10.
      expect(editMovement.single.previousQuantity, 30);
      expect(editMovement.single.newQuantity, 35);

      // The revert movement (+5) and return movement (−5) are both recorded.
      final returnMovements = movements
          .where((m) => m.transactionType == StockMovementType.purchaseReturn)
          .map((m) => m.quantity)
          .toList();
      expect(returnMovements, unorderedEquals([-5, 5]));

      // Movements are ordered newest first (id-descending for same date).
      final ids = movements.map((m) => m.id).toList();
      expect(ids, equals([...ids]..sort((a, b) => b.compareTo(a))));
    });

    test('return delete restores stock', () async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 20)],
      );

      final returned = await returnRepository.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplier.id,
        returnDate: DateTime(2026, 9, 2),
        items: [returnItem(purchase.items.single, quantity: 5)],
      );
      expect(await stockOf(product.id), 15);

      await returnRepository.deleteReturn(returned.id);
      expect(await stockOf(product.id), 20);

      // Status is gone from the listing.
      final page = await returnRepository.fetchPage();
      expect(page.totalCount, 0);
    });
  });

  group('stock adjustment', () {
    late int productId;
    setUp(() async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      final product = await productRepository.createProduct(
        productName: 'A',
        unitId: 1,
        sellingPrice: 100,
      );
      await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [item(product.id, quantity: 20)],
      );
      productId = product.id;
    });

    test('increase adds stock and records a movement', () async {
      final newStock = await inventoryRepository.createAdjustment(
        productId: productId,
        direction: StockAdjustmentDirection.increase,
        quantity: 5,
        reason: 'Stock count correction',
        adjustmentDate: DateTime(2026, 9, 2),
      );
      expect(newStock, 25);
      expect(await stockOf(productId), 25);

      final movements = await inventoryRepository.fetchMovements(
        productId: productId,
      );
      expect(movements.items.first.transactionType,
          StockMovementType.stockAdjustment);
      expect(movements.items.first.quantity, 5);
      expect(movements.items.first.previousQuantity, 20);
      expect(movements.items.first.newQuantity, 25);
      expect(movements.items.first.note, contains('Stock count correction'));
    });

    test('decrease cannot make stock negative', () async {
      await expectLater(
        inventoryRepository.createAdjustment(
          productId: productId,
          direction: StockAdjustmentDirection.decrease,
          quantity: 21,
          reason: 'Damage',
          adjustmentDate: DateTime(2026, 9, 2),
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      expect(await stockOf(productId), 20);

      // Nothing was recorded.
      final movements = await inventoryRepository.fetchMovements(
        productId: productId,
      );
      expect(
        movements.items
            .where((m) => m.transactionType == StockMovementType.stockAdjustment),
        isEmpty,
      );
    });
  });

  group('inventory listing', () {
    late int biscuitsId;
    late int snacksId;
    late int parleId;
    late int britanniaId;
    late int lowStockProduct;
    late int outOfStockProduct;

    setUp(() async {
      final supplier = await supplierRepository.createSupplier(
        supplierName: 'Acme',
        mobile: '9876543210',
      );
      biscuitsId = (await CategoryRepository().createCategory(
        name: 'Biscuits',
      ))
          .id;
      snacksId = (await CategoryRepository().createCategory(
        name: 'Snacks',
      ))
          .id;
      parleId = (await BrandRepository().createBrand(name: 'Parle')).id;
      britanniaId = (await BrandRepository().createBrand(name: 'Britannia')).id;

      final low = await productRepository.createProduct(
        productName: 'Parle-G 5',
        categoryId: biscuitsId,
        brandId: parleId,
        unitId: 1,
        sellingPrice: 500,
        barcode: '890123',
        minimumStock: 5,
      );
      final out = await productRepository.createProduct(
        productName: 'Parle-G 10',
        categoryId: biscuitsId,
        brandId: parleId,
        unitId: 1,
        sellingPrice: 900,
        barcode: '891234',
      );
      final other = await productRepository.createProduct(
        productName: 'Chips',
        categoryId: snacksId,
        brandId: britanniaId,
        unitId: 1,
        sellingPrice: 200,
        barcode: '892345',
        variants: [const VariantInput(variantName: 'Family', sellingPrice: 300)],
      );

      final purchase = await purchaseRepository.createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 9, 1),
        items: [
          item(low.id, quantity: 3), // 0 < 3 <= 5 → Low Stock
          item(out.id, quantity: 2),
          item(
            other.id,
            variantId: other.variants.single.id,
            quantity: 9,
          ),
        ],
      );

      // Make 'Parle-G 10' out of stock via a full return.
      await returnRepository.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplier.id,
        returnDate: DateTime(2026, 9, 2),
        items: [returnItem(purchase.items[1])],
      );

      lowStockProduct = low.id;
      outOfStockProduct = out.id;
    });

    test('products and variants appear as separate rows', () async {
      final page = await inventoryRepository.fetchPage();
      expect(page.totalCount, 3); // Parle-G 5, Parle-G 10, Chips/Family.

      final chips = page.items.singleWhere((i) => i.productName == 'Chips');
      expect(chips.variantName, 'Family');
      expect(chips.currentStock, 9);
      expect(chips.barcode, '892345'); // variant inherits the parent barcode.

      final parle5 = page.items
          .singleWhere((i) => i.productName == 'Parle-G 5');
      expect(parle5.variantName, isNull);
      expect(parle5.barcode, '890123');
    });

    test('search matches product name, variant name, and barcode', () async {
      final byName = await inventoryRepository.fetchPage(query: 'parle');
      expect(byName.totalCount, 2);

      final byBarcode = await inventoryRepository.fetchPage(query: '890123');
      expect(byBarcode.totalCount, 1);
      expect(byBarcode.items.single.productName, 'Parle-G 5');

      final byVariant = await inventoryRepository.fetchPage(query: 'family');
      expect(byVariant.totalCount, 1);
      expect(byVariant.items.single.productName, 'Chips');
    });

    test('category, brand and stock status filters combine', () async {
      final biscuits = await inventoryRepository.fetchPage(
        filters: InventoryFilters(categoryId: biscuitsId),
      );
      expect(biscuits.totalCount, 2);

      final parleBiscuits = await inventoryRepository.fetchPage(
        filters: InventoryFilters(
          categoryId: biscuitsId,
          brandId: parleId,
        ),
      );
      expect(parleBiscuits.totalCount, 2);

      final lowBiscuits = await inventoryRepository.fetchPage(
        filters: InventoryFilters(
          categoryId: biscuitsId,
          brandId: parleId,
          stockStatus: StockStatus.lowStock,
        ),
      );
      expect(lowBiscuits.totalCount, 1);
      expect(lowBiscuits.items.single.productId, lowStockProduct);

      final outOfStock = await inventoryRepository.fetchPage(
        filters: InventoryFilters(stockStatus: StockStatus.outOfStock),
      );
      expect(outOfStock.totalCount, 1);
      expect(outOfStock.items.single.productId, outOfStockProduct);

      final inStock = await inventoryRepository.fetchPage(
        filters: InventoryFilters(stockStatus: StockStatus.inStock),
      );
      expect(inStock.totalCount, 1);
      expect(inStock.items.single.productName, 'Chips');
    });

    test('status is derived from minimum stock', () async {
      final page = await inventoryRepository.fetchPage();
      for (final item in page.items) {
        if (item.productId == lowStockProduct) {
          expect(item.status, StockStatus.lowStock);
        } else if (item.productId == outOfStockProduct) {
          expect(item.status, StockStatus.outOfStock);
        } else {
          expect(item.status, StockStatus.inStock);
        }
      }
    });

    test('pagination works database-side', () async {
      final first = await inventoryRepository.fetchPage(pageSize: 2, page: 1);
      expect(first.items, hasLength(2));
      expect(first.totalCount, 3);

      final second = await inventoryRepository.fetchPage(pageSize: 2, page: 2);
      expect(second.items, hasLength(1));
    });
  });
}
