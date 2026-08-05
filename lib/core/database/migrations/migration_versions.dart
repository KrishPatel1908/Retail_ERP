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

  /// The current schema version of the application.
  static const int latest = v2;
}
