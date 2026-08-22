import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/product.dart';
import '../../domain/exceptions/product_exceptions.dart';

/// Filter parameters for the product list.
class ProductFilters {
  const ProductFilters({
    this.categoryId,
    this.subCategoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.createdFrom,
    this.createdTo,
    this.expiryFrom,
    this.expiryTo,
    this.isActive,
  });

  final int? categoryId;
  final int? subCategoryId;
  final int? brandId;
  final int? minPrice;
  final int? maxPrice;
  final DateTime? createdFrom;
  final DateTime? createdTo;
  final DateTime? expiryFrom;
  final DateTime? expiryTo;
  final bool? isActive;
}

/// Sortable columns for the product list.
enum ProductSortColumn {
  code,
  name,
  sellingPrice,
  expiryDate,
  category,
  brand,
  createdAt,
}

/// Paginated product list result.
class ProductPage {
  const ProductPage({required this.items, required this.totalCount});

  final List<ProductEntity> items;
  final int totalCount;
}

/// Input data for creating a product variant.
class VariantInput {
  const VariantInput({
    required this.variantName,
    required this.sellingPrice,
    this.expiryDate,
    this.notes,
  });

  final String variantName;
  final int sellingPrice;
  final DateTime? expiryDate;
  final String? notes;
}

/// Data access for products.
///
/// The single entry point the presentation layer uses to read and write
/// products. Drift types never leak past this class: callers receive and
/// return [ProductEntity] domain entities only.
class ProductRepository {
  ProductRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// Generates the next product code (e.g. PROD00001).
  static const String _codePrefix = 'PROD';
  static const int _suffixLength = 5;

  /// Returns one page of products matching [query], [filters] and [sort].
  Future<ProductPage> fetchPage({
    String query = '',
    ProductFilters filters = const ProductFilters(),
    ProductSortColumn sort = ProductSortColumn.name,
    bool sortAscending = true,
    int page = 1,
    int pageSize = 25,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final t = _database.products;
    final catT = _database.categories;
    final subT = _database.subCategories;
    final brandT = _database.brands;
    final unitT = _database.units;
    final taxT = _database.taxTypes;

    final predicate = _buildPredicate(
      t: t,
      catT: catT,
      subT: subT,
      brandT: brandT,
      normalizedQuery: query.trim().toLowerCase(),
      filters: filters,
    );

    // Count query.
    final countExpr = t.id.count();
    final countQuery = _database.selectOnly(_database.products);
    countQuery.addColumns([countExpr]);
    if (predicate != null) countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    // Page query with joins for display names.
    final rowsQuery = _database.select(t).join([
      leftOuterJoin(catT, catT.id.equalsExp(t.categoryId)),
      leftOuterJoin(subT, subT.id.equalsExp(t.subCategoryId)),
      leftOuterJoin(brandT, brandT.id.equalsExp(t.brandId)),
      innerJoin(unitT, unitT.id.equalsExp(t.unitId)),
      leftOuterJoin(taxT, taxT.id.equalsExp(t.taxTypeId)),
    ]);

    if (predicate != null) rowsQuery.where(predicate);

    rowsQuery.orderBy([
      _buildOrderBy(t: t, catT: catT, brandT: brandT, sort: sort, ascending: sortAscending),
    ]);

    rowsQuery.limit(pageSize, offset: (effectivePage - 1) * pageSize);

    final rows = await rowsQuery.get();
    final products = rows.map((row) => _fromTypedResult(row)).toList();

    // Fetch variants for all products in this page in one query.
    if (products.isNotEmpty) {
      final productIds = products.map((p) => p.id).toList();
      final variants = await _fetchVariantsForProducts(productIds);
      final productsWithVariants = products.map((p) {
        final pVariants = variants.where((v) => v.productId == p.id).toList();
        return ProductEntity(
          id: p.id,
          productCode: p.productCode,
          productName: p.productName,
          categoryId: p.categoryId,
          categoryName: p.categoryName,
          subCategoryId: p.subCategoryId,
          subCategoryName: p.subCategoryName,
          brandId: p.brandId,
          brandName: p.brandName,
          unitId: p.unitId,
          unitName: p.unitName,
          sellingPrice: p.sellingPrice,
          taxTypeId: p.taxTypeId,
          taxTypeName: p.taxTypeName,
          expiryDate: p.expiryDate,
          notes: p.notes,
          isActive: p.isActive,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
          variants: pVariants,
        );
      }).toList();
      return ProductPage(
        items: productsWithVariants,
        totalCount: total,
      );
    }

    return ProductPage(items: products, totalCount: total);
  }

  /// Gets a product by ID with joined display names and all its variants.
  Future<ProductEntity> getById(int id) async {
    final t = _database.products;
    final catT = _database.categories;
    final subT = _database.subCategories;
    final brandT = _database.brands;
    final unitT = _database.units;
    final taxT = _database.taxTypes;

    final query = _database.select(t).join([
      leftOuterJoin(catT, catT.id.equalsExp(t.categoryId)),
      leftOuterJoin(subT, subT.id.equalsExp(t.subCategoryId)),
      leftOuterJoin(brandT, brandT.id.equalsExp(t.brandId)),
      innerJoin(unitT, unitT.id.equalsExp(t.unitId)),
      leftOuterJoin(taxT, taxT.id.equalsExp(t.taxTypeId)),
    ])..where(t.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) throw ProductNotFoundException(id);

    final product = _fromTypedResult(row);
    final variants = await _fetchVariantsForProducts([id]);

    return ProductEntity(
      id: product.id,
      productCode: product.productCode,
      productName: product.productName,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      subCategoryId: product.subCategoryId,
      subCategoryName: product.subCategoryName,
      brandId: product.brandId,
      brandName: product.brandName,
      unitId: product.unitId,
      unitName: product.unitName,
      sellingPrice: product.sellingPrice,
      taxTypeId: product.taxTypeId,
      taxTypeName: product.taxTypeName,
      expiryDate: product.expiryDate,
      notes: product.notes,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      variants: variants,
    );
  }

  /// Creates a product, optionally with variants, in a single transaction.
  Future<ProductEntity> createProduct({
    required String productName,
    String? productCode,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    required int unitId,
    required int sellingPrice,
    int? taxTypeId,
    DateTime? expiryDate,
    String? notes,
    List<VariantInput> variants = const [],
  }) async {
    final trimmedName = productName.trim();
    final trimmedNotes = _normalizeText(notes);

    try {
      final id = await _database.transaction(() async {
        final code = (productCode != null && productCode.trim().isNotEmpty)
            ? productCode.trim()
            : await _nextProductCode();

        final productId = await _database.into(_database.products).insert(
          db.ProductsCompanion.insert(
            productCode: code,
            productName: trimmedName,
            categoryId: Value(categoryId),
            subCategoryId: Value(subCategoryId),
            brandId: Value(brandId),
            unitId: unitId,
            sellingPrice: Value(sellingPrice),
            taxTypeId: Value(taxTypeId),
            expiryDate: Value(expiryDate),
            notes: Value(trimmedNotes),
          ),
        );

        // Insert variants within the same transaction.
        for (final variant in variants) {
          await _database.into(_database.productVariants).insert(
            db.ProductVariantsCompanion.insert(
              productId: productId,
              variantName: variant.variantName.trim(),
              sellingPrice: Value(variant.sellingPrice),
              expiryDate: Value(variant.expiryDate),
              notes: Value(_normalizeText(variant.notes)),
            ),
          );
        }

        return productId;
      });
      return getById(id);
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        // Determine which field caused the violation.
        if (error.toString().contains('product_variant')) {
          throw const ProductDuplicateException(
            ProductDuplicateField.variantName,
          );
        }
        if (error.toString().contains('product_code')) {
          throw const ProductDuplicateException(
            ProductDuplicateField.productCode,
          );
        }
        throw const ProductDuplicateException(
          ProductDuplicateField.productCode,
        );
      }
      throw DatabaseOperationException(
        'Failed to create product.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing product and returns the updated entity.
  Future<ProductEntity> updateProduct(
    int id, {
    required String productName,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    required int unitId,
    required int sellingPrice,
    int? taxTypeId,
    DateTime? expiryDate,
    String? notes,
    bool? isActive,
  }) async {
    final trimmedName = productName.trim();
    final trimmedNotes = _normalizeText(notes);

    try {
      final updatedRows = await (_database.update(
        _database.products,
      )..where((t) => t.id.equals(id))).write(
        db.ProductsCompanion(
          productName: Value(trimmedName),
          categoryId: Value(categoryId),
          subCategoryId: Value(subCategoryId),
          brandId: Value(brandId),
          unitId: Value(unitId),
          sellingPrice: Value(sellingPrice),
          taxTypeId: Value(taxTypeId),
          expiryDate: Value(expiryDate),
          notes: Value(trimmedNotes),
          isActive: isActive == null ? const Value.absent() : Value(isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (updatedRows == 0) throw ProductNotFoundException(id);
      return getById(id);
    } on ProductNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const ProductDuplicateException(ProductDuplicateField.productCode);
      }
      throw DatabaseOperationException(
        'Failed to update product.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a product and all its variants.
  Future<void> deleteProduct(int id) async {
    try {
      await _database.transaction(() async {
        // Delete variants first (in case ON DELETE CASCADE isn't triggered).
        await (_database.delete(
          _database.productVariants,
        )..where((t) => t.productId.equals(id))).go();

        // Delete the parent product.
        final deleted = await (_database.delete(
          _database.products,
        )..where((t) => t.id.equals(id))).go();

        if (deleted == 0) throw ProductNotFoundException(id);
      });
    } on ProductNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const ProductInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete product.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Creates a new variant for an existing product.
  Future<ProductVariantEntity> createVariant(
    int productId, {
    required String variantName,
    required int sellingPrice,
    DateTime? expiryDate,
    String? notes,
  }) async {
    try {
      final id = await _database.into(_database.productVariants).insert(
        db.ProductVariantsCompanion.insert(
          productId: productId,
          variantName: variantName.trim(),
          sellingPrice: Value(sellingPrice),
          expiryDate: Value(expiryDate),
          notes: Value(_normalizeText(notes)),
        ),
      );
      return _getVariantById(id);
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const ProductDuplicateException(
          ProductDuplicateField.variantName,
        );
      }
      throw DatabaseOperationException(
        'Failed to create variant.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing variant.
  Future<ProductVariantEntity> updateVariant(
    int variantId, {
    required String variantName,
    required int sellingPrice,
    DateTime? expiryDate,
    String? notes,
  }) async {
    try {
      final updatedRows = await (_database.update(
        _database.productVariants,
      )..where((t) => t.id.equals(variantId))).write(
        db.ProductVariantsCompanion(
          variantName: Value(variantName.trim()),
          sellingPrice: Value(sellingPrice),
          expiryDate: Value(expiryDate),
          notes: Value(_normalizeText(notes)),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (updatedRows == 0) throw ProductVariantNotFoundException(variantId);
      return _getVariantById(variantId);
    } on ProductVariantNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const ProductDuplicateException(
          ProductDuplicateField.variantName,
        );
      }
      throw DatabaseOperationException(
        'Failed to update variant.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Deletes a single variant.
  Future<void> deleteVariant(int variantId) async {
    try {
      final deleted = await (_database.delete(
        _database.productVariants,
      )..where((t) => t.id.equals(variantId))).go();

      if (deleted == 0) throw ProductVariantNotFoundException(variantId);
    } on ProductVariantNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const ProductInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete variant.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetches all variants for a given product.
  Future<List<ProductVariantEntity>> getVariants(int productId) async {
    return _fetchVariantsForProducts([productId]);
  }

  /// Fetches products with their variants, used by the tracking module.
  Future<List<ProductEntity>> fetchAllWithVariants() async {
    final allProducts = await (_database.select(_database.products)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.productName.lower())]))
        .get();

    if (allProducts.isEmpty) return const [];

    final productIds = allProducts.map((p) => p.id).toList();
    final allVariants = await _fetchVariantsForProducts(productIds);

    // Build a lookup of category, brand, unit names for display.
    final categories = await _database.select(_database.categories).get();
    final brands = await _database.select(_database.brands).get();
    final units = await _database.select(_database.units).get();
    final taxTypes = await _database.select(_database.taxTypes).get();

    final catMap = {for (final c in categories) c.id: c.categoryName};
    final brandMap = {for (final b in brands) b.id: b.brandName};
    final unitMap = {for (final u in units) u.id: u.unitName};
    final taxMap = {for (final t in taxTypes) t.id: t.taxTypeName};

    return allProducts.map((p) {
      final variants = allVariants.where((v) => v.productId == p.id).toList();
      return ProductEntity(
        id: p.id,
        productCode: p.productCode,
        productName: p.productName,
        categoryId: p.categoryId,
        categoryName: catMap[p.categoryId],
        subCategoryId: p.subCategoryId,
        brandId: p.brandId,
        brandName: brandMap[p.brandId],
        unitId: p.unitId,
        unitName: unitMap[p.unitId],
        sellingPrice: p.sellingPrice,
        taxTypeId: p.taxTypeId,
        taxTypeName: taxMap[p.taxTypeId],
        expiryDate: p.expiryDate,
        notes: p.notes,
        isActive: p.isActive,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
        variants: variants,
      );
    }).toList();
  }

  // --- Dropdown helpers ----------------------------------------------------

  /// Distinct category names for the filter dropdown.
  Future<List<({int id, String name})>> distinctCategories() async {
    final query = _database.select(_database.categories)
      ..orderBy([(t) => OrderingTerm.asc(t.categoryName.lower())]);
    final rows = await query.get();
    return rows.map((r) => (id: r.id, name: r.categoryName)).toList();
  }

  /// Distinct sub-category names, optionally filtered by category.
  Future<List<({int id, String name})>> distinctSubCategories({
    int? categoryId,
  }) async {
    final query = _database.select(_database.subCategories)
      ..where((t) {
        if (categoryId != null) return t.categoryId.equals(categoryId);
        return const Constant(true);
      })
      ..orderBy([(t) => OrderingTerm.asc(t.subCategoryName.lower())]);
    final rows = await query.get();
    return rows.map((r) => (id: r.id, name: r.subCategoryName)).toList();
  }

  /// Distinct brand names for the filter dropdown.
  Future<List<({int id, String name})>> distinctBrands() async {
    final query = _database.select(_database.brands)
      ..orderBy([(t) => OrderingTerm.asc(t.brandName.lower())]);
    final rows = await query.get();
    return rows.map((r) => (id: r.id, name: r.brandName)).toList();
  }

  // --- Internals -----------------------------------------------------------

  Future<String> _nextProductCode() async {
    final row = await _database.customSelect(
      "SELECT COALESCE(MAX(CAST(SUBSTR(product_code, ${_codePrefix.length + 1}) "
      "AS INTEGER)), 0) + 1 AS next "
      "FROM product WHERE product_code LIKE '$_codePrefix%'",
    ).getSingle();
    final next = row.read<int>('next');
    return '$_codePrefix${next.toString().padLeft(_suffixLength, '0')}';
  }

  String? _normalizeText(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Expression<bool>? _buildPredicate({
    required db.$ProductsTable t,
    required db.$CategoriesTable catT,
    required db.$SubCategoriesTable subT,
    required db.$BrandsTable brandT,
    required String normalizedQuery,
    required ProductFilters filters,
  }) {
    Expression<bool> predicate = const Constant(true);

    // Text search across name, code, category, sub-category, brand, and variant names.
    if (normalizedQuery.isNotEmpty) {
      // Search in variant names using a subquery.
      final variantSubQuery = _database.selectOnly(_database.productVariants)
        ..addColumns([_database.productVariants.productId])
        ..where(
          _database.productVariants.variantName
              .lower()
              .contains(normalizedQuery),
        );

      predicate = predicate &
          (t.productName.lower().contains(normalizedQuery) |
              t.productCode.lower().contains(normalizedQuery) |
              catT.categoryName.lower().contains(normalizedQuery) |
              subT.subCategoryName.lower().contains(normalizedQuery) |
              brandT.brandName.lower().contains(normalizedQuery) |
              t.id.isInQuery(variantSubQuery));
    }

    // Filters.
    if (filters.categoryId != null) {
      predicate = predicate & t.categoryId.equals(filters.categoryId!);
    }
    if (filters.subCategoryId != null) {
      predicate = predicate & t.subCategoryId.equals(filters.subCategoryId!);
    }
    if (filters.brandId != null) {
      predicate = predicate & t.brandId.equals(filters.brandId!);
    }
    if (filters.minPrice != null) {
      predicate = predicate & t.sellingPrice.isBiggerOrEqualValue(filters.minPrice!);
    }
    if (filters.maxPrice != null) {
      predicate = predicate & t.sellingPrice.isSmallerOrEqualValue(filters.maxPrice!);
    }
    if (filters.createdFrom != null) {
      predicate = predicate & t.createdAt.isBiggerOrEqualValue(filters.createdFrom!);
    }
    if (filters.createdTo != null) {
      final endOfDay = DateTime(
        filters.createdTo!.year,
        filters.createdTo!.month,
        filters.createdTo!.day,
        23, 59, 59,
      );
      predicate = predicate & t.createdAt.isSmallerOrEqualValue(endOfDay);
    }
    if (filters.expiryFrom != null) {
      predicate = predicate & t.expiryDate.isBiggerOrEqualValue(filters.expiryFrom!);
    }
    if (filters.expiryTo != null) {
      predicate = predicate & t.expiryDate.isSmallerOrEqualValue(filters.expiryTo!);
    }
    if (filters.isActive != null) {
      predicate = predicate & t.isActive.equals(filters.isActive!);
    }

    return predicate;
  }

  OrderingTerm _buildOrderBy({
    required db.$ProductsTable t,
    required db.$CategoriesTable catT,
    required db.$BrandsTable brandT,
    required ProductSortColumn sort,
    required bool ascending,
  }) {
    final direction = ascending ? OrderingTerm.asc : OrderingTerm.desc;
    return switch (sort) {
      ProductSortColumn.code => direction(t.productCode.lower()),
      ProductSortColumn.name => direction(t.productName.lower()),
      ProductSortColumn.sellingPrice => direction(t.sellingPrice),
      ProductSortColumn.expiryDate => direction(t.expiryDate),
      ProductSortColumn.category => direction(catT.categoryName.lower()),
      ProductSortColumn.brand => direction(brandT.brandName.lower()),
      ProductSortColumn.createdAt => direction(t.createdAt),
    };
  }

  ProductEntity _fromTypedResult(TypedResult row) {
    final t = row.readTable(_database.products);
    final cat = row.readTableOrNull(_database.categories);
    final sub = row.readTableOrNull(_database.subCategories);
    final brand = row.readTableOrNull(_database.brands);
    final unit = row.readTable(_database.units);
    final tax = row.readTableOrNull(_database.taxTypes);

    return ProductEntity(
      id: t.id,
      productCode: t.productCode,
      productName: t.productName,
      categoryId: t.categoryId,
      categoryName: cat?.categoryName,
      subCategoryId: t.subCategoryId,
      subCategoryName: sub?.subCategoryName,
      brandId: t.brandId,
      brandName: brand?.brandName,
      unitId: t.unitId,
      unitName: unit.unitName,
      sellingPrice: t.sellingPrice,
      taxTypeId: t.taxTypeId,
      taxTypeName: tax?.taxTypeName,
      expiryDate: t.expiryDate,
      notes: t.notes,
      isActive: t.isActive,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  /// Fetches variants for multiple products in a single query.
  Future<List<ProductVariantEntity>> _fetchVariantsForProducts(
    List<int> productIds,
  ) async {
    if (productIds.isEmpty) return const [];

    final rows = await (_database.select(_database.productVariants)
          ..where((t) => t.productId.isIn(productIds))
          ..orderBy([(t) => OrderingTerm.asc(t.variantName.lower())]))
        .get();

    return rows.map((row) => ProductVariantEntity(
      id: row.id,
      productId: row.productId,
      variantName: row.variantName,
      sellingPrice: row.sellingPrice,
      expiryDate: row.expiryDate,
      notes: row.notes,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    )).toList();
  }

  /// Gets a single variant by ID.
  Future<ProductVariantEntity> _getVariantById(int id) async {
    final row = await (_database.select(_database.productVariants)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw ProductVariantNotFoundException(id);
    return ProductVariantEntity(
      id: row.id,
      productId: row.productId,
      variantName: row.variantName,
      sellingPrice: row.sellingPrice,
      expiryDate: row.expiryDate,
      notes: row.notes,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// SQLite extended result code for a UNIQUE constraint violation.
  static const int _sqliteConstraintUnique = 2067;

  /// SQLite extended result code for a FOREIGN KEY constraint violation.
  static const int _sqliteConstraintForeignKey = 787;

  SqliteException? _asSqliteException(Object error) {
    return switch (error) {
      SqliteException exception => exception,
      DriftWrappedException(:final cause) when cause is SqliteException => cause,
      _ => null,
    };
  }

  bool _isUniqueViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintUnique;
  }

  bool _isForeignKeyViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintForeignKey;
  }
}
