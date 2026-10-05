/// Central registry of database schema versions.
///
/// Bump [latest] whenever the schema changes and register a matching upgrade
/// step in [DatabaseMigrationStrategy].
abstract final class DatabaseSchemaVersion {
  /// Schema version 1 — the approved master-entry blueprint (16 tables).
  static const int v1 = 1;

  /// Schema version 2 — measurement-system redesign: the unit table drops
  /// its code/base/factor columns in favour of a standalone description,
  /// conversions gain a description, and product_uom is reshaped to
  /// (product, from unit, to unit, factor) with a per-product default.
  static const int v2 = 2;

  /// Schema version 3 — removes the HSN master table and the product HSN
  /// reference.
  static const int v3 = 3;

  /// Schema version 4 — extends the customer and supplier masters with the
  /// fields required by the sales/purchase modules (PAN, address lines,
  /// balance type, notes, contact person, payment terms) and adds the
  /// lookup indexes for party search and filtering.
  static const int v4 = 4;

  /// Schema version 5 — adds bank details, payment due date, and supplier
  /// credit limit to customer and supplier masters.
  static const int v5 = 5;

  /// Schema version 6 — expands `company_settings` into the full Company
  /// Settings module: legal name, business type, GST registration, CIN, a
  /// two-line business address, invoice numbering, currency symbol and
  /// decimal places, bank details, invoice rendering text/options, and the
  /// logo reference.
  static const int v6 = 6;

  /// Schema version 7 — rebuilds the product table to a simplified design
  /// for the Product Master module: removes inventory/purchase/warehouse
  /// columns and adds tracking flags and notes.
  static const int v7 = 7;

  /// Schema version 8 — adds product variants, expiry date, and removes
  /// obsolete tracking fields from the product table.
  static const int v8 = 8;

  /// Schema version 9 — adds Purchase module tables: purchase, purchase_item,
  /// inventory_transaction, and current_stock.
  static const int v9 = 9;

  /// Schema version 10 — adds purchase_price, mrp, wholesale_price, barcode,
  /// and hsn_code to product and product_variant tables.
  static const int v10 = 10;

  /// Schema version 11 — removes the deferred multi-warehouse feature: drops
  /// the `warehouse` table and its unique index, and rebuilds
  /// `inventory_transaction` and `current_stock` without their always-empty
  /// `warehouse_id` column (existing rows preserved).
  static const int v11 = 11;

  /// Schema version 12 — products reference Tax Categories via a new
  /// `tax_category_id` column (instead of an atomic Tax Type), and the seeded
  /// `tax_category_rate` data is repaired so each seeded category's CGST+SGST
  /// components sum to its intended total.
  static const int v12 = 12;

  /// Schema version 13 — append-only purchase financial transactions.
  static const int v13 = 13;

  /// Schema version 14 — adds purchase_return and purchase_return_item tables
  /// for dedicated purchase return tracking with view/revert/delete workflow.
  static const int v14 = 14;

  /// Schema version 15 — adds the `minimum_stock` column to the product table
  /// for the Inventory module's low-stock status.
  static const int v15 = 15;

  /// Schema version 16 — adds Sales POS module tables: sale, sale_item,
  /// customer_transaction, and adds sale_id reference to inventory_transaction.
  static const int v16 = 16;

  static const int latest = v16;
}
