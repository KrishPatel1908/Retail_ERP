import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_return_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/purchase/domain/entities/purchase.dart';
import 'package:retail_erp/features/purchase/domain/entities/purchase_return.dart';

import '../../helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  Future<(int, int)> seedSupplierAndProduct({
    String productName = 'Parle-G',
  }) async {
    final supplier = await SupplierRepository().createSupplier(
      supplierName: 'Acme Supplies',
      mobile: '9876543210',
    );
    final product = await ProductRepository().createProduct(
      productName: productName,
      unitId: 1,
      sellingPrice: 1000,
      purchasePrice: 500,
    );
    return (supplier.id, product.id);
  }

  Future<PurchaseEntity> makePurchase({
    required int supplierId,
    required int productId,
    int quantity = 20,
    int purchasePrice = 500,
    double taxRate = 0,
  }) {
    return PurchaseRepository().createPurchase(
      supplierId: supplierId,
      purchaseDate: DateTime(2026, 8, 1),
      paidAmount: 0,
      items: [
        PurchaseItemInput(
          productId: productId,
          quantity: quantity,
          unitId: 1,
          purchasePrice: purchasePrice,
          discount: 0,
          taxRate: taxRate,
        ),
      ],
    );
  }

  Future<int> currentStock(int productId) async {
    final database = DatabaseProvider.instance.database;
    final row =
        await (database.select(database.currentStocks)..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
            .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  Future<int> supplierBalance(int supplierId) async {
    final database = DatabaseProvider.instance.database;
    final row = await (database.select(
      database.suppliers,
    )..where((t) => t.id.equals(supplierId))).getSingle();
    return row.outstandingBalance;
  }

  Future<List<dynamic>> returnTransactions(int purchaseId) async {
    final database = DatabaseProvider.instance.database;
    return (database.select(database.inventoryTransactions)..where(
          (t) =>
              t.purchaseId.equals(purchaseId) &
              t.transactionType.equals('PURCHASE_RETURN'),
        ))
        .get();
  }

  group('createReturn calculations', () {
    test('Purchase 20 @ ₹5 → Return 5 = ₹25 subtotal, total', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );

      final returnEntity = await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );

      expect(returnEntity.returnNumber, startsWith('PRN-'));
      expect(returnEntity.subtotal, 2500); // 5 × 500
      expect(returnEntity.discount, 0);
      expect(returnEntity.tax, 0);
      expect(returnEntity.total, 2500);
      expect(returnEntity.status, PurchaseReturnStatus.completed);
      expect(returnEntity.items.single.returnQuantity, 5);
    });

    test('tax is computed on the return line', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 10,
        purchasePrice: 1000,
        taxRate: 10,
      );

      final returnEntity = await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 4,
            purchasePrice: 1000,
            taxRate: 10,
          ),
        ],
      );

      // 4 × ₹10 = ₹40 subtotal, 10% tax = ₹4 → total ₹44 (4400 paise).
      expect(returnEntity.subtotal, 4000);
      expect(returnEntity.tax, 400);
      expect(returnEntity.total, 4400);
      expect(returnEntity.items.single.taxAmount, 400);
      expect(returnEntity.items.single.lineTotal, 4400);
    });
  });

  group('createReturn validation', () {
    Future<PurchaseEntity> seededPurchase() async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      return makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 10,
        purchasePrice: 1000,
      );
    }

    test('rejects a zero quantity', () async {
      final purchase = await seededPurchase();
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: purchase.supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: purchase.items.single.productId,
              returnQuantity: 0,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });

    test('rejects a return exceeding current stock', () async {
      final purchase = await seededPurchase();
      // Stock is 10; returning 11 must be rejected.
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: purchase.supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: purchase.items.single.productId,
              returnQuantity: 11,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });

    test('rejects a return when no stock is available', () async {
      final purchase = await seededPurchase();
      // First return consumes all stock.
      await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: purchase.supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: purchase.items.single.productId,
            returnQuantity: 10,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );

      // Second return now has no stock left.
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: purchase.supplierId,
          returnDate: DateTime(2026, 8, 4),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: purchase.items.single.productId,
              returnQuantity: 1,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });

    test('rejects a return exceeding the purchased quantity', () async {
      final purchase = await seededPurchase();
      // Return 8 first.
      await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: purchase.supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: purchase.items.single.productId,
            returnQuantity: 8,
            purchasePrice: 1000,
            taxRate: 0,
          ),
        ],
      );
      // Only 2 remain from the original purchase.
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: purchase.supplierId,
          returnDate: DateTime(2026, 8, 4),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: purchase.items.single.productId,
              returnQuantity: 3,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });

    test('rejects when the supplier does not match the purchase', () async {
      final purchase = await seededPurchase();
      final other = await SupplierRepository().createSupplier(
        supplierName: 'Other Supplies',
        mobile: '1111111111',
      );
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: other.id,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: purchase.items.single.productId,
              returnQuantity: 1,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });

    test('rejects a product not in the original purchase', () async {
      final purchase = await seededPurchase();
      final other = await ProductRepository().createProduct(
        productName: 'Other',
        unitId: 1,
        sellingPrice: 1000,
        purchasePrice: 1000,
      );
      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: purchase.supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: -1,
              productId: other.id,
              returnQuantity: 1,
              purchasePrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<PurchaseReturnValidationException>()),
      );
    });
  });

  group('inventory effect', () {
    test(
      'return reduces stock and records a PURCHASE_RETURN transaction',
      () async {
        final (supplierId, productId) = await seedSupplierAndProduct();
        final purchase = await makePurchase(
          supplierId: supplierId,
          productId: productId,
          quantity: 20,
          purchasePrice: 500,
        );
        expect(await currentStock(productId), 20);

        await PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: productId,
              returnQuantity: 5,
              purchasePrice: 500,
              taxRate: 0,
            ),
          ],
        );

        expect(await currentStock(productId), 15);
        final txns = await returnTransactions(purchase.id);
        expect(txns, hasLength(1));
        expect(txns.single.quantity, -5);
        expect(txns.single.transactionType, 'PURCHASE_RETURN');
      },
    );

    test('full return brings stock to zero', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 10,
        purchasePrice: 500,
      );
      await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 10,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );
      expect(await currentStock(productId), 0);
    });
  });

  group('supplier accounting', () {
    test('return is a Debit that reduces supplier payable', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );
      // Purchase total = 20 × 500 = 10000 → payable +10000.
      expect(await supplierBalance(supplierId), 10000);

      await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );

      // Return 5 × 500 = 2500 Debit → payable 10000 − 2500 = 7500.
      expect(await supplierBalance(supplierId), 7500);
    });
  });

  group('history and listing', () {
    test('returns appear in the history page with correct status', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );

      await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );

      final page = await PurchaseReturnRepository().fetchPage();
      expect(page.totalCount, 1);
      expect(page.items.single.status, PurchaseReturnStatus.completed);
      expect(page.items.single.supplierName, 'Acme Supplies');
      expect(page.items.single.returnNumber, startsWith('PRN-'));
    });

    test(
      'partial returns accumulate but never exceed purchase quantity',
      () async {
        final (supplierId, productId) = await seedSupplierAndProduct();
        final purchase = await makePurchase(
          supplierId: supplierId,
          productId: productId,
          quantity: 20,
          purchasePrice: 500,
        );
        final repo = PurchaseReturnRepository();

        await repo.createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: productId,
              returnQuantity: 5,
              purchasePrice: 500,
              taxRate: 0,
            ),
          ],
        );
        await repo.createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 4),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items.single.id,
              productId: productId,
              returnQuantity: 10,
              purchasePrice: 500,
              taxRate: 0,
            ),
          ],
        );

        expect(await currentStock(productId), 5);
        final page = await repo.fetchPage();
        expect(page.totalCount, 2);

        // A third return of 6 would exceed remaining stock (5).
        expect(
          () => repo.createReturn(
            originalPurchaseId: purchase.id,
            supplierId: supplierId,
            returnDate: DateTime(2026, 8, 5),
            items: [
              PurchaseReturnItemInput(
                purchaseItemId: purchase.items.single.id,
                productId: productId,
                returnQuantity: 6,
                purchasePrice: 500,
                taxRate: 0,
              ),
            ],
          ),
          throwsA(isA<PurchaseReturnValidationException>()),
        );
      },
    );

    test('returnableItemsForPurchase exposes stock and unit prices', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
        taxRate: 5,
      );

      final items = await PurchaseReturnRepository().returnableItemsForPurchase(
        purchase.id,
      );
      expect(items, hasLength(1));
      expect(items.single.currentStock, 20);
      expect(items.single.purchasePrice, 500);
      expect(items.single.taxRate, 5);
      // unitLineTotal = 500 + (500 * 5%) = 525.
      expect(items.single.unitLineTotal, 525);
    });

    test(
      'returnableItemsForPurchase keeps a purchase line visible at zero stock',
      () async {
        final (supplierId, productId) = await seedSupplierAndProduct();
        final purchase = await makePurchase(
          supplierId: supplierId,
          productId: productId,
          quantity: 2,
        );
        final database = DatabaseProvider.instance.database;

        await (database.update(database.currentStocks)..where(
              (t) => t.productId.equals(productId) & t.variantId.isNull(),
            ))
            .write(const db.CurrentStocksCompanion(quantity: Value(0)));

        final items = await PurchaseReturnRepository()
            .returnableItemsForPurchase(purchase.id);

        expect(items, hasLength(1));
        expect(items.single.purchaseItem.id, purchase.items.single.id);
        expect(items.single.currentStock, 0);
      },
    );
  });

  group('revertReturn', () {
    test('reverts stock, Debit, and marks status Reverted', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );
      final repo = PurchaseReturnRepository();
      expect(await supplierBalance(supplierId), 10000);

      final created = await repo.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );

      // After return: stock 15, payable 7500.
      expect(await currentStock(productId), 15);
      expect(await supplierBalance(supplierId), 7500);

      await repo.revertReturn(created.id);

      // Stock restored, payable restored.
      expect(await currentStock(productId), 20);
      expect(await supplierBalance(supplierId), 10000);

      final reloaded = await repo.getById(created.id);
      expect(reloaded.isReverted, isTrue);
      expect(reloaded.status, PurchaseReturnStatus.reverted);
    });

    test('rejects reverting an already-reverted return', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );
      final repo = PurchaseReturnRepository();
      final created = await repo.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );
      await repo.revertReturn(created.id);

      expect(
        () => repo.revertReturn(created.id),
        throwsA(isA<PurchaseReturnOperationException>()),
      );
    });
  });

  group('deleteReturn', () {
    test('permanently removes the return and its line items', () async {
      final (supplierId, productId) = await seedSupplierAndProduct();
      final purchase = await makePurchase(
        supplierId: supplierId,
        productId: productId,
        quantity: 20,
        purchasePrice: 500,
      );
      final repo = PurchaseReturnRepository();
      final created = await repo.createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items.single.id,
            productId: productId,
            returnQuantity: 5,
            purchasePrice: 500,
            taxRate: 0,
          ),
        ],
      );

      await repo.deleteReturn(created.id);

      expect(
        () => repo.getById(created.id),
        throwsA(isA<PurchaseReturnNotFoundException>()),
      );
      final page = await repo.fetchPage();
      expect(page.totalCount, 0);
      // Stock is restored to 20 (deletion reverses the return's business effects).
      expect(await currentStock(productId), 20);
    });
  });

  group('partial return and zero-quantity validation', () {
    Future<(int supplierId, PurchaseEntity purchase, List<int> productIds)>
    seedMultiProductPurchase() async {
      final supplier = await SupplierRepository().createSupplier(
        supplierName: 'Apple India',
        mobile: '9876543210',
      );
      final p1 = await ProductRepository().createProduct(
        productName: 'Parle-G 5',
        unitId: 1,
        sellingPrice: 500,
        purchasePrice: 400,
      );
      final p2 = await ProductRepository().createProduct(
        productName: 'M4 Air',
        unitId: 1,
        sellingPrice: 100000,
        purchasePrice: 80000,
      );
      final p3 = await ProductRepository().createProduct(
        productName: 'M4 Pro',
        unitId: 1,
        sellingPrice: 180000,
        purchasePrice: 150000,
      );

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: p1.id,
            quantity: 20,
            unitId: 1,
            purchasePrice: 400,
            discount: 0,
            taxRate: 0,
          ),
          PurchaseItemInput(
            productId: p2.id,
            quantity: 2,
            unitId: 1,
            purchasePrice: 80000,
            discount: 0,
            taxRate: 0,
          ),
          PurchaseItemInput(
            productId: p3.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 150000,
            discount: 0,
            taxRate: 0,
          ),
        ],
      );

      return (supplier.id, purchase, [p1.id, p2.id, p3.id]);
    }

    test('1. One item returned, remaining items qty = 0 -> PASS', () async {
      final (supplierId, purchase, productIds) =
          await seedMultiProductPurchase();

      final returnEntity = await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[0].id,
            productId: productIds[0],
            returnQuantity: 5,
            purchasePrice: 400,
            taxRate: 0,
          ),
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[1].id,
            productId: productIds[1],
            returnQuantity: 0,
            purchasePrice: 80000,
            taxRate: 0,
          ),
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[2].id,
            productId: productIds[2],
            returnQuantity: 0,
            purchasePrice: 150000,
            taxRate: 0,
          ),
        ],
      );

      expect(returnEntity.items, hasLength(1));
      expect(returnEntity.items.single.productId, productIds[0]);
      expect(returnEntity.items.single.returnQuantity, 5);
      expect(returnEntity.total, 2000); // 5 * 400
    });

    test('2. Two items returned, remaining items qty = 0 -> PASS', () async {
      final (supplierId, purchase, productIds) =
          await seedMultiProductPurchase();

      final returnEntity = await PurchaseReturnRepository().createReturn(
        originalPurchaseId: purchase.id,
        supplierId: supplierId,
        returnDate: DateTime(2026, 8, 3),
        items: [
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[0].id,
            productId: productIds[0],
            returnQuantity: 5,
            purchasePrice: 400,
            taxRate: 0,
          ),
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[1].id,
            productId: productIds[1],
            returnQuantity: 1,
            purchasePrice: 80000,
            taxRate: 0,
          ),
          PurchaseReturnItemInput(
            purchaseItemId: purchase.items[2].id,
            productId: productIds[2],
            returnQuantity: 0,
            purchasePrice: 150000,
            taxRate: 0,
          ),
        ],
      );

      expect(returnEntity.items, hasLength(2));
      expect(returnEntity.total, 5 * 400 + 1 * 80000);
    });

    test('3. All items qty = 0 -> FAIL', () async {
      final (supplierId, purchase, productIds) =
          await seedMultiProductPurchase();

      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[0].id,
              productId: productIds[0],
              returnQuantity: 0,
              purchasePrice: 400,
              taxRate: 0,
            ),
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[1].id,
              productId: productIds[1],
              returnQuantity: 0,
              purchasePrice: 80000,
              taxRate: 0,
            ),
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[2].id,
              productId: productIds[2],
              returnQuantity: 0,
              purchasePrice: 150000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(
          isA<PurchaseReturnValidationException>().having(
            (e) => e.message,
            'message',
            'Please enter a return quantity for at least one product.',
          ),
        ),
      );
    });

    test('4. Negative quantity -> FAIL', () async {
      final (supplierId, purchase, productIds) =
          await seedMultiProductPurchase();

      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[0].id,
              productId: productIds[0],
              returnQuantity: -1,
              purchasePrice: 400,
              taxRate: 0,
            ),
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[1].id,
              productId: productIds[1],
              returnQuantity: 1,
              purchasePrice: 80000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(
          isA<PurchaseReturnValidationException>().having(
            (e) => e.message,
            'message',
            'Return quantity cannot be negative.',
          ),
        ),
      );
    });

    test('5. Quantity greater than current stock -> FAIL', () async {
      final (supplierId, purchase, productIds) =
          await seedMultiProductPurchase();

      expect(
        () => PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[0].id,
              productId: productIds[0],
              returnQuantity: 25, // stock is 20
              purchasePrice: 400,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(
          isA<PurchaseReturnValidationException>().having(
            (e) => e.message,
            'message',
            contains('cannot exceed available stock'),
          ),
        ),
      );
    });

    test(
      '6 & 7 & FINAL EXPECTED EXAMPLE: Multiple products where only one has qty > 0',
      () async {
        final (supplierId, purchase, productIds) =
            await seedMultiProductPurchase();

        // Initial check: stock for all 3
        expect(await currentStock(productIds[0]), 20);
        expect(await currentStock(productIds[1]), 2);
        expect(await currentStock(productIds[2]), 1);

        // Initial supplier balance = 20*400 + 2*80000 + 1*150000 = 8000 + 160000 + 150000 = 318000
        final initialSupplierBalance = await supplierBalance(supplierId);
        expect(initialSupplierBalance, 318000);

        final returnEntity = await PurchaseReturnRepository().createReturn(
          originalPurchaseId: purchase.id,
          supplierId: supplierId,
          returnDate: DateTime(2026, 8, 3),
          items: [
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[0].id,
              productId: productIds[0],
              returnQuantity: 5,
              purchasePrice: 400,
              taxRate: 0,
            ),
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[1].id,
              productId: productIds[1],
              returnQuantity: 0,
              purchasePrice: 80000,
              taxRate: 0,
            ),
            PurchaseReturnItemInput(
              purchaseItemId: purchase.items[2].id,
              productId: productIds[2],
              returnQuantity: 0,
              purchasePrice: 150000,
              taxRate: 0,
            ),
          ],
        );

        // 6. Only Parle-G 5 appears in the Purchase Return items
        expect(returnEntity.items, hasLength(1));
        expect(returnEntity.items.single.productId, productIds[0]);
        expect(returnEntity.items.single.returnQuantity, 5);

        // 7. Verify zero-quantity products do not:
        // - create return-item records
        final database = DatabaseProvider.instance.database;
        final returnItemsInDb = await (database.select(
          database.purchaseReturnItems,
        )..where((t) => t.purchaseReturnId.equals(returnEntity.id))).get();
        expect(returnItemsInDb, hasLength(1));
        expect(returnItemsInDb.single.purchaseItemId, purchase.items[0].id);

        // - reduce inventory
        expect(await currentStock(productIds[0]), 15); // -5
        expect(await currentStock(productIds[1]), 2); // no change
        expect(await currentStock(productIds[2]), 1); // no change

        // - affect supplier Debit / return total
        expect(returnEntity.subtotal, 2000); // only 5 * 400
        expect(returnEntity.total, 2000);
        // Supplier balance: 318000 - 2000 = 316000
        expect(await supplierBalance(supplierId), 316000);

        // Only 1 inventory transaction recorded
        final txns = await returnTransactions(purchase.id);
        expect(txns, hasLength(1));
        expect(txns.single.productId, productIds[0]);
        expect(txns.single.quantity, -5);
      },
    );

    test('returnableItemsForPurchase loads ALL purchase items for 2 products and products with variants', () async {
      final supplier = await SupplierRepository().createSupplier(
        supplierName: 'Apple Distributor',
        mobile: '9876543210',
      );
      final p1 = await ProductRepository().createProduct(
        productName: 'M4 Air',
        unitId: 1,
        sellingPrice: 120000,
        purchasePrice: 100000,
        barcode: 'BAR-M4',
      );
      final p2 = await ProductRepository().createProduct(
        productName: 'Parle-G 5',
        unitId: 1,
        sellingPrice: 500,
        purchasePrice: 400,
        barcode: 'BAR-PG5',
      );
      final p3 = await ProductRepository().createProduct(
        productName: 'iPhone 16',
        unitId: 1,
        sellingPrice: 80000,
        purchasePrice: 70000,
        variants: [
          const VariantInput(
            variantName: '128GB',
            sellingPrice: 80000,
            purchasePrice: 70000,
            barcode: 'IPH-128',
          ),
          const VariantInput(
            variantName: '256GB',
            sellingPrice: 90000,
            purchasePrice: 80000,
            barcode: 'IPH-256',
          ),
        ],
      );

      final purchase = await PurchaseRepository().createPurchase(
        supplierId: supplier.id,
        purchaseDate: DateTime(2026, 8, 1),
        paidAmount: 0,
        items: [
          PurchaseItemInput(
            productId: p1.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 100000,
            discount: 5000,
            taxRate: 18,
          ),
          PurchaseItemInput(
            productId: p2.id,
            quantity: 1,
            unitId: 1,
            purchasePrice: 400,
            discount: 0,
            taxRate: 5,
          ),
          PurchaseItemInput(
            productId: p3.id,
            variantId: p3.variants[0].id,
            quantity: 2,
            unitId: 1,
            purchasePrice: 70000,
            discount: 0,
            taxRate: 18,
          ),
          PurchaseItemInput(
            productId: p3.id,
            variantId: p3.variants[1].id,
            quantity: 3,
            unitId: 1,
            purchasePrice: 80000,
            discount: 0,
            taxRate: 18,
          ),
        ],
      );

      final returnableItems = await PurchaseReturnRepository().returnableItemsForPurchase(
        purchase.id,
      );

      // Must return ALL 4 items
      expect(returnableItems, hasLength(4));
      expect(returnableItems[0].purchaseItem.productName, 'M4 Air');
      expect(returnableItems[0].purchaseItem.barcode, 'BAR-M4');
      expect(returnableItems[0].purchaseItem.quantity, 1);

      expect(returnableItems[1].purchaseItem.productName, 'Parle-G 5');
      expect(returnableItems[1].purchaseItem.barcode, 'BAR-PG5');
      expect(returnableItems[1].purchaseItem.quantity, 1);

      expect(returnableItems[2].purchaseItem.productName, 'iPhone 16');
      expect(returnableItems[2].purchaseItem.variantName, '128GB');
      expect(returnableItems[2].purchaseItem.barcode, 'IPH-128');

      expect(returnableItems[3].purchaseItem.productName, 'iPhone 16');
      expect(returnableItems[3].purchaseItem.variantName, '256GB');
      expect(returnableItems[3].purchaseItem.barcode, 'IPH-256');
    });
  });
}
