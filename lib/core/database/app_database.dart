import 'package:drift/drift.dart';

import 'migrations/database_migration_strategy.dart';
import 'migrations/migration_versions.dart';
import 'tables/brand_table.dart';
import 'tables/category_table.dart';
import 'tables/company_settings_table.dart';
import 'tables/customer_table.dart';
import 'tables/document_number_sequence_table.dart';
import 'tables/product_table.dart';
import 'tables/product_uom_table.dart';
import 'tables/sub_category_table.dart';
import 'tables/supplier_table.dart';
import 'tables/tax_category_rate_table.dart';
import 'tables/tax_category_table.dart';
import 'tables/tax_type_table.dart';
import 'tables/unit_table.dart';
import 'tables/uom_conversion_table.dart';
import 'tables/warehouse_table.dart';
import 'tables/purchase_table.dart';
import 'tables/purchase_item_table.dart';
import 'tables/inventory_transaction_table.dart';
import 'tables/current_stock_table.dart';

part 'app_database.g.dart';

/// The application database.
///
/// Registers every table of the approved master-entry blueprint and owns the
/// schema migrations. This class only registers the schema — repositories
/// and business logic live inside their respective features.
@DriftDatabase(
  tables: [
    CompanySettingsTable,
    Categories,
    SubCategories,
    Brands,
    Units,
    UomConversions,
    TaxCategories,
    TaxCategoryRates,
    TaxTypes,
    Customers,
    Suppliers,
    Warehouses,
    Products,
    ProductVariants,
    ProductUoms,
    DocumentNumberSequences,
    Purchases,
    PurchaseItems,
    InventoryTransactions,
    CurrentStocks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => DatabaseSchemaVersion.latest;

  @override
  MigrationStrategy get migration => DatabaseMigrationStrategy(this).strategy;
}
