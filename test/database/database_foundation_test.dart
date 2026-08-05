import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sq;

import 'package:retail_erp/core/database/app_database.dart';
import 'package:retail_erp/core/database/database_initializer.dart';
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

/// Matcher for constraint violations raised by the native executor.
final _throwsDatabaseError = throwsA(
  anyOf(isA<SqliteException>(), isA<DriftWrappedException>()),
);

/// The 16 tables of the approved blueprint.
const _expectedTables = {
  'company_settings',
  'category',
  'sub_category',
  'brand',
  'unit',
  'uom_conversion',
  'tax_category',
  'tax_category_rate',
  'tax_type',
  'hsn_master',
  'customer',
  'supplier',
  'warehouse',
  'product',
  'product_uom',
  'document_number_sequence',
};

/// The 10 case-insensitive unique indexes of the approved blueprint. Units
/// are unique by name (schema v2), not by code.
const _noCaseUniqueIndexes = {
  'idx_category_name_nocase_unique',
  'idx_sub_category_name_nocase_unique',
  'idx_brand_name_nocase_unique',
  'idx_unit_name_nocase_unique',
  'idx_tax_category_name_nocase_unique',
  'idx_tax_type_code_nocase_unique',
  'idx_hsn_code_nocase_unique',
  'idx_customer_gst_nocase_unique',
  'idx_supplier_gst_nocase_unique',
  'idx_warehouse_name_nocase_unique',
};

Future<Set<String>> _tableNames(AppDatabase db) async {
  final rows = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
      .get();
  return rows.map((row) => row.read<String>('name')).toSet();
}

Future<Set<String>> _indexNames(AppDatabase db) async {
  final rows = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
      .get();
  return rows.map((row) => row.read<String>('name')).toSet();
}

void main() {
  // Every test starts with a fresh, closed provider.
  setUp(() => DatabaseProvider.instance.close());

  group('AppDatabase schema', () {
    test('opens with an in-memory connection', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final result = await db.customSelect('SELECT 1').get();
      expect(result.single.data.values.single, 1);
    });

    test('registers all 16 blueprint tables', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final names = await _tableNames(db);
      expect(names, containsAll(_expectedTables));

      // No unexpected user tables; sqlite_sequence is SQLite-internal.
      final unexpected = names.difference(_expectedTables).difference({
        'sqlite_sequence',
      });
      expect(unexpected, isEmpty);
    });

    test('reports and persists the schema version', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      expect(db.schemaVersion, 2);
      await db.customSelect('SELECT 1').get();

      final row = (await db.customSelect('PRAGMA user_version').get()).single;
      expect(row.read<int>('user_version'), 2);
    });

    test('creates the case-insensitive unique indexes', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final indexNames = await _indexNames(db);
      expect(indexNames, containsAll(_noCaseUniqueIndexes));
      // The one-default-per-product partial unique index also exists.
      expect(indexNames, contains('idx_product_uom_one_default'));
    });
  });

  group('Seed data', () {
    test('seeds reference data on create', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      expect((await db.select(db.units).get()).length, 19);
      expect((await db.select(db.uomConversions).get()).length, 7);
      expect((await db.select(db.taxTypes).get()).length, 5);
      expect((await db.select(db.taxCategories).get()).length, 5);
      expect((await db.select(db.taxCategoryRates).get()).length, 15);

      final generic = await (db.select(
        db.brands,
      )..where((brand) => brand.brandCode.equals('GENERIC'))).getSingleOrNull();
      expect(generic, isNotNull);
      expect(generic!.brandName, 'Generic / No Brand');
    });

    test('seeds the universal conversions of the blueprint', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final dozenToPiece = await (db.select(db.uomConversions)..where(
        (c) => c.fromUnitId.equals(2) & c.toUnitId.equals(1),
      )).getSingleOrNull();
      expect(dozenToPiece, isNotNull);
      expect(dozenToPiece!.conversionFactor, 12);

      final kgToGram = await (db.select(db.uomConversions)..where(
        (c) => c.fromUnitId.equals(5) & c.toUnitId.equals(6),
      )).getSingleOrNull();
      expect(kgToGram, isNotNull);
      expect(kgToGram!.conversionFactor, 1000);
    });
  });

  group('Constraints', () {
    test('enforces foreign keys', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      await expectLater(
        db
            .into(db.subCategories)
            .insert(
              SubCategoriesCompanion.insert(
                categoryId: 9999,
                subCategoryCode: 'SUB-X',
                subCategoryName: 'Unknown category',
              ),
            ),
        _throwsDatabaseError,
      );
    });

    test(
      'rejects a product whose sub-category belongs to another category',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);
        await db.customSelect('SELECT 1').get();

        final electronics = await db
            .into(db.categories)
            .insert(
              CategoriesCompanion.insert(
                categoryCode: 'CAT-ELEC',
                categoryName: 'Electronics',
              ),
            );
        final groceries = await db
            .into(db.categories)
            .insert(
              CategoriesCompanion.insert(
                categoryCode: 'CAT-GROC',
                categoryName: 'Groceries',
              ),
            );
        final keyboards = await db
            .into(db.subCategories)
            .insert(
              SubCategoriesCompanion.insert(
                categoryId: electronics,
                subCategoryCode: 'SUB-KEY',
                subCategoryName: 'Keyboard',
              ),
            );

        // Valid combination inserts fine (positive control).
        await db
            .into(db.products)
            .insert(
              ProductsCompanion.insert(
                productCode: 'P-OK',
                productName: 'Keyboard',
                categoryId: electronics,
                subCategoryId: Value(keyboards),
                brandId: 1,
                purchaseUnitId: 1,
                salesUnitId: 1,
                stockUnitId: 1,
                taxCategoryId: 1,
              ),
            );

        // Cross-category combination violates the composite foreign key.
        await expectLater(
          db
              .into(db.products)
              .insert(
                ProductsCompanion.insert(
                  productCode: 'P-BAD',
                  productName: 'Misplaced product',
                  categoryId: groceries,
                  subCategoryId: Value(keyboards),
                  brandId: 1,
                  purchaseUnitId: 1,
                  salesUnitId: 1,
                  stockUnitId: 1,
                  taxCategoryId: 1,
                ),
              ),
          _throwsDatabaseError,
        );
      },
    );

    test('enforces case-insensitive unique names', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      await db
          .into(db.brands)
          .insert(
            BrandsCompanion.insert(brandCode: 'BR-1', brandName: 'Samsung'),
          );
      await expectLater(
        db
            .into(db.brands)
            .insert(
              BrandsCompanion.insert(brandCode: 'BR-2', brandName: 'samsung'),
            ),
        _throwsDatabaseError,
      );
    });

    test('enforces check constraints', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      // uom_conversion: the factor must be > 0.
      await expectLater(
        db
            .into(db.uomConversions)
            .insert(
              UomConversionsCompanion.insert(
                fromUnitId: 1,
                toUnitId: 2,
                conversionFactor: 0,
              ),
            ),
        _throwsDatabaseError,
      );

      // uom_conversion: from and to units must differ.
      await expectLater(
        db
            .into(db.uomConversions)
            .insert(
              UomConversionsCompanion.insert(
                fromUnitId: 1,
                toUnitId: 1,
                conversionFactor: 2,
              ),
            ),
        _throwsDatabaseError,
      );

      // company_settings allows exactly one row (id = 1).
      await expectLater(
        db
            .into(db.companySettingsTable)
            .insert(
              CompanySettingsTableCompanion.insert(
                id: const Value(2),
                companyName: 'Second company',
              ),
            ),
        _throwsDatabaseError,
      );
    });

    test('enforces a single default conversion per product', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final categoryId = await db
          .into(db.categories)
          .insert(
            CategoriesCompanion.insert(
              categoryCode: 'CAT-1',
              categoryName: 'Produce',
            ),
          );
      final productId = await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(
              productCode: 'P-1',
              productName: 'Banana',
              categoryId: categoryId,
              brandId: 1,
              purchaseUnitId: 1,
              salesUnitId: 1,
              stockUnitId: 1,
              taxCategoryId: 1,
            ),
          );

      await db
          .into(db.productUoms)
          .insert(
            ProductUomsCompanion.insert(
              productId: productId,
              fromUnitId: 2,
              toUnitId: 1,
              conversionFactor: 12,
              isDefault: const Value(true),
            ),
          );

      // A second default for the same product violates the partial index.
      await expectLater(
        db
            .into(db.productUoms)
            .insert(
              ProductUomsCompanion.insert(
                productId: productId,
                fromUnitId: 3,
                toUnitId: 1,
                conversionFactor: 2,
                isDefault: const Value(true),
              ),
            ),
        _throwsDatabaseError,
      );

      // Exact duplicates (same product/from/to/factor) are rejected too.
      await expectLater(
        db
            .into(db.productUoms)
            .insert(
              ProductUomsCompanion.insert(
                productId: productId,
                fromUnitId: 2,
                toUnitId: 1,
                conversionFactor: 12,
              ),
            ),
        _throwsDatabaseError,
      );
    });
  });

  group('DatabaseProvider singleton', () {
    test('throws before initialization and after close', () {
      expect(DatabaseProvider.instance.isInitialized, isFalse);
      expect(
        () => DatabaseProvider.instance.database,
        throwsA(isA<DatabaseNotInitializedException>()),
      );
    });

    test('returns the same instance across initializations', () async {
      final first = await DatabaseInitializer.instance.initialize(
        connection: NativeDatabase.memory(),
      );
      expect(DatabaseProvider.instance.isInitialized, isTrue);

      final second = await DatabaseProvider.instance.initialize(
        connection: NativeDatabase.memory(),
      );
      expect(identical(first, second), isTrue);
      expect(identical(first, DatabaseProvider.instance.database), isTrue);

      await DatabaseInitializer.instance.dispose();
      expect(DatabaseProvider.instance.isInitialized, isFalse);
      expect(
        () => DatabaseProvider.instance.database,
        throwsA(isA<DatabaseNotInitializedException>()),
      );
    });
  });

  group('File-based database', () {
    test('opens RetailERP.db on disk', () async {
      final tempDir = await Directory.systemTemp.createTemp('retail_erp_test');
      addTearDown(() => tempDir.delete(recursive: true));

      final dbFile = File(p.join(tempDir.path, 'RetailERP.db'));
      final db = AppDatabase(NativeDatabase(dbFile));
      addTearDown(db.close);

      await db.customSelect('SELECT 1').get();
      expect(dbFile.existsSync(), isTrue);

      final names = await _tableNames(db);
      expect(names, containsAll(_expectedTables));
    });
  });

  group('Migration v1 → v2', () {
    test('upgrades a v1 database to the redesigned measurement schema', () async {
      // Two sequential databases on the same file are intentional here; the
      // warning below is only relevant for overlapping databases.
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_migration_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      // --- Build a v1 database by hand (the old approved schema) ----------
      final v1 = sq.sqlite3.open(file.path);
      v1.execute('PRAGMA user_version = 1');
      v1.execute(
        'CREATE TABLE unit ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'unit_code TEXT NOT NULL, '
        'unit_name TEXT NOT NULL, '
        'unit_symbol TEXT NOT NULL, '
        "unit_family TEXT NOT NULL DEFAULT 'GENERAL', "
        'base_unit_id INTEGER, '
        'factor_to_base REAL NOT NULL DEFAULT 1.0, '
        'is_active INTEGER NOT NULL DEFAULT 1, '
        'created_at INTEGER NOT NULL, '
        'updated_at INTEGER NOT NULL, '
        'FOREIGN KEY (base_unit_id) REFERENCES unit (id), '
        'CHECK (base_unit_id IS NULL OR base_unit_id <> id), '
        'CHECK (factor_to_base > 0))',
      );
      v1.execute(
        'CREATE TABLE uom_conversion ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'from_unit_id INTEGER NOT NULL REFERENCES unit (id), '
        'to_unit_id INTEGER NOT NULL REFERENCES unit (id), '
        'conversion_factor REAL NOT NULL, '
        'is_active INTEGER NOT NULL DEFAULT 1, '
        'created_at INTEGER NOT NULL, '
        'updated_at INTEGER NOT NULL, '
        'UNIQUE (from_unit_id, to_unit_id), '
        'CHECK (from_unit_id <> to_unit_id), '
        'CHECK (conversion_factor > 0))',
      );
      v1.execute(
        'CREATE TABLE product_uom ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'product_id INTEGER NOT NULL REFERENCES product (id), '
        'unit_id INTEGER NOT NULL REFERENCES unit (id), '
        'conversion_factor REAL NOT NULL, '
        'is_purchase_allowed INTEGER NOT NULL DEFAULT 1, '
        'is_sales_allowed INTEGER NOT NULL DEFAULT 1, '
        'is_active INTEGER NOT NULL DEFAULT 1, '
        'created_at INTEGER NOT NULL, '
        'updated_at INTEGER NOT NULL, '
        'UNIQUE (product_id, unit_id), '
        'CHECK (conversion_factor > 0))',
      );
      v1.execute(
        "INSERT INTO unit (id, unit_code, unit_name, unit_symbol, "
        "unit_family, factor_to_base, created_at, updated_at) VALUES "
        "(1, 'PC', 'Piece', 'pc', 'COUNT', 1.0, 1700000000, 1700000000)",
      );
      v1.execute(
        "INSERT INTO unit (id, unit_code, unit_name, unit_symbol, "
        "unit_family, base_unit_id, factor_to_base, created_at, updated_at) "
        "VALUES (2, 'DOZ', 'Dozen', 'doz', 'COUNT', 1, 12.0, "
        '1700000000, 1700000000)',
      );
      // A user-defined conversion that must survive the upgrade untouched.
      v1.execute(
        'INSERT INTO uom_conversion (from_unit_id, to_unit_id, '
        'conversion_factor, created_at, updated_at) VALUES '
        '(1, 2, 0.0833, 1700000000, 1700000000)',
      );
      v1.close();

      // --- Open with the current schema: the v2 migration must run --------
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      expect(db.schemaVersion, 2);
      final versionRow = (await db.customSelect('PRAGMA user_version').get())
          .single;
      expect(versionRow.read<int>('user_version'), 2);

      // The old columns are gone and the new ones are present.
      final unitColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('unit')")
          .get();
      final unitColumnNames = unitColumns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(unitColumnNames, contains('unit_name'));
      expect(unitColumnNames, contains('description'));
      expect(unitColumnNames, isNot(contains('unit_code')));
      expect(unitColumnNames, isNot(contains('base_unit_id')));
      expect(unitColumnNames, isNot(contains('factor_to_base')));

      final conversionColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('uom_conversion')")
          .get();
      expect(
        conversionColumns.map((row) => row.read<String>('name')),
        contains('description'),
      );

      final productUomColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('product_uom')")
          .get();
      final productUomColumnNames = productUomColumns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(productUomColumnNames, containsAll([
        'from_unit_id',
        'to_unit_id',
        'is_default',
      ]));
      expect(productUomColumnNames, isNot(contains('unit_id')));

      // Data survives the rebuild and remains queryable through Drift.
      final units = await db.select(db.units).get();
      expect(units, hasLength(2));
      expect(units.first.unitName, 'Piece');
      expect(units.first.description, isNull);

      final conversions = await db.select(db.uomConversions).get();
      expect(conversions, hasLength(2));
      // The user-defined row survived.
      expect(
        conversions.any(
          (c) => c.fromUnitId == 1 && c.toUnitId == 2 && c.conversionFactor == 0.0833,
        ),
        isTrue,
      );
      // The old base relationship (Dozen -> Piece, 12) was backfilled from
      // base_unit_id / factor_to_base before those columns were dropped.
      expect(
        conversions.any(
          (c) => c.fromUnitId == 2 && c.toUnitId == 1 && c.conversionFactor == 12.0,
        ),
        isTrue,
      );

      // The indexes for the rebuilt tables were recreated.
      final indexNames = await _indexNames(db);
      expect(indexNames, containsAll([
        'idx_unit_family',
        'idx_unit_name_nocase_unique',
        'idx_product_uom_one_default',
      ]));
    });
  });
}
