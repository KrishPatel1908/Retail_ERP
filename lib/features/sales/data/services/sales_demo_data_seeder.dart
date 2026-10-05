import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/database_provider.dart';
import '../../../inventory/domain/services/stock_service.dart';

/// Reusable development and demo data seeder for Sales POS.
///
/// Seeds deterministic sample categories, products, variants, and stock
/// so developers and cashiers can immediately test POS searching, barcode scanning,
/// category filtering, variant handling, and checkout without manual entry.
///
/// Completely idempotent: verifies existing product codes before inserting,
/// uses deterministic barcodes, and applies stock movements through the canonical
/// [StockService] domain path.
class SalesDemoDataSeeder {
  SalesDemoDataSeeder({
    db.AppDatabase? database,
    StockService? stockService,
  })  : _database = database ?? DatabaseProvider.instance.database,
        _stockService = stockService ?? StockService(database: database);

  final db.AppDatabase _database;
  final StockService _stockService;

  static const String demoMarkerCode = 'DEMO-M4-AIR';

  /// Returns true if the demo products have already been seeded.
  Future<bool> isSeeded() async {
    final existing = await (_database.select(_database.products)
          ..where((t) => t.productCode.equals(demoMarkerCode)))
        .getSingleOrNull();
    return existing != null;
  }

  /// Seeds sample categories, products, variants, and stock idempotently.
  Future<void> seedDemoData({bool force = false}) async {
    if (!force && await isSeeded()) {
      return; // Already seeded, skip to avoid duplicate records.
    }

    await _database.transaction(() async {
      // 1. Categories
      final catElectronics = await _getOrCreateCategory('Electronics', 'Electronic devices and gadgets');
      final catGrocery = await _getOrCreateCategory('Grocery', 'Daily food and grocery items');
      final catBeverages = await _getOrCreateCategory('Beverages', 'Refreshing drinks and juices');
      final catPersonalCare = await _getOrCreateCategory('Personal Care', 'Soaps, shampoos and hygiene');
      final catStationery = await _getOrCreateCategory('Stationery', 'Office supplies and stationery');

      // Default unit (Piece = 1) and Brand (Generic = 1)
      final defaultUnit = await (_database.select(_database.units)..limit(1)).getSingleOrNull();
      final defaultUnitId = defaultUnit?.id ?? 1;

      final defaultBrand = await (_database.select(_database.brands)..limit(1)).getSingleOrNull();
      final defaultBrandId = defaultBrand?.id ?? 1;

      final gst18 = await (_database.select(_database.taxCategories)
            ..where((t) => t.taxCategoryCode.equals('GST-18')))
          .getSingleOrNull();
      final gst18Id = gst18?.id;

      final gst5 = await (_database.select(_database.taxCategories)
            ..where((t) => t.taxCategoryCode.equals('GST-5')))
          .getSingleOrNull();
      final gst5Id = gst5?.id;

      // 2. Products & Variants Setup
      // Product 1: M4 Air with Variant: M4 Pro (₹120,000)
      final m4AirId = await _insertProduct(
        code: demoMarkerCode,
        name: 'M4 Air',
        categoryId: catElectronics,
        brandId: defaultBrandId,
        unitId: defaultUnitId,
        taxCategoryId: gst18Id,
        sellingPricePaise: 9990000, // ₹99,900
        barcode: 'DEMO-M4-AIR',
        hsnCode: '8471',
      );
      final m4ProVariantId = await _insertVariant(
        productId: m4AirId,
        name: 'M4 Pro',
        sellingPricePaise: 12000000, // ₹120,000
        barcode: 'DEMO-M4-PRO',
        hsnCode: '8471',
      );
      await _stockService.applyStockChange(
        productId: m4AirId,
        variantId: m4ProVariantId,
        delta: 9999,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
        note: 'Initial Demo Stock for M4 Air (M4 Pro)',
      );

      // Product 2: Parle-G 5 with Variants: Parle-G 10 (₹10) and Parle-G 50 (₹50)
      final parleGId = await _insertProduct(
        code: 'DEMO-PARLE-G',
        name: 'Parle-G 5',
        categoryId: catGrocery,
        brandId: defaultBrandId,
        unitId: defaultUnitId,
        taxCategoryId: gst5Id,
        sellingPricePaise: 500, // ₹5
        barcode: 'DEMO-PARLE-5',
        hsnCode: '1905',
      );
      final parle10Id = await _insertVariant(
        productId: parleGId,
        name: 'Parle-G 10',
        sellingPricePaise: 1000, // ₹10
        barcode: 'DEMO-PARLE-10',
        hsnCode: '1905',
      );
      final parle50Id = await _insertVariant(
        productId: parleGId,
        name: 'Parle-G 50',
        sellingPricePaise: 5000, // ₹50
        barcode: 'DEMO-PARLE-50',
        hsnCode: '1905',
      );
      await _stockService.applyStockChange(
        productId: parleGId,
        variantId: parle10Id,
        delta: 9999,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
        note: 'Initial Demo Stock for Parle-G 10',
      );
      await _stockService.applyStockChange(
        productId: parleGId,
        variantId: parle50Id,
        delta: 9999,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
        note: 'Initial Demo Stock for Parle-G 50',
      );

      // Soaps (Personal Care)
      final soaps = [
        ('DEMO-DETTOL', 'Dettol Soap', 14000, 'DEMO-BAR-DETTOL'), // ₹140
        ('DEMO-DOVE', 'Dove Soap', 9900, 'DEMO-BAR-DOVE'),       // ₹99
        ('DEMO-HAMAM', 'Hamam Soap', 8900, 'DEMO-BAR-HAMAM'),     // ₹89
        ('DEMO-PEARS', 'Pears Soap', 7700, 'DEMO-BAR-PEARS'),     // ₹77
        ('DEMO-MEDIMIX', 'Medimix Soap', 3900, 'DEMO-BAR-MEDIMIX'), // ₹39
      ];

      for (final s in soaps) {
        final soapId = await _insertProduct(
          code: s.$1,
          name: s.$2,
          categoryId: catPersonalCare,
          brandId: defaultBrandId,
          unitId: defaultUnitId,
          taxCategoryId: gst18Id,
          sellingPricePaise: s.$3,
          barcode: s.$4,
          hsnCode: '3401',
        );
        await _stockService.applyStockChange(
          productId: soapId,
          delta: 9999,
          transactionType: StockMovementType.stockAdjustment,
          transactionDate: DateTime.now(),
          note: 'Initial Demo Stock for ${s.$2}',
        );
      }

      // Beverages
      final cokeId = await _insertProduct(
        code: 'DEMO-COKE-500',
        name: 'Coca-Cola 500ml',
        categoryId: catBeverages,
        brandId: defaultBrandId,
        unitId: defaultUnitId,
        taxCategoryId: gst18Id,
        sellingPricePaise: 4000, // ₹40
        barcode: 'DEMO-BAR-COKE',
        hsnCode: '2202',
      );
      await _stockService.applyStockChange(
        productId: cokeId,
        delta: 9999,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
        note: 'Initial Demo Stock for Coca-Cola',
      );

      // Out-of-Stock Demo Product (Stock = 0)
      await _insertProduct(
        code: 'DEMO-NESCAFE-OOS',
        name: 'Nescafe Classic 100g (Out of Stock Demo)',
        categoryId: catBeverages,
        brandId: defaultBrandId,
        unitId: defaultUnitId,
        taxCategoryId: gst18Id,
        sellingPricePaise: 18000, // ₹180
        barcode: 'DEMO-BAR-NESCAFE',
        hsnCode: '2101',
      );

      // Stationery
      final noteBookId = await _insertProduct(
        code: 'DEMO-NOTEBOOK',
        name: 'Classmate Notebook A4',
        categoryId: catStationery,
        brandId: defaultBrandId,
        unitId: defaultUnitId,
        taxCategoryId: gst18Id,
        sellingPricePaise: 6500, // ₹65
        barcode: 'DEMO-BAR-NOTEBOOK',
        hsnCode: '4820',
      );
      await _stockService.applyStockChange(
        productId: noteBookId,
        delta: 9999,
        transactionType: StockMovementType.stockAdjustment,
        transactionDate: DateTime.now(),
        note: 'Initial Demo Stock for Classmate Notebook',
      );
    });
  }

  Future<int> _getOrCreateCategory(String name, String description) async {
    final existing = await (_database.select(_database.categories)
          ..where((t) => t.categoryName.equals(name)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    return _database.into(_database.categories).insert(
          db.CategoriesCompanion.insert(
            categoryCode: 'CAT-${name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '')}',
            categoryName: name,
            description: Value(description),
          ),
        );
  }

  Future<int> _insertProduct({
    required String code,
    required String name,
    required int categoryId,
    required int brandId,
    required int unitId,
    int? taxCategoryId,
    required int sellingPricePaise,
    required String barcode,
    required String hsnCode,
  }) async {
    return _database.into(_database.products).insert(
          db.ProductsCompanion.insert(
            productCode: code,
            productName: name,
            categoryId: Value(categoryId),
            brandId: Value(brandId),
            unitId: unitId,
            taxCategoryId: Value(taxCategoryId),
            sellingPrice: Value(sellingPricePaise),
            barcode: Value(barcode),
            hsnCode: Value(hsnCode),
            minimumStock: const Value(5),
          ),
        );
  }

  Future<int> _insertVariant({
    required int productId,
    required String name,
    required int sellingPricePaise,
    required String barcode,
    required String hsnCode,
  }) async {
    return _database.into(_database.productVariants).insert(
          db.ProductVariantsCompanion.insert(
            productId: productId,
            variantName: name,
            sellingPrice: Value(sellingPricePaise),
            barcode: Value(barcode),
            hsnCode: Value(hsnCode),
          ),
        );
  }
}
