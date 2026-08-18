import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/exceptions/supplier_exceptions.dart';
import '../../../party/domain/party_query.dart';
import '../../../party/presentation/widgets/party_delete_dialog.dart';
import '../../../party/presentation/widgets/party_filters_bar.dart';
import '../../../party/presentation/widgets/party_table.dart';
import '../widgets/supplier_detail_dialog.dart';

/// Supplier Master list page.
///
/// Loads suppliers through [SupplierRepository] with server-side search,
/// filtering, sorting and pagination, and renders them in the shared party
/// table. Never touches Drift directly.
class SupplierListPage extends StatefulWidget {
  const SupplierListPage({
    super.key,
    required this.onAddSupplier,
    required this.onEditSupplier,
  });

  final VoidCallback onAddSupplier;
  final ValueChanged<Supplier> onEditSupplier;

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  late final SupplierRepository _repository;

  List<Supplier> _suppliers = const [];
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
    _repository = SupplierRepository();
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
      _loading = _suppliers.isEmpty;
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
        _suppliers = result.items;
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

  Future<void> _confirmDelete(Supplier supplier) async {
    final confirmed = await showPartyDeleteConfirmDialog(
      context,
      title: 'Delete supplier?',
      message:
          'Delete "${supplier.supplierName}"? This action cannot be undone.',
    );
    if (!confirmed || !mounted) return;

    try {
      await _repository.deleteSupplier(supplier.id);
      if (!mounted) return;
      _showSnackBar('Supplier deleted successfully.');
      // If the last row of a page was deleted, step back one page.
      if (_suppliers.length == 1 && _page > 1) {
        setState(() => _page -= 1);
      }
      await _load();
      await _loadFilterOptions();
    } on SupplierInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete supplier. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete supplier. Please try again.');
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

  void _showSupplierDetails(Supplier supplier) {
    showSupplierDetailDialog(
      context,
      supplier: supplier,
      onEdit: () {
        Navigator.pop(context);
        widget.onEditSupplier(supplier);
      },
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load suppliers',
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
    return PartyTable<Supplier>(
      items: _suppliers,
      totalCount: _totalCount,
      page: _page,
      pageSize: _pageSize,
      onPageChanged: _onPageChanged,
      onPageSizeChanged: _onPageSizeChanged,
      codeHeaderLabel: 'Supplier Code',
      nameHeaderLabel: 'Business Name',
      codeOf: (s) => s.supplierCode,
      nameOf: (s) => s.supplierName,
      mobileOf: (s) => s.mobile,
      cityOf: (s) => s.city,
      stateOf: (s) => s.state,
      openingBalanceOf: (s) => s.openingBalance,
      balanceTypeOf: (s) => s.balanceType,
      creditLimitOf: (s) => s.creditLimit,
      paymentDueDateOf: (s) => s.paymentDueDate,
      createdAtOf: (s) => s.createdAt,
      isActiveOf: (s) => s.isActive,
      idOf: (s) => s.id,
      onView: _showSupplierDetails,
      onEdit: widget.onEditSupplier,
      onDelete: _confirmDelete,
      keyPrefix: 'supplier',
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      isLoading: _loading,
      emptyWidget: EmptyState(
        icon: Icons.local_shipping_outlined,
        title: _query.isEmpty && !_hasActiveFilters
            ? 'No suppliers yet'
            : 'No suppliers found',
        message: _query.isEmpty && !_hasActiveFilters
            ? 'Click "Add Supplier" to create your first supplier.'
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
              title: 'Supplier Master',
              description:
                  'Manage the suppliers you purchase from and track your '
                  'payable balances.',
              breadcrumbs: const ['Master Entry', 'Supplier Master'],
              actions: [
                FilledButton.icon(
                  key: const ValueKey('add-supplier-button'),
                  onPressed: widget.onAddSupplier,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Supplier'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PartyFiltersBar(
              searchHint: 'Search suppliers...',
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
