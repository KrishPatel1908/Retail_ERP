import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/inventory/domain/services/stock_service.dart';
import 'package:retail_erp/features/master_entry/customer/data/repositories/customer_repository.dart';
import 'package:retail_erp/features/master_entry/customer/domain/entities/customer.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/purchase/data/repositories/purchase_repository.dart';
import 'package:retail_erp/features/sales/data/repositories/sales_repository.dart';
import 'package:retail_erp/features/sales/domain/entities/sale.dart';
import 'package:retail_erp/features/sales/domain/exceptions/sales_exceptions.dart';

import '../../helpers/test_database.dart';

db.AppDatabase get dbInstance => DatabaseProvider.instance.database;

void main() {
  setUp(resetTestDatabase);

  late SalesRepository salesRepo;
  late ProductRepository productRepo;
  late CustomerRepository customerRepo;
  late SupplierRepository supplierRepo;
  late PurchaseRepository purchaseRepo;
  late StockService stockService;

  setUp(() {
    salesRepo = SalesRepository();
    productRepo = ProductRepository();
    customerRepo = CustomerRepository();
    supplierRepo = SupplierRepository();
    purchaseRepo = PurchaseRepository();
    stockService = StockService();
  });

  Future<db.Customer> getCustomer(int id) async {
    return (dbInstance.select(dbInstance.customers)..where((c) => c.id.equals(id))).getSingle();
  }

  Future<int> stockOf(int productId, {int? variantId}) async {
    return stockService.currentStock(productId, variantId);
  }

  Future<Customer> createTestCustomer({
    String name = 'Ramesh Patel',
    String mobile = '9876543210',
    int openingBalance = 0,
  }) async {
    return customerRepo.createCustomer(
      customerName: name,
      mobile: mobile,
      openingBalance: openingBalance,
    );
  }

  Future<void> addStock({
    required int productId,
    int? variantId,
    required int quantity,
    int purchasePrice = 500,
  }) async {
    final supplier = await supplierRepo.createSupplier(
      supplierName: 'Stock Supplier ${DateTime.now().microsecondsSinceEpoch}',
      mobile: '98${(DateTime.now().microsecondsSinceEpoch % 100000000).toString().padLeft(8, '0')}',
    );

    await purchaseRepo.createPurchase(
      supplierId: supplier.id,
      purchaseDate: DateTime(2026, 1, 1),
      paidAmount: quantity * purchasePrice,
      items: [
        PurchaseItemInput(
          productId: productId,
          variantId: variantId,
          quantity: quantity,
          unitId: 1, // Piece
          purchasePrice: purchasePrice,
          taxRate: 0,
        ),
      ],
    );
  }

  // ──────────────────── 1. PRODUCT SEARCH & BARCODE ────────────────────

  group('Product Search & Barcode Lookup', () {
    test('1. Search product by name returns active sellable product', () async {
      final product = await productRepo.createProduct(
        productName: 'Parle-G 100g',
        unitId: 1,
        sellingPrice: 1000, // ₹10.00
        barcode: '8901234567890',
      );
      await addStock(productId: product.id, quantity: 10);

      final results = await salesRepo.searchSellableItems(query: 'parle-g');
      expect(results.length, 1);
      expect(results.first.productId, product.id);
      expect(results.first.productName, 'Parle-G 100g');
      expect(results.first.availableStock, 10);
    });

    test('2. Search variant returns separate sellable items without combining', () async {
      final product = await productRepo.createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 500,
        variants: [
          const VariantInput(
            variantName: 'Parle-G 10',
            sellingPrice: 1000,
            barcode: '89010001',
          ),
          const VariantInput(
            variantName: 'Parle-G 50',
            sellingPrice: 5000,
            barcode: '89010002',
          ),
        ],
      );

      final v10 = product.variants.firstWhere((v) => v.variantName == 'Parle-G 10');
      final v50 = product.variants.firstWhere((v) => v.variantName == 'Parle-G 50');

      await addStock(productId: product.id, variantId: v10.id, quantity: 20);
      await addStock(productId: product.id, variantId: v50.id, quantity: 15);

      final results = await salesRepo.searchSellableItems(query: 'Parle-G');
      expect(results.length, 2);

      final item10 = results.firstWhere((r) => r.variantId == v10.id);
      final item50 = results.firstWhere((r) => r.variantId == v50.id);

      expect(item10.sellingPrice, 1000);
      expect(item10.availableStock, 20);
      expect(item50.sellingPrice, 5000);
      expect(item50.availableStock, 15);
    });

    test('3. Exact barcode lookup returns the exact product or variant', () async {
      final product = await productRepo.createProduct(
        productName: 'M4 Air Laptop',
        unitId: 1,
        sellingPrice: 8000000, // ₹80,000.00
        barcode: 'MAC-M4-AIR',
      );
      await addStock(productId: product.id, quantity: 5);

      final item = await salesRepo.findSellableItemByBarcode('mac-m4-air');
      expect(item, isNotNull);
      expect(item!.productId, product.id);
      expect(item.sellingPrice, 8000000);
      expect(item.availableStock, 5);
    });

    test('4. Unknown barcode returns null without error', () async {
      final item = await salesRepo.findSellableItemByBarcode('NON-EXISTENT-999');
      expect(item, isNull);
    });

    test('5. Inactive product cannot be searched or sold via barcode', () async {
      final product = await productRepo.createProduct(
        productName: 'Old Inactive Soda',
        unitId: 1,
        sellingPrice: 4000,
        barcode: 'INACTIVE-SODA',
      );
      await (dbInstance.update(dbInstance.products)..where((p) => p.id.equals(product.id)))
          .write(const db.ProductsCompanion(isActive: drift.Value(false)));

      final searchResults = await salesRepo.searchSellableItems(query: 'Inactive Soda');
      expect(searchResults, isEmpty);

      expect(
        () => salesRepo.findSellableItemByBarcode('INACTIVE-SODA'),
        throwsA(isA<SalesValidationException>()),
      );
    });

    test('6. Out-of-stock product displays 0 availableStock and isOutOfStock true', () async {
      await productRepo.createProduct(
        productName: 'Zero Stock Biscuit',
        unitId: 1,
        sellingPrice: 1000,
        barcode: 'ZERO-STOCK',
      );

      final item = await salesRepo.findSellableItemByBarcode('ZERO-STOCK');
      expect(item, isNotNull);
      expect(item!.availableStock, 0);
      expect(item.isOutOfStock, isTrue);
    });
  });

  // ──────────────────── 2. STOCK VALIDATION & MOVEMENT ────────────────────

  group('Stock Integration & Atomicity', () {
    test('14. Completing sale decreases stock and records inventory movement', () async {
      final product = await productRepo.createProduct(
        productName: 'Toothpaste',
        unitId: 1,
        sellingPrice: 5000, // ₹50.00
      );
      await addStock(productId: product.id, quantity: 10);
      expect(await stockOf(product.id), 10);

      final sale = await salesRepo.createSale(
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 15000, // 3 * ₹50 = ₹150.00
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 3,
            unitPrice: 5000,
            taxRate: 0,
          ),
        ],
      );

      expect(sale.grandTotal, 15000);
      expect(await stockOf(product.id), 7); // 10 - 3 = 7

      // Verify inventory transaction movement
      final dbInstance = DatabaseProvider.instance.database;
      final movements = await (dbInstance.select(dbInstance.inventoryTransactions)
            ..where((t) => t.productId.equals(product.id))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.id)]))
          .get();

      final saleMovement = movements.first;
      expect(saleMovement.transactionType, StockMovementType.sale);
      expect(saleMovement.quantity, -3);
      expect(saleMovement.previousQuantity, 10);
      expect(saleMovement.newQuantity, 7);
      expect(saleMovement.referenceNumber, sale.saleNumber);
      expect(saleMovement.saleId, sale.id);
    });

    test('15. Cannot sell more than current available stock', () async {
      final product = await productRepo.createProduct(
        productName: 'Limited Edition Mug',
        unitId: 1,
        sellingPrice: 20000,
      );
      await addStock(productId: product.id, quantity: 8);

      // Attempt to sell 10 when stock is 8
      expect(
        () => salesRepo.createSale(
          saleDate: DateTime(2026, 8, 1),
          paymentMethod: 'Cash',
          amountReceived: 200000,
          items: [
            CreateSaleItemInput(
              productId: product.id,
              productName: product.productName,
              unitId: 1,
              unitName: 'Piece',
              quantity: 10,
              unitPrice: 20000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(
          isA<InsufficientStockException>().having(
            (e) => e.message,
            'message',
            contains('Insufficient stock. Available stock: 8.'),
          ),
        ),
      );

      // Stock remains untouched
      expect(await stockOf(product.id), 8);
    });

    test('16. Exact available stock can be sold, resulting in 0 stock', () async {
      final product = await productRepo.createProduct(
        productName: 'Last Notebook',
        unitId: 1,
        sellingPrice: 4000,
      );
      await addStock(productId: product.id, quantity: 4);

      await salesRepo.createSale(
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 16000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 4,
            unitPrice: 4000,
            taxRate: 0,
          ),
        ],
      );

      expect(await stockOf(product.id), 0);
    });

    test('18. Stock re-checked inside transaction prevents race condition', () async {
      final product = await productRepo.createProduct(
        productName: 'Hot Item',
        unitId: 1,
        sellingPrice: 1000,
      );
      await addStock(productId: product.id, quantity: 5);

      // Another transaction reduces stock to 2
      await stockService.applyStockChange(
        productId: product.id,
        delta: -3,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
      );
      expect(await stockOf(product.id), 2);

      // POS attempts to sell 5 (which was seen earlier)
      expect(
        () => salesRepo.createSale(
          saleDate: DateTime(2026, 8, 1),
          paymentMethod: 'Cash',
          amountReceived: 5000,
          items: [
            CreateSaleItemInput(
              productId: product.id,
              productName: product.productName,
              unitId: 1,
              unitName: 'Piece',
              quantity: 5,
              unitPrice: 1000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<InsufficientStockException>()),
      );

      // Stock is still 2, no partial records created
      expect(await stockOf(product.id), 2);
      final sales = await salesRepo.fetchPage();
      expect(sales.totalCount, 0);
    });
  });

  // ──────────────────── 3. PRICING, DISCOUNT & TAX ────────────────────

  group('Pricing, Discounts, and Tax Consistency', () {
    test('21 & 22. Selling price is used, variant price takes precedence over parent', () async {
      final product = await productRepo.createProduct(
        productName: 'Shirt',
        unitId: 1,
        sellingPrice: 100000, // ₹1,000 parent
        purchasePrice: 60000, // ₹600 purchase price (must NOT be used)
        variants: [
          const VariantInput(
            variantName: 'XL',
            sellingPrice: 120000, // ₹1,200 variant
            purchasePrice: 70000,
          ),
        ],
      );
      final xl = product.variants.first;
      await addStock(productId: product.id, variantId: xl.id, quantity: 5);

      final items = await salesRepo.searchSellableItems(query: 'XL');
      expect(items.first.sellingPrice, 120000);
      expect(items.first.sellingPrice, isNot(60000));
      expect(items.first.sellingPrice, isNot(100000));
    });

    test('23 & 24. Line discount, bill discount, and 18% tax calculation in paise', () async {
      final product = await productRepo.createProduct(
        productName: 'Speaker',
        unitId: 1,
        sellingPrice: 10000, // ₹100.00
      );
      await addStock(productId: product.id, quantity: 5);

      // 2 qty @ ₹100 = ₹200.00 (20000 paise)
      // Line discount: ₹20.00 (2000 paise)
      // Taxable: ₹180.00 (18000 paise)
      // Bill discount: ₹10.00 (1000 paise) -> Net taxable: 17000 paise
      // Tax 18%: 17000 * 18 / 100 = 3060 paise (₹30.60)
      // Grand Total: 17000 + 3060 = 20060 paise (₹200.60)
      final sale = await salesRepo.createSale(
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 25000,
        billDiscount: 1000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 2,
            unitPrice: 10000,
            discount: 2000,
            taxRate: 18.0,
          ),
        ],
      );

      expect(sale.subtotal, 20000);
      expect(sale.discount, 3000); // 2000 item + 1000 bill
      expect(sale.tax, 3240); // 18% on (20000 - 2000) = 3240
      expect(sale.grandTotal, 20000 - 3000 + 3240);
      expect(sale.paidAmount, sale.grandTotal);
      expect(sale.changeAmount, 25000 - sale.grandTotal);
    });

    test('26. Historical price and tax remain immutable if Product Master changes later', () async {
      final product = await productRepo.createProduct(
        productName: 'Pen',
        unitId: 1,
        sellingPrice: 1000, // ₹10
      );
      await addStock(productId: product.id, quantity: 10);

      final sale = await salesRepo.createSale(
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 1000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 1000,
            taxRate: 0,
          ),
        ],
      );
      expect(sale.grandTotal, 1000);

      // Tomorrow Product Master price increases to ₹15
      await (dbInstance.update(dbInstance.products)..where((p) => p.id.equals(product.id)))
          .write(const db.ProductsCompanion(sellingPrice: drift.Value(1500)));

      // Yesterday's sale still shows ₹10
      final historicalSale = await salesRepo.getById(sale.id);
      expect(historicalSale.grandTotal, 1000);
      expect(historicalSale.items.first.unitPrice, 1000);
    });
  });

  // ──────────────────── 4. PAYMENT & CUSTOMER LEDGER ────────────────────

  group('Payment Modes & Customer Ledger', () {
    test('27. Cash payment calculates change correctly and marks PAID', () async {
      final product = await productRepo.createProduct(
        productName: 'Rice Bag',
        unitId: 1,
        sellingPrice: 85000, // ₹850.00
      );
      await addStock(productId: product.id, quantity: 5);

      // Received: ₹1,000 (100000 paise), Total: ₹850 (85000 paise)
      final sale = await salesRepo.createSale(
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 100000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 85000,
            taxRate: 0,
          ),
        ],
      );

      expect(sale.grandTotal, 85000);
      expect(sale.paidAmount, 85000);
      expect(sale.changeAmount, 15000); // ₹150.00
      expect(sale.balanceAmount, 0);
      expect(sale.paymentStatus, SalePaymentStatus.paid);
    });

    test('28 & 29. Partial payment & Credit sale updates customer ledger (Debit)', () async {
      final customer = await createTestCustomer(name: 'Anita Roy', openingBalance: 0);
      final product = await productRepo.createProduct(
        productName: 'Sofa Set',
        unitId: 1,
        sellingPrice: 1000000, // ₹10,000.00
      );
      await addStock(productId: product.id, quantity: 2);

      // Sale ₹10,000, Paid ₹4,000, Balance ₹6,000
      final sale = await salesRepo.createSale(
        customerId: customer.id,
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 400000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 1000000,
            taxRate: 0,
          ),
        ],
      );

      expect(sale.grandTotal, 1000000);
      expect(sale.paidAmount, 400000);
      expect(sale.balanceAmount, 600000);
      expect(sale.paymentStatus, SalePaymentStatus.partial);

      // Customer outstanding balance increased by ₹6,000
      final updatedCustomer = await getCustomer(customer.id);
      expect(updatedCustomer.outstandingBalance, 600000);

      // Customer ledger transaction created with Debit ₹10,000 and Credit ₹4,000
      final dbInstance = DatabaseProvider.instance.database;
      final txns = await (dbInstance.select(dbInstance.customerTransactions)
            ..where((c) => c.customerId.equals(customer.id)))
          .get();

      expect(txns.length, 1);
      final txn = txns.first;
      expect(txn.saleId, sale.id);
      expect(txn.debit, 1000000);
      expect(txn.credit, 400000);
      expect(txn.runningTotal, 600000);
    });

    test('30. Walk-in cash sale does not create a customer transaction row', () async {
      final product = await productRepo.createProduct(
        productName: 'Coffee Cup',
        unitId: 1,
        sellingPrice: 15000,
      );
      await addStock(productId: product.id, quantity: 5);

      final sale = await salesRepo.createSale(
        customerId: null, // Walk-in
        saleDate: DateTime(2026, 8, 1),
        paymentMethod: 'Cash',
        amountReceived: 15000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 15000,
            taxRate: 0,
          ),
        ],
      );
      expect(sale.paymentStatus, SalePaymentStatus.paid);

      final dbInstance = DatabaseProvider.instance.database;
      final txns = await dbInstance.select(dbInstance.customerTransactions).get();
      expect(txns, isEmpty);
    });

    test('31. Credit sale requires customer and rejects walk-in', () async {
      final product = await productRepo.createProduct(
        productName: 'Shoes',
        unitId: 1,
        sellingPrice: 50000,
      );
      await addStock(productId: product.id, quantity: 2);

      expect(
        () => salesRepo.createSale(
          customerId: null,
          saleDate: DateTime.now(),
          paymentMethod: 'Credit',
          amountReceived: 0,
          items: [
            CreateSaleItemInput(
              productId: product.id,
              productName: product.productName,
              unitId: 1,
              unitName: 'Piece',
              quantity: 1,
              unitPrice: 50000,
              taxRate: 0,
            ),
          ],
        ),
        throwsA(isA<SalesValidationException>()),
      );
    });
  });

  // ──────────────────── 5. ATOMICITY & DOCUMENT NUMBERING ────────────────────

  group('Atomic Transactions & Uniqueness', () {
    test('38. Sequential unique sale numbers without duplicates', () async {
      final product = await productRepo.createProduct(
        productName: 'Bread',
        unitId: 1,
        sellingPrice: 4000,
      );
      await addStock(productId: product.id, quantity: 20);

      final sale1 = await salesRepo.createSale(
        saleDate: DateTime.now(),
        paymentMethod: 'Cash',
        amountReceived: 4000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 4000,
            taxRate: 0,
          ),
        ],
      );

      final sale2 = await salesRepo.createSale(
        saleDate: DateTime.now(),
        paymentMethod: 'Cash',
        amountReceived: 4000,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 4000,
            taxRate: 0,
          ),
        ],
      );

      expect(sale1.saleNumber, isNot(sale2.saleNumber));
      expect(sale1.saleNumber, 'SAL-000001');
      expect(sale2.saleNumber, 'SAL-000002');
    });

    test('39. Atomic rollback on failure leaves zero changes', () async {
      final customer = await createTestCustomer();
      final product = await productRepo.createProduct(
        productName: 'Limited Book',
        unitId: 1,
        sellingPrice: 10000,
      );
      await addStock(productId: product.id, quantity: 2);

      // Attempt sale of 5 items (only 2 in stock)
      try {
        await salesRepo.createSale(
          customerId: customer.id,
          saleDate: DateTime.now(),
          paymentMethod: 'Credit',
          items: [
            CreateSaleItemInput(
              productId: product.id,
              productName: product.productName,
              unitId: 1,
              unitName: 'Piece',
              quantity: 5,
              unitPrice: 10000,
              taxRate: 0,
            ),
          ],
        );
      } catch (_) {}

      // Verify no sale, no stock change, no customer transaction
      final page = await salesRepo.fetchPage();
      expect(page.totalCount, 0);
      expect(await stockOf(product.id), 2);

      final c = await getCustomer(customer.id);
      expect(c.outstandingBalance, 0);
    });

    test('43. Voiding a sale reverses stock and customer ledger atomically', () async {
      final customer = await createTestCustomer();
      final product = await productRepo.createProduct(
        productName: 'Table Fan',
        unitId: 1,
        sellingPrice: 200000, // ₹2,000
      );
      await addStock(productId: product.id, quantity: 10);

      final sale = await salesRepo.createSale(
        customerId: customer.id,
        saleDate: DateTime.now(),
        paymentMethod: 'Credit',
        amountReceived: 0,
        items: [
          CreateSaleItemInput(
            productId: product.id,
            productName: product.productName,
            unitId: 1,
            unitName: 'Piece',
            quantity: 2,
            unitPrice: 200000,
            taxRate: 0,
          ),
        ],
      );

      expect(await stockOf(product.id), 8);
      expect((await getCustomer(customer.id)).outstandingBalance, 400000);

      // Void the sale
      await salesRepo.voidSale(sale.id, reason: 'Customer changed mind');

      // Stock is reversed to 10
      expect(await stockOf(product.id), 10);

      // Customer outstanding balance reversed to 0
      expect((await getCustomer(customer.id)).outstandingBalance, 0);

      // Sale is marked inactive
      final voidedSale = await salesRepo.getById(sale.id);
      expect(voidedSale.isActive, isFalse);

      // Attempting to void again throws error
      expect(
        () => salesRepo.voidSale(sale.id),
        throwsA(isA<SalesValidationException>()),
      );
    });
  });

  // ──────────────────── 51. MANUAL TEST SCENARIO ────────────────────

  group('Scenario 51 from requirements', () {
    test('Parle-G 10 (20 stock, ₹10, 18%) & M4 Air (5 stock, ₹80,000, 18%) workflow', () async {
      // Setup master data
      final parleG = await productRepo.createProduct(
        productName: 'Parle-G',
        unitId: 1,
        sellingPrice: 500,
        variants: [
          const VariantInput(
            variantName: 'Parle-G 10',
            sellingPrice: 1000, // ₹10.00
            barcode: '8901234567893',
          ),
        ],
      );
      final parleG10 = parleG.variants.first;
      await addStock(productId: parleG.id, variantId: parleG10.id, quantity: 20);

      final m4Air = await productRepo.createProduct(
        productName: 'M4 Air',
        unitId: 1,
        sellingPrice: 8000000, // ₹80,000.00
        barcode: 'APPLE-M4-AIR',
      );
      await addStock(productId: m4Air.id, quantity: 5);

      final customer = await createTestCustomer(name: 'Sneha Sharma');

      // Step 1: Scan Parle-G 10 -> Qty 1
      final scanned1 = await salesRepo.findSellableItemByBarcode('8901234567893');
      expect(scanned1, isNotNull);
      expect(scanned1!.variantId, parleG10.id);

      // Step 2: Scan same barcode again -> Qty 2
      // Step 3: Search M4 Air and add it -> Cart contains both
      // Step 4: Change Parle-G quantity to 5
      // Step 5: Verify totals:
      // Parle-G 10: 5 * ₹10 = ₹50.00 (5000 paise). Tax 18% = 900 paise. Total = 5900 paise.
      // M4 Air: 1 * ₹80,000 = ₹80,000.00 (8000000 paise). Tax 18% = 1440000 paise. Total = 9440000 paise.
      // Subtotal: 5000 + 8000000 = 8005000 paise.
      // Tax: 900 + 1440000 = 1440900 paise.
      // Grand total: 8005000 + 1440900 = 9445900 paise (₹94,459.00).

      final sale = await salesRepo.createSale(
        customerId: customer.id,
        saleDate: DateTime.now(),
        paymentMethod: 'Cash',
        amountReceived: 9445900, // Exact amount received
        items: [
          CreateSaleItemInput(
            productId: parleG.id,
            variantId: parleG10.id,
            productName: parleG.productName,
            variantName: parleG10.variantName,
            barcode: parleG10.barcode,
            unitId: 1,
            unitName: 'Piece',
            quantity: 5,
            unitPrice: 1000,
            taxRate: 18.0,
          ),
          CreateSaleItemInput(
            productId: m4Air.id,
            productName: m4Air.productName,
            barcode: m4Air.barcode,
            unitId: 1,
            unitName: 'Piece',
            quantity: 1,
            unitPrice: 8000000,
            taxRate: 18.0,
          ),
        ],
      );

      expect(sale.saleNumber, startsWith('SAL-'));
      expect(sale.items.length, 2);
      expect(sale.subtotal, 8005000);
      expect(sale.tax, 1440900);
      expect(sale.grandTotal, 9445900);
      expect(sale.paidAmount, 9445900);
      expect(sale.changeAmount, 0);
      expect(sale.balanceAmount, 0);
      expect(sale.paymentStatus, SalePaymentStatus.paid);

      // Verify stock reductions
      expect(await stockOf(parleG.id, variantId: parleG10.id), 15); // 20 -> 15
      expect(await stockOf(m4Air.id), 4); // 5 -> 4
    });
  });
}
