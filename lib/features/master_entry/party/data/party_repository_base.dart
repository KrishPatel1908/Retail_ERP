import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';

import '../domain/party_query.dart';

/// Shared implementation details for the customer and supplier repositories.
///
/// Holds the common Drift access plumbing — the database handle, SQLite error
/// classification and small query helpers — so the two party repositories
/// never duplicate it. Members are intentionally public (with doc comments)
/// because the class is abstract and only ever extended by the party
/// repositories.
abstract class PartyRepositoryBase {
  PartyRepositoryBase({db.AppDatabase? database})
    : database = database ?? DatabaseProvider.instance.database;

  /// The Drift database. Subclasses access tables through this handle; the
  /// handle itself never leaks past a repository.
  final db.AppDatabase database;

  /// Trims [value] and returns `null` for blank input.
  String? normalizeOptional(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Distinct, non-empty values of [column] in [table], case-insensitively
  /// grouped and sorted — used to populate the City / State filter dropdowns
  /// so "mumbai" and "Mumbai" collapse into one option.
  Future<List<String>> distinctTextValues({
    required String table,
    required String column,
  }) async {
    final rows = await database
        .customSelect(
          'SELECT $column AS value FROM $table '
          "WHERE $column IS NOT NULL AND $column != '' "
          'GROUP BY $column COLLATE NOCASE '
          'ORDER BY $column COLLATE NOCASE',
        )
        .get();
    return rows.map((row) => row.read<String>('value')).toList();
  }

  // --- SQLite error classification (shared by every repository) -----------

  static const int _sqliteConstraintUnique = 2067;
  static const int _sqliteConstraintForeignKey = 787;

  /// Extracts the underlying [SqliteException], whether it was thrown
  /// directly or wrapped by Drift.
  SqliteException? asSqliteException(Object error) {
    return switch (error) {
      SqliteException exception => exception,
      DriftWrappedException(:final cause) when cause is SqliteException =>
        cause,
      _ => null,
    };
  }

  /// Whether [error] is a UNIQUE constraint violation.
  bool isUniqueViolation(Object error) {
    return asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintUnique;
  }

  /// Whether [error] is a FOREIGN KEY constraint violation.
  bool isForeignKeyViolation(Object error) {
    return asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintForeignKey;
  }

  // --- Shared list-query building -----------------------------------------

  /// Builds the search + filter predicate shared by the party list pages.
  ///
  /// [normalizedQuery] is the raw search text; it is lower-cased here. The
  /// caller passes its own table's columns, keeping the query fully typed.
  /// Returns `null` when no filtering applies, so callers can skip the
  /// WHERE clause entirely.
  Expression<bool>? partyPredicate({
    required GeneratedColumn<String> code,
    required GeneratedColumn<String> name,
    required GeneratedColumn<String> mobile,
    required GeneratedColumn<String> gst,
    required GeneratedColumn<String> city,
    required GeneratedColumn<String> state,
    required GeneratedColumn<bool> isActive,
    required GeneratedColumn<DateTime> createdAt,
    GeneratedColumn<String>? email,
    GeneratedColumn<String>? pan,
    GeneratedColumn<String>? addressLine1,
    GeneratedColumn<String>? addressLine2,
    GeneratedColumn<String>? pincode,
    GeneratedColumn<String>? contactPerson,
    GeneratedColumn<int>? openingBalance,
    GeneratedColumn<String>? balanceType,
    GeneratedColumn<DateTime>? paymentDueDate,
    required String normalizedQuery,
    required PartyFilters filters,
  }) {
    final normalized = normalizedQuery.trim().toLowerCase();
    if (normalized.isEmpty && filters.isEmpty) return null;

    final searchConditions = <Expression<bool>>[];
    if (normalized.isNotEmpty) {
      searchConditions.addAll([
        code.lower().contains(normalized),
        name.lower().contains(normalized),
        mobile.isNotNull() & mobile.lower().contains(normalized),
        gst.isNotNull() & gst.lower().contains(normalized),
        city.isNotNull() & city.lower().contains(normalized),
        state.isNotNull() & state.lower().contains(normalized),
        if (email != null)
          email.isNotNull() & email.lower().contains(normalized),
        if (pan != null) pan.isNotNull() & pan.lower().contains(normalized),
        if (addressLine1 != null)
          addressLine1.isNotNull() & addressLine1.lower().contains(normalized),
        if (addressLine2 != null)
          addressLine2.isNotNull() & addressLine2.lower().contains(normalized),
        if (pincode != null)
          pincode.isNotNull() & pincode.lower().contains(normalized),
        if (contactPerson != null)
          contactPerson.isNotNull() &
              contactPerson.lower().contains(normalized),
      ]);
    }

    final conditions = <Expression<bool>>[
      if (searchConditions.isNotEmpty) searchConditions.reduce((a, b) => a | b),
      if (filters.isActive != null) isActive.equals(filters.isActive!),
      if (filters.city != null) city.equals(filters.city!),
      if (filters.state != null) state.equals(filters.state!),
      if (openingBalance != null) ...[
        if (filters.openingBalanceOption == OpeningBalanceFilterOption.debit &&
            balanceType != null)
          balanceType.equals('DEBIT') & openingBalance.isNotValue(0),
        if (filters.openingBalanceOption == OpeningBalanceFilterOption.credit &&
            balanceType != null)
          balanceType.equals('CREDIT') & openingBalance.isNotValue(0),
        if (filters.minOpeningBalance != null)
          openingBalance.isBiggerOrEqualValue(filters.minOpeningBalance!),
        if (filters.maxOpeningBalance != null)
          openingBalance.isSmallerOrEqualValue(filters.maxOpeningBalance!),
      ],
      if (paymentDueDate != null) ...[
        if (filters.dueFrom != null)
          paymentDueDate.isBiggerOrEqualValue(startOfDay(filters.dueFrom!)),
        if (filters.dueTo != null)
          paymentDueDate.isSmallerOrEqualValue(endOfDay(filters.dueTo!)),
      ],
      if (filters.createdFrom != null)
        createdAt.isBiggerOrEqualValue(startOfDay(filters.createdFrom!)),
      if (filters.createdTo != null)
        createdAt.isSmallerOrEqualValue(endOfDay(filters.createdTo!)),
    ];
    return conditions.reduce((a, b) => a & b);
  }

  /// Builds the ORDER BY term shared by the party list pages.
  OrderingTerm partyOrderBy({
    required GeneratedColumn<String> code,
    required GeneratedColumn<String> name,
    required GeneratedColumn<String> mobile,
    required GeneratedColumn<String> city,
    required GeneratedColumn<String> state,
    required GeneratedColumn<int> openingBalance,
    GeneratedColumn<DateTime>? paymentDueDate,
    GeneratedColumn<int>? creditLimit,
    required GeneratedColumn<DateTime> createdAt,
    required PartySortColumn sort,
    required bool ascending,
  }) {
    final Expression column = switch (sort) {
      PartySortColumn.code => code.lower(),
      PartySortColumn.name => name.lower(),
      PartySortColumn.mobile => mobile.lower(),
      PartySortColumn.city => city.lower(),
      PartySortColumn.state => state.lower(),
      PartySortColumn.openingBalance => openingBalance,
      PartySortColumn.paymentDueDate => paymentDueDate ?? createdAt,
      PartySortColumn.creditLimit => creditLimit ?? openingBalance,
      PartySortColumn.createdAt => createdAt,
    };
    return ascending ? OrderingTerm.asc(column) : OrderingTerm.desc(column);
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}
