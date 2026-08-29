import '../app_database.dart';

/// The indexes required by the approved blueprint.
///
/// Drift no longer exposes column-level `COLLATE NOCASE` on schema builders,
/// so the blueprint's case-insensitive uniqueness guarantees
/// ("Samsung" vs "samsung" must not coexist) are enforced with explicit
/// `CREATE UNIQUE INDEX ... COLLATE NOCASE` statements.
///
/// The unit and product_uom indexes are also declared here (instead of as
/// `@TableIndex` annotations) so the schema-v2 migration — which rebuilds
/// both tables — and the fresh-create path share a single source of truth.
class DatabaseIndexes {
  const DatabaseIndexes._();

  /// Description of a single case-insensitive unique index.
  ///
  /// [table] and [columns] are SQL identifiers of the approved schema.
  static const List<({String name, String table, List<String> columns})>
  _noCaseUniqueIndexes = [
    (
      name: 'idx_category_name_nocase_unique',
      table: 'category',
      columns: ['category_name'],
    ),
    (
      name: 'idx_sub_category_name_nocase_unique',
      table: 'sub_category',
      columns: ['category_id', 'sub_category_name'],
    ),
    (
      name: 'idx_brand_name_nocase_unique',
      table: 'brand',
      columns: ['brand_name'],
    ),
    (
      name: 'idx_unit_name_nocase_unique',
      table: 'unit',
      columns: ['unit_name'],
    ),
    (
      name: 'idx_tax_category_name_nocase_unique',
      table: 'tax_category',
      columns: ['tax_category_name'],
    ),
    (
      name: 'idx_tax_type_code_nocase_unique',
      table: 'tax_type',
      columns: ['tax_type_code'],
    ),
    (
      name: 'idx_customer_gst_nocase_unique',
      table: 'customer',
      columns: ['gst_number'],
    ),
    (
      name: 'idx_customer_email_nocase_unique',
      table: 'customer',
      columns: ['email'],
    ),
    (
      name: 'idx_supplier_gst_nocase_unique',
      table: 'supplier',
      columns: ['gst_number'],
    ),
    (
      name: 'idx_supplier_email_nocase_unique',
      table: 'supplier',
      columns: ['email'],
    ),
  ];

  /// Ordinary (non-unique) lookup indexes for the rebuilt tables.
  static const List<({String name, String table, List<String> columns})>
  _indexes = [
    (name: 'idx_unit_family', table: 'unit', columns: ['unit_family']),
    (
      name: 'idx_product_uom_product',
      table: 'product_uom',
      columns: ['product_id'],
    ),
    (
      name: 'idx_product_uom_from_unit',
      table: 'product_uom',
      columns: ['from_unit_id'],
    ),
    (
      name: 'idx_product_uom_to_unit',
      table: 'product_uom',
      columns: ['to_unit_id'],
    ),
    // Party lookup indexes: filters (city / state / created_at) and the
    // created-date sort run against these columns.
    (name: 'idx_customer_city', table: 'customer', columns: ['city']),
    (name: 'idx_customer_state', table: 'customer', columns: ['state']),
    (
      name: 'idx_customer_created_at',
      table: 'customer',
      columns: ['created_at'],
    ),
    (name: 'idx_supplier_city', table: 'supplier', columns: ['city']),
    (name: 'idx_supplier_state', table: 'supplier', columns: ['state']),
    (
      name: 'idx_supplier_created_at',
      table: 'supplier',
      columns: ['created_at'],
    ),
  ];

  /// Unique partial indexes that cannot be expressed with `@TableIndex`.
  static const List<({String table, String statement})>
  _partialUniqueStatements = [
    // At most one default conversion per product.
    (
      table: 'product_uom',
      statement:
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_product_uom_one_default '
          'ON product_uom (product_id) WHERE is_default = 1',
    ),
    // Unique barcodes when provided for product and product_variant.
    (
      table: 'product',
      statement:
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_product_barcode_unique '
          'ON product (barcode) WHERE barcode IS NOT NULL AND barcode != \'\'',
    ),
    (
      table: 'product_variant',
      statement:
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_variant_barcode_unique '
          'ON product_variant (barcode) WHERE barcode IS NOT NULL AND barcode != \'\'',
    ),
  ];

  /// Creates every index. All statements are idempotent (`IF NOT EXISTS`),
  /// so this can safely run on create and after any table rebuild.
  static Future<void> create(AppDatabase database) {
    return createForTables(database);
  }

  /// Creates indexes, optionally limited to the given [onlyTables].
  ///
  /// The schema-v2 migration rebuilds only `unit` and `product_uom`, so it
  /// recreates just those tables' indexes without touching the others.
  static Future<void> createForTables(
    AppDatabase database, [
    Set<String>? onlyTables,
  ]) async {
    for (final index in _noCaseUniqueIndexes) {
      if (onlyTables != null && !onlyTables.contains(index.table)) continue;
      final columns = index.columns
          .map((column) => '$column COLLATE NOCASE')
          .join(', ');
      await database.customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS ${index.name} '
        'ON ${index.table} ($columns)',
      );
    }
    for (final index in _indexes) {
      if (onlyTables != null && !onlyTables.contains(index.table)) continue;
      await database.customStatement(
        'CREATE INDEX IF NOT EXISTS ${index.name} '
        'ON ${index.table} (${index.columns.join(', ')})',
      );
    }
    for (final item in _partialUniqueStatements) {
      if (onlyTables != null && !onlyTables.contains(item.table)) continue;
      await database.customStatement(item.statement);
    }
  }
}
