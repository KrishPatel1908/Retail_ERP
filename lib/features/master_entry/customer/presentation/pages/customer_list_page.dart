import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../data/repositories/customer_repository.dart';
import '../../domain/entities/customer.dart';
import '../../domain/exceptions/customer_exceptions.dart';
import '../../../party/domain/party_query.dart';
import '../../../party/presentation/widgets/party_delete_dialog.dart';
import '../../../party/presentation/widgets/party_filters_bar.dart';
import '../../../party/presentation/widgets/party_table.dart';
import '../widgets/customer_detail_dialog.dart';

/// Customer Master list page.
///
/// Loads customers through [CustomerRepository] with server-side search,
/// filtering, sorting and pagination, and renders them in the shared party
/// table. Never touches Drift directly.
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({
    super.key,
    required this.onAddCustomer,
    required this.onEditCustomer,
  });

  final VoidCallback onAddCustomer;
  final ValueChanged<Customer> onEditCustomer;

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late final CustomerRepository _repository;

  List<Customer> _customers = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  // Server-side list state.
  bool? _statusFilter;
  String? _cityFilter;
  String? _stateFilter;
  OpeningBalanceFilterOption _openingBalanceOption =
      OpeningBalanceFilterOption.all;
  DateTime? _dueFrom;
  DateTime? _dueTo;
  DateTime? _createdFrom;
  DateTime? _createdTo;
  int _page = 1;
  int _pageSize = 25;
  PartySortColumn _sortColumn = PartySortColumn.name;
  bool _sortAscending = true;

  List<String> _cities = const [];
  List<String> _states = const [];

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository();
    _load();
    _loadFilterOptions();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final requestId = ++_searchRequestId;
    setState(() {
      _loading = _customers.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: PartyFilters(
          isActive: _statusFilter,
          city: _cityFilter,
          state: _stateFilter,
          openingBalanceOption: _openingBalanceOption,
          dueFrom: _dueFrom,
          dueTo: _dueTo,
          createdFrom: _createdFrom,
          createdTo: _createdTo,
        ),
        sort: _sortColumn,
        sortAscending: _sortAscending,
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _customers = result.items;
        _totalCount = result.totalCount;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final results = await Future.wait([
        _repository.distinctCities(),
        _repository.distinctStates(),
      ]);
      if (!mounted) return;
      setState(() {
        _cities = results[0];
        _states = results[1];
      });
    } catch (_) {
      // Filter dropdowns simply stay empty; the list still loads.
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim();
      _page = 1;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), _load);
  }

  void _applyFilters() {
    setState(() => _page = 1);
    _load();
  }

  void _onStatusChanged(bool? value) {
    setState(() => _statusFilter = value);
    _applyFilters();
  }

  void _onCityChanged(String? value) {
    setState(() => _cityFilter = value);
    _applyFilters();
  }

  void _onStateChanged(String? value) {
    setState(() => _stateFilter = value);
    _applyFilters();
  }

  void _onOpeningBalanceOptionChanged(OpeningBalanceFilterOption option) {
    setState(() => _openingBalanceOption = option);
    _applyFilters();
  }

  void _onDueRangeChanged(DateTimeRange range) {
    setState(() {
      _dueFrom = range.start;
      _dueTo = range.end;
    });
    _applyFilters();
  }

  void _onCreatedRangeChanged(DateTimeRange range) {
    setState(() {
      _createdFrom = range.start;
      _createdTo = range.end;
    });
    _applyFilters();
  }

  void _clearFilters() {
    setState(() {
      _statusFilter = null;
      _cityFilter = null;
      _stateFilter = null;
      _openingBalanceOption = OpeningBalanceFilterOption.all;
      _dueFrom = null;
      _dueTo = null;
      _createdFrom = null;
      _createdTo = null;
      _page = 1;
    });
    _load();
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumn = _sortForIndex(columnIndex);
      _sortAscending = ascending;
      _page = 1;
    });
    _load();
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  void _onPageSizeChanged(int pageSize) {
    setState(() {
      _pageSize = pageSize;
      _page = 1;
    });
    _load();
  }

  Future<void> _confirmDelete(Customer customer) async {
    final confirmed = await showPartyDeleteConfirmDialog(
      context,
      title: 'Delete customer?',
      message:
          'Delete "${customer.customerName}"? This action cannot be undone.',
    );
    if (!confirmed || !mounted) return;

    try {
      await _repository.deleteCustomer(customer.id);
      if (!mounted) return;
      _showSnackBar('Customer deleted successfully.');
      // If the last row of a page was deleted, step back one page.
      if (_customers.length == 1 && _page > 1) {
        setState(() => _page -= 1);
      }
      await _load();
      await _loadFilterOptions();
    } on CustomerInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete customer. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete customer. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  bool get _hasActiveFilters =>
      _statusFilter != null ||
      _cityFilter != null ||
      _stateFilter != null ||
      _openingBalanceOption != OpeningBalanceFilterOption.all ||
      _dueFrom != null ||
      _dueTo != null ||
      _createdFrom != null ||
      _createdTo != null;

  int get _sortColumnIndex => switch (_sortColumn) {
    PartySortColumn.code => 1,
    PartySortColumn.name => 3,
    PartySortColumn.mobile => 4,
    PartySortColumn.openingBalance => 5,
    PartySortColumn.paymentDueDate => 6,
    PartySortColumn.city => 7,
    PartySortColumn.state => 8,
    PartySortColumn.creditLimit => 9,
    PartySortColumn.createdAt => 10,
  };

  static PartySortColumn _sortForIndex(int index) => switch (index) {
    1 => PartySortColumn.code,
    3 => PartySortColumn.name,
    4 => PartySortColumn.mobile,
    5 => PartySortColumn.openingBalance,
    6 => PartySortColumn.paymentDueDate,
    7 => PartySortColumn.city,
    8 => PartySortColumn.state,
    9 => PartySortColumn.creditLimit,
    10 => PartySortColumn.createdAt,
    _ => PartySortColumn.name,
  };

  void _showCustomerDetails(Customer customer) {
    showCustomerDetailDialog(
      context,
      customer: customer,
      onEdit: () {
        Navigator.pop(context);
        widget.onEditCustomer(customer);
      },
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load customers',
        message:
            'Something went wrong while reading the database. '
            'Please try again.',
        action: OutlinedButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
        ),
      );
    }
    return PartyTable<Customer>(
      items: _customers,
      totalCount: _totalCount,
      page: _page,
      pageSize: _pageSize,
      onPageChanged: _onPageChanged,
      onPageSizeChanged: _onPageSizeChanged,
      codeHeaderLabel: 'Customer Code',
      nameHeaderLabel: 'Customer Name',
      codeOf: (c) => c.customerCode,
      nameOf: (c) => c.customerName,
      mobileOf: (c) => c.mobile,
      cityOf: (c) => c.city,
      stateOf: (c) => c.state,
      openingBalanceOf: (c) => c.openingBalance,
      balanceTypeOf: (c) => c.balanceType,
      creditLimitOf: (c) => c.creditLimit,
      paymentDueDateOf: (c) => c.paymentDueDate,
      createdAtOf: (c) => c.createdAt,
      isActiveOf: (c) => c.isActive,
      idOf: (c) => c.id,
      onView: _showCustomerDetails,
      onEdit: widget.onEditCustomer,
      onDelete: _confirmDelete,
      keyPrefix: 'customer',
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      isLoading: _loading,
      emptyWidget: EmptyState(
        icon: Icons.group_outlined,
        title: _query.isEmpty && !_hasActiveFilters
            ? 'No customers yet'
            : 'No customers found',
        message: _query.isEmpty && !_hasActiveFilters
            ? 'Click "Add Customer" to create your first customer.'
            : 'Try a different search term or clear the filters.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Customer Master',
              description:
                  'Manage the customers you sell to and track their '
                  'receivable balances.',
              breadcrumbs: const ['Master Entry', 'Customer Master'],
              actions: [
                FilledButton.icon(
                  key: const ValueKey('add-customer-button'),
                  onPressed: widget.onAddCustomer,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Customer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PartyFiltersBar(
              searchHint: 'Search customers...',
              onSearchChanged: _onSearchChanged,
              cities: _cities,
              states: _states,
              statusFilter: _statusFilter,
              onStatusChanged: _onStatusChanged,
              cityFilter: _cityFilter,
              onCityChanged: _onCityChanged,
              stateFilter: _stateFilter,
              onStateChanged: _onStateChanged,
              openingBalanceOption: _openingBalanceOption,
              onOpeningBalanceOptionChanged: _onOpeningBalanceOptionChanged,
              dueFrom: _dueFrom,
              dueTo: _dueTo,
              onDueRangeChanged: _onDueRangeChanged,
              createdFrom: _createdFrom,
              createdTo: _createdTo,
              onCreatedRangeChanged: _onCreatedRangeChanged,
              onClear: _clearFilters,
              hasActiveFilters: _hasActiveFilters,
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
}
