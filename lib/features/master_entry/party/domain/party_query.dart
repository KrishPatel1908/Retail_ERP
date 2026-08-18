/// A single page of party records plus the total number of matching rows,
/// used to drive server-side pagination in the list tables.
class PartyPage<T> {
  const PartyPage({required this.items, required this.totalCount});

  final List<T> items;

  /// Number of rows matching the current query/filters across all pages.
  final int totalCount;
}

/// Opening balance filter options.
enum OpeningBalanceFilterOption {
  all('All'),
  debit('Debit'),
  credit('Credit');

  const OpeningBalanceFilterOption(this.label);
  final String label;
}

/// Server-side filters for the party list pages.
///
/// A `null` field means "no filter". [isEmpty] tells the UI whether the
/// filters toolbar has anything active to clear.
class PartyFilters {
  const PartyFilters({
    this.isActive,
    this.city,
    this.state,
    this.openingBalanceOption = OpeningBalanceFilterOption.all,
    this.minOpeningBalance,
    this.maxOpeningBalance,
    this.dueFrom,
    this.dueTo,
    this.createdFrom,
    this.createdTo,
  });

  final bool? isActive;
  final String? city;
  final String? state;
  final OpeningBalanceFilterOption openingBalanceOption;

  /// Minimum opening balance in paise.
  final int? minOpeningBalance;

  /// Maximum opening balance in paise.
  final int? maxOpeningBalance;

  final DateTime? dueFrom;
  final DateTime? dueTo;
  final DateTime? createdFrom;
  final DateTime? createdTo;

  bool get isEmpty =>
      isActive == null &&
      city == null &&
      state == null &&
      openingBalanceOption == OpeningBalanceFilterOption.all &&
      minOpeningBalance == null &&
      maxOpeningBalance == null &&
      dueFrom == null &&
      dueTo == null &&
      createdFrom == null &&
      createdTo == null;
}

/// Columns the party list can be sorted on. Sorting happens in the database
/// so it composes with pagination and filtering.
enum PartySortColumn {
  code('code'),
  name('name'),
  mobile('mobile'),
  city('city'),
  state('state'),
  openingBalance('openingBalance'),
  paymentDueDate('paymentDueDate'),
  creditLimit('creditLimit'),
  createdAt('createdAt');

  const PartySortColumn(this.dbValue);

  /// Identifier used by the UI to remember the active sort.
  final String dbValue;
}
