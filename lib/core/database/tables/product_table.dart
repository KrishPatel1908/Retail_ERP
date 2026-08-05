import 'package:drift/drift.dart';

import 'brand_table.dart';
import 'category_table.dart';
import 'hsn_master_table.dart';
import 'tax_category_table.dart';
import 'tax_type_table.dart';
import 'unit_table.dart';
import 'warehouse_table.dart';

/// Product master — the hub of the ERP (approved blueprint §3.13).
///
/// Prices are stored as paise; `current_stock` is a cached value maintained
/// by the inventory engine, never written by the UI. The composite foreign
/// key below guarantees that `sub_category` always belongs to the product's
/// own `category`.
@DataClassName('Product')
@TableIndex(name: 'idx_product_name', columns: {#productName})
@TableIndex(name: 'idx_product_category', columns: {#categoryId})
@TableIndex(
  name: 'idx_product_category_sub_category',
  columns: {#categoryId, #subCategoryId},
)
@TableIndex(name: 'idx_product_brand', columns: {#brandId})
@TableIndex(name: 'idx_product_hsn', columns: {#hsnId})
@TableIndex(
  name: 'idx_product_default_warehouse',
  columns: {#defaultWarehouseId},
)
@TableIndex(name: 'idx_product_active', columns: {#isActive})
class Products extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'product';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get productCode => text().unique()();
  TextColumn get productName => text()();
  TextColumn get barcode => text().nullable().unique()();
  IntColumn get hsnId => integer().nullable().references(HsnMasters, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();

  /// Belongs to `category_id`; enforced by the composite foreign key in
  /// [customConstraints] (no single-column reference).
  IntColumn get subCategoryId => integer().nullable()();
  IntColumn get brandId => integer().references(Brands, #id)();
  @ReferenceName('purchaseUnit')
  IntColumn get purchaseUnitId => integer().references(Units, #id)();
  @ReferenceName('salesUnit')
  IntColumn get salesUnitId => integer().references(Units, #id)();
  @ReferenceName('stockUnit')
  IntColumn get stockUnitId => integer().references(Units, #id)();

  IntColumn get purchasePrice => integer().withDefault(const Constant(0))();
  IntColumn get landingCost => integer().withDefault(const Constant(0))();
  IntColumn get mrp => integer().withDefault(const Constant(0))();
  IntColumn get retailPrice => integer().withDefault(const Constant(0))();
  IntColumn get wholesalePrice => integer().withDefault(const Constant(0))();
  IntColumn get specialPrice => integer().nullable()();

  IntColumn get taxCategoryId => integer().references(TaxCategories, #id)();
  IntColumn get taxTypeId => integer().nullable().references(TaxTypes, #id)();
  IntColumn get defaultWarehouseId =>
      integer().nullable().references(Warehouses, #id)();

  RealColumn get minStock => real().withDefault(const Constant(0.0))();
  RealColumn get maxStock => real().withDefault(const Constant(0.0))();
  RealColumn get reorderLevel => real().withDefault(const Constant(0.0))();
  RealColumn get openingStock => real().withDefault(const Constant(0.0))();
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get weight => real().nullable()();

  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isStockItem => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY (category_id, sub_category_id) '
        'REFERENCES sub_category (category_id, id)',
    'CHECK (purchase_price >= 0 AND landing_cost >= 0 AND mrp >= 0 '
        'AND retail_price >= 0 AND wholesale_price >= 0 '
        'AND (special_price IS NULL OR special_price >= 0))',
  ];
}
