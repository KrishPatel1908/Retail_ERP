import 'package:drift/drift.dart';

import 'brand_table.dart';
import 'category_table.dart';
import 'sub_category_table.dart';
import 'tax_type_table.dart';
import 'unit_table.dart';

/// Simplified product master — a clean catalog for businesses that sell.
///
/// Supports product variants: a parent product can have multiple variants
/// stored in [ProductVariants]. The parent holds common information while
/// each variant holds its own selling price and optional expiry date.
@DataClassName('Product')
@TableIndex(name: 'idx_product_name', columns: {#productName})
@TableIndex(name: 'idx_product_category', columns: {#categoryId})
@TableIndex(name: 'idx_product_brand', columns: {#brandId})
@TableIndex(name: 'idx_product_active', columns: {#isActive})
@TableIndex(name: 'idx_product_created_at', columns: {#createdAt})
class Products extends Table {
  @override
  String get tableName => 'product';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get productCode => text().unique()();
  TextColumn get productName => text()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  IntColumn get subCategoryId =>
      integer().nullable().references(SubCategories, #id)();
  IntColumn get brandId => integer().nullable().references(Brands, #id)();
  IntColumn get unitId => integer().references(Units, #id)();
  IntColumn get sellingPrice => integer().withDefault(const Constant(0))();
  IntColumn get taxTypeId => integer().nullable().references(TaxTypes, #id)();

  /// Optional expiry date for the parent product (e.g. food, medicine).
  DateTimeColumn get expiryDate => dateTime().nullable()();

  TextColumn get notes => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    'CHECK (selling_price >= 0)',
  ];
}

/// Product variants — each variant belongs to a parent [Products] row.
///
/// A variant inherits all common product information (category, brand, unit,
/// tax) from the parent and only stores its own selling price, optional
/// expiry date, and optional notes.
@DataClassName('ProductVariant')
@TableIndex(name: 'idx_variant_product', columns: {#productId})
@TableIndex(name: 'idx_variant_name', columns: {#variantName})
class ProductVariants extends Table {
  @override
  String get tableName => 'product_variant';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get variantName => text()();
  IntColumn get sellingPrice => integer().withDefault(const Constant(0))();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {productId, variantName},
  ];

  @override
  List<String> get customConstraints => const [
    'CHECK (selling_price >= 0)',
  ];
}
