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

/// The tables of the approved blueprint.
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
  'customer',
  'supplier',
  'product',
  'product_variant',
  'product_uom',
  'document_number_sequence',
  'purchase',
  'purchase_item',
  'inventory_transaction',
  'current_stock',
  'purchase_transaction',
  'purchase_return',
  'purchase_return_item',
};

/// The 10 case-insensitive unique indexes of the approved blueprint. Units
/// are unique by name (schema v2), not by code; customer/supplier emails
/// are unique as of schema v4.
const _noCaseUniqueIndexes = {
  'idx_category_name_nocase_unique',
  'idx_sub_category_name_nocase_unique',
  'idx_brand_name_nocase_unique',
  'idx_unit_name_nocase_unique',
  'idx_tax_category_name_nocase_unique',
  'idx_tax_type_code_nocase_unique',
  'idx_customer_gst_nocase_unique',
  'idx_customer_email_nocase_unique',
  'idx_supplier_gst_nocase_unique',
  'idx_supplier_email_nocase_unique',
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

    test('registers all 22 blueprint tables', () async {
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

      expect(db.schemaVersion, 15);
      await db.customSelect('SELECT 1').get();

      final row = (await db.customSelect('PRAGMA user_version').get()).single;
      expect(row.read<int>('user_version'), 15);
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
      // Each seeded category stores only its CGST+SGST split (no redundant IGST
      // component), so their sums match their names: 0, 5, 12, 18, 28.
      expect((await db.select(db.taxCategoryRates).get()).length, 10);

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

      final dozenToPiece =
          await (db.select(db.uomConversions)
                ..where((c) => c.fromUnitId.equals(2) & c.toUnitId.equals(1)))
              .getSingleOrNull();
      expect(dozenToPiece, isNotNull);
      expect(dozenToPiece!.conversionFactor, 12);

      final kgToGram =
          await (db.select(db.uomConversions)
                ..where((c) => c.fromUnitId.equals(5) & c.toUnitId.equals(6)))
              .getSingleOrNull();
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
                categoryId: Value(electronics),
                subCategoryId: Value(keyboards),
                brandId: const Value(1),
                unitId: 1,
              ),
            );

        // Invalid sub-category that doesn't belong to the category is rejected
        // by the sub_category foreign key.
        await expectLater(
          db
              .into(db.products)
              .insert(
                ProductsCompanion.insert(
                  productCode: 'P-BAD',
                  productName: 'Misplaced product',
                  categoryId: Value(groceries),
                  subCategoryId: const Value(9999),
                  brandId: const Value(1),
                  unitId: 1,
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
              categoryId: Value(categoryId),
              brandId: const Value(1),
              unitId: 1,
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
    test(
      'upgrades a v1 database to the redesigned measurement schema',
      () async {
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

        expect(db.schemaVersion, 15);
        final versionRow =
            (await db.customSelect('PRAGMA user_version').get()).single;
        expect(versionRow.read<int>("user_version"), 15);

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
            .customSelect(
              "SELECT name FROM pragma_table_info('uom_conversion')",
            )
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
        expect(
          productUomColumnNames,
          containsAll(['from_unit_id', 'to_unit_id', 'is_default']),
        );
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
            (c) =>
                c.fromUnitId == 1 &&
                c.toUnitId == 2 &&
                c.conversionFactor == 0.0833,
          ),
          isTrue,
        );
        // The old base relationship (Dozen -> Piece, 12) was backfilled from
        // base_unit_id / factor_to_base before those columns were dropped.
        expect(
          conversions.any(
            (c) =>
                c.fromUnitId == 2 &&
                c.toUnitId == 1 &&
                c.conversionFactor == 12.0,
          ),
          isTrue,
        );

        // The indexes for the rebuilt tables were recreated.
        final indexNames = await _indexNames(db);
        expect(
          indexNames,
          containsAll([
            'idx_unit_family',
            'idx_unit_name_nocase_unique',
            'idx_product_uom_one_default',
          ]),
        );
      },
    );
  });

  group('Migration v2 → v3', () {
    test('removes the HSN table and product HSN field', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_hsn_migration_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      final v2 = sq.sqlite3.open(file.path);
      v2.execute('PRAGMA user_version = 2');
      v2.execute(
        'CREATE TABLE hsn_master ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'hsn_code TEXT NOT NULL)',
      );
      v2.execute(
        'CREATE TABLE product ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'hsn_id INTEGER REFERENCES hsn_master (id))',
      );
      v2.execute('CREATE INDEX idx_product_hsn ON product (hsn_id)');
      v2.close();

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final tableNames = await _tableNames(db);
      expect(tableNames, isNot(contains('hsn_master')));

      final productColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('product')")
          .get();
      expect(
        productColumns.map((row) => row.read<String>('name')),
        isNot(contains('hsn_id')),
      );
    });
  });

  group('Migration v3 → v4', () {
    test('extends the customer and supplier masters', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_party_migration_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      // --- Build a v3 database with the old party shapes ---------------
      final v3 = sq.sqlite3.open(file.path);
      v3.execute('PRAGMA user_version = 3');
      // The v3 customer shape had `credit_limit`; the supplier did not.
      const sharedColumns =
          ', gst_number TEXT, mobile TEXT, '
          'alternate_mobile TEXT, email TEXT, address TEXT, city TEXT, '
          'state TEXT, state_code TEXT, country TEXT, pincode TEXT, '
          'opening_balance INTEGER NOT NULL DEFAULT 0, '
          'outstanding_balance INTEGER NOT NULL DEFAULT 0, '
          'is_active INTEGER NOT NULL DEFAULT 1, '
          'created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL';
      v3.execute(
        'CREATE TABLE customer ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'customer_code TEXT NOT NULL UNIQUE, customer_name TEXT NOT NULL, '
        'credit_limit INTEGER NOT NULL DEFAULT 0$sharedColumns)',
      );
      v3.execute(
        'CREATE TABLE supplier ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'supplier_code TEXT NOT NULL UNIQUE, supplier_name TEXT NOT NULL'
        '$sharedColumns)',
      );
      v3.execute(
        "INSERT INTO customer (id, customer_code, customer_name, address, "
        "city, opening_balance, created_at, updated_at) VALUES "
        "(1, 'CUS00001', 'Old Customer', 'Old Street 5', 'Mumbai', "
        '500000, 1700000000, 1700000000)',
      );
      v3.execute(
        "INSERT INTO supplier (id, supplier_code, supplier_name, address, "
        "city, created_at, updated_at) VALUES "
        "(1, 'SUP00001', 'Old Supplier', 'Warehouse 9', 'Pune', "
        '1700000000, 1700000000)',
      );
      v3.close();

      // --- Open with the current schema: the v4 migration must run ------
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();
      expect(db.schemaVersion, 15);
      final versionRow =
          (await db.customSelect('PRAGMA user_version').get()).single;
      expect(versionRow.read<int>("user_version"), 15);

      // Customer gained the new columns and `address` became line 1.
      final customerColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('customer')")
          .get();
      final customerNames = customerColumns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(
        customerNames,
        containsAll([
          'pan_number',
          'address_line1',
          'address_line2',
          'balance_type',
          'notes',
        ]),
      );
      expect(customerNames, isNot(contains('address')));

      // Supplier gained its module-specific columns too.
      final supplierColumns = await db
          .customSelect("SELECT name FROM pragma_table_info('supplier')")
          .get();
      final supplierNames = supplierColumns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(
        supplierNames,
        containsAll([
          'contact_person',
          'payment_terms',
          'pan_number',
          'address_line1',
          'balance_type',
          'notes',
        ]),
      );

      // Existing data survived: the address value moved to line 1 and the
      // default balance type was backfilled.
      final customers = await db.select(db.customers).get();
      expect(customers, hasLength(1));
      expect(customers.single.addressLine1, 'Old Street 5');
      expect(customers.single.balanceType, 'DEBIT');

      // The new party indexes exist.
      final indexNames = await _indexNames(db);
      expect(
        indexNames,
        containsAll([
          'idx_customer_email_nocase_unique',
          'idx_supplier_email_nocase_unique',
          'idx_customer_city',
          'idx_customer_state',
          'idx_customer_created_at',
          'idx_supplier_city',
          'idx_supplier_state',
          'idx_supplier_created_at',
        ]),
      );
    });
  });

  group('Migration v4 → v5', () {
    test('adds credit limit, payment due date, and bank fields', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_v5_migration_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      final v4 = sq.sqlite3.open(file.path);
      v4.execute('PRAGMA user_version = 4');
      v4.execute(
        'CREATE TABLE customer ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'customer_code TEXT NOT NULL UNIQUE, customer_name TEXT NOT NULL, '
        'credit_limit INTEGER NOT NULL DEFAULT 0, opening_balance INTEGER NOT NULL DEFAULT 0, '
        'outstanding_balance INTEGER NOT NULL DEFAULT 0, balance_type TEXT NOT NULL DEFAULT "DEBIT", '
        'is_active INTEGER NOT NULL DEFAULT 1, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
      );
      v4.execute(
        'CREATE TABLE supplier ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'supplier_code TEXT NOT NULL UNIQUE, supplier_name TEXT NOT NULL, '
        'opening_balance INTEGER NOT NULL DEFAULT 0, outstanding_balance INTEGER NOT NULL DEFAULT 0, '
        'balance_type TEXT NOT NULL DEFAULT "DEBIT", is_active INTEGER NOT NULL DEFAULT 1, '
        'created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
      );
      v4.close();

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();
      expect(db.schemaVersion, 15);

      final customerCols =
          (await db
                  .customSelect(
                    "SELECT name FROM pragma_table_info('customer')",
                  )
                  .get())
              .map((r) => r.read<String>('name'))
              .toSet();
      expect(
        customerCols,
        containsAll([
          'payment_due_date',
          'account_name',
          'account_number',
          'bank_name',
          'branch_name',
          'ifsc_code',
        ]),
      );

      final supplierCols =
          (await db
                  .customSelect(
                    "SELECT name FROM pragma_table_info('supplier')",
                  )
                  .get())
              .map((r) => r.read<String>('name'))
              .toSet();
      expect(
        supplierCols,
        containsAll([
          'credit_limit',
          'payment_due_date',
          'account_name',
          'account_number',
          'bank_name',
          'branch_name',
          'ifsc_code',
        ]),
      );
    });
  });

  group('Migration v5 → v6', () {
    test('expands company_settings into the full settings module', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_v6_migration_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      // --- Build a v5 database with the old company_settings shape ---------
      final v5 = sq.sqlite3.open(file.path);
      v5.execute('PRAGMA user_version = 5');
      v5.execute(
        'CREATE TABLE company_settings ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'company_name TEXT NOT NULL, '
        'logo_path TEXT, gst_number TEXT, pan_number TEXT, '
        'email TEXT, mobile TEXT, website TEXT, '
        'address TEXT, city TEXT, state TEXT, state_code TEXT, '
        'country TEXT, pincode TEXT, '
        "currency_code TEXT NOT NULL DEFAULT 'INR', "
        'financial_year_start_month INTEGER NOT NULL DEFAULT 4, '
        "invoice_prefix TEXT NOT NULL DEFAULT 'INV-', "
        "purchase_prefix TEXT NOT NULL DEFAULT 'PUR-', "
        "receipt_prefix TEXT NOT NULL DEFAULT 'RCT-', "
        "timezone TEXT NOT NULL DEFAULT 'Asia/Kolkata', "
        'prices_inclusive_of_tax INTEGER NOT NULL DEFAULT 0, '
        'is_active INTEGER NOT NULL DEFAULT 1, '
        'created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, '
        'CHECK (id = 1))',
      );
      v5.execute(
        "INSERT INTO company_settings (id, company_name, address, city, "
        "created_at, updated_at) VALUES "
        "(1, 'Legacy Shop', 'Old Street 5', 'Mumbai', "
        '1700000000, 1700000000)',
      );
      v5.close();

      // --- Open with the current schema: the v6 migration must run ---------
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();
      expect(db.schemaVersion, 15);
      final versionRow =
          (await db.customSelect('PRAGMA user_version').get()).single;
      expect(versionRow.read<int>("user_version"), 15);

      final columns =
          (await db
                  .customSelect(
                    "SELECT name FROM pragma_table_info('company_settings')",
                  )
                  .get())
              .map((r) => r.read<String>('name'))
              .toSet();
      expect(
        columns,
        containsAll([
          'legal_name',
          'business_type',
          'gst_registered',
          'cin',
          'address_line1',
          'address_line2',
          'currency_symbol',
          'decimal_places',
          'invoice_start_number',
          'bank_name',
          'bank_account_name',
          'bank_account_number',
          'bank_ifsc',
          'bank_branch',
          'upi_id',
          'invoice_footer',
          'invoice_terms',
          'invoice_thank_you_message',
          'show_logo_on_invoice',
          'show_bank_details_on_invoice',
          'show_gst_details_on_invoice',
        ]),
      );
      expect(columns, isNot(contains('address')));

      // Existing data survived: the address moved to line 1, defaults were
      // backfilled, and the singleton row is intact.
      final row = await (db.select(
        db.companySettingsTable,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      expect(row, isNotNull);
      expect(row!.companyName, 'Legacy Shop');
      expect(row.addressLine1, 'Old Street 5');
      expect(row.businessType, 'PROPRIETORSHIP');
      expect(row.gstRegistered, isFalse);
      expect(row.invoiceStartNumber, 1);
      expect(row.currencySymbol, '₹');
      expect(row.decimalPlaces, 2);
      expect(row.showLogoOnInvoice, isTrue);
    });
  });
}
