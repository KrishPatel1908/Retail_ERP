import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/description_preview.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../domain/entities/purchase.dart';
import '../widgets/purchase_detail_dialog.dart';

/// Purchase History list page with server-side search, filtering,
/// pagination, and sorting.
class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({
    super.key,
    required this.onNewPurchase,
    required this.onEditPurchase,
  });

  final VoidCallback onNewPurchase;
  final ValueChanged<PurchaseEntity> onEditPurchase;

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late final PurchaseRepository _repository;

  List<PurchaseEntity> _purchases = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  // Filter state.
  int? _supplierId;
  PurchasePaymentStatus? _paymentStatus;
  DateTime? _purchaseDateFrom;
  DateTime? _purchaseDateTo;
  int? _minAmount;
  int? _maxAmount;
  int? _createdFrom;
  int? _createdTo;

  // List state.
  int _page = 1;
  int _pageSize = 25;
  PurchaseSortColumn _sortColumn = PurchaseSortColumn.purchaseDate;
  bool _sortAscending = false;

  // Filter dropdown data.
  List<({int id, String name})> _suppliers = const [];

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    _repository = PurchaseRepository();
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
      _loading = _purchases.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: PurchaseFilters(
          supplierId: _supplierId,
          paymentStatus: _paymentStatus,
          purchaseDateFrom: _purchaseDateFrom,
          purchaseDateTo: _purchaseDateTo,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
          createdFrom: _createdFrom != null
              ? DateTime.fromMillisecondsSinceEpoch(_createdFrom!)
              : null,
          createdTo: _createdTo != null
              ? DateTime.fromMillisecondsSinceEpoch(_createdTo!)
              : null,
          isReturn: false,
        ),
        sort: _sortColumn,
        sortAscending: _sortAscending,
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _purchases = result.items;
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
      final suppliers = await _repository.distinctSuppliers();
      if (!mounted) return;
      setState(() => _suppliers = suppliers);
    } catch (_) {}
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

  void _clearFilters() {
    setState(() {
      _supplierId = null;
      _paymentStatus = null;
      _purchaseDateFrom = null;
      _purchaseDateTo = null;
      _minAmount = null;
      _maxAmount = null;
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

  bool get _hasActiveFilters =>
      _supplierId != null ||
      _paymentStatus != null ||
      _purchaseDateFrom != null ||
      _purchaseDateTo != null ||
      _minAmount != null ||
      _maxAmount != null ||
      _createdFrom != null ||
      _createdTo != null;

  int get _sortColumnIndex => switch (_sortColumn) {
        PurchaseSortColumn.purchaseNumber => 1,
        PurchaseSortColumn.supplierName => 3,
        PurchaseSortColumn.purchaseDate => 7,
        PurchaseSortColumn.totalAmount => 6,
        PurchaseSortColumn.dueAmount => 4,
        PurchaseSortColumn.paymentStatus => 8,
        PurchaseSortColumn.createdAt => 9,
      };

  static PurchaseSortColumn _sortForIndex(int index) => switch (index) {
        1 => PurchaseSortColumn.purchaseNumber,
        3 => PurchaseSortColumn.supplierName,
        6 => PurchaseSortColumn.totalAmount,
        4 => PurchaseSortColumn.dueAmount,
        7 => PurchaseSortColumn.purchaseDate,
        8 => PurchaseSortColumn.paymentStatus,
        9 => PurchaseSortColumn.createdAt,
        _ => PurchaseSortColumn.purchaseDate,
      };

  void _showPurchaseDetails(PurchaseEntity purchase) async {
    final full = await _repository.getById(purchase.id);
    if (!mounted) return;
    showPurchaseDetailDialog(
      context,
      purchase: full,
      onEdit: () {
        Navigator.pop(context);
        widget.onEditPurchase(full);
      },
    );
  }

  /// Loads the full purchase (with line items) and opens it in edit mode.
  Future<void> _editPurchase(PurchaseEntity purchase) async {
    try {
      final full = await _repository.getById(purchase.id);
      if (!mounted) return;
      widget.onEditPurchase(full);
    } catch (_) {
      _showFailure('Could not load the purchase for editing.');
    }
  }

  Future<void> _confirmDelete(PurchaseEntity purchase) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Purchase'),
          content: Text(
            'Are you sure you want to delete purchase ${purchase.purchaseNumber}'
            ' for ${purchase.supplierName}?\n\n'
            'This will permanently remove the purchase and reverse its '
            'inventory and financial effect.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _repository.deletePurchase(purchase.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Purchase ${purchase.purchaseNumber} deleted.'),
        ));
      _load();
    } on PurchaseDeletionException catch (e) {
      _showFailure(e.message);
    } catch (_) {
      _showFailure('Failed to delete the purchase. Please try again.');
    }
  }

  void _showFailure(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Purchase',
              description: 'Record and manage products purchased from suppliers.',
              breadcrumbs: const ['Purchase', 'Purchase History'],
              actions: [
                FilledButton.icon(
                  onPressed: widget.onNewPurchase,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New Purchase'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search + Filters.
            ContentPanel(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          hintText: 'Search purchase no., supplier, invoice...',
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => setState(
                            () => _filtersExpanded = !_filtersExpanded),
                        icon: Icon(
                          _filtersExpanded
                              ? Icons.filter_list_off_rounded
                              : Icons.filter_list_rounded,
                          size: 18,
                        ),
                        label: Text(
                            _hasActiveFilters ? 'Filters ●' : 'Filters'),
                      ),
                      if (_hasActiveFilters) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear'),
                        ),
                      ],
                    ],
                  ),
                  if (_filtersExpanded) ...[
                    const SizedBox(height: 16),
                    _buildFiltersRow(colorScheme, textTheme),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Data table.
            Expanded(
              child: _error != null
                  ? EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load purchases',
                      message:
                          'Something went wrong while reading the database. Please try again.',
                      action: OutlinedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                      ),
                    )
                  : _buildTable(colorScheme, textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Loading data...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _purchases.isEmpty
                    ? EmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: _query.isEmpty && !_hasActiveFilters
                            ? 'No purchases yet'
                            : 'No purchases found',
                        message: _query.isEmpty && !_hasActiveFilters
                            ? 'Click "New Purchase" to record your first purchase.'
                            : 'Try a different search term or clear the filters.',
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeaderRow(colorScheme, textTheme),
                              ListView.builder(
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _purchases.length,
                                itemBuilder: (context, index) =>
                                    _buildDataRow(
                                        _purchases[index], colorScheme, textTheme),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          if (!_loading) _buildPaginationFooter(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.hover,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // Action
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Action',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Purchase No.
          SizedBox(
            width: 130,
            child: _buildSortableHeader(1, 'Purchase No.', textTheme),
          ),
          // Invoice No.
          const SizedBox(
            width: 110,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Invoice No.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Supplier
          Expanded(
            flex: 2,
            child: _buildSortableHeader(3, 'Supplier', textTheme),
          ),
          // Credit
          SizedBox(
            width: 110,
            child: _buildSortableHeader(4, 'Credit', textTheme, numeric: true),
          ),
          // Debit
          const SizedBox(
            width: 110,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Debit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // Total (running balance)
          SizedBox(
            width: 130,
            child: _buildSortableHeader(6, 'Total', textTheme, numeric: true),
          ),
          // Date
          SizedBox(
            width: 100,
            child: _buildSortableHeader(7, 'Date', textTheme),
          ),
          // Status
          SizedBox(
            width: 100,
            child: _buildSortableHeader(8, 'Status', textTheme),
          ),
          // Note
          const SizedBox(
            width: 140,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Note',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(
    int index,
    String label,
    TextTheme textTheme, {
    bool numeric = false,
  }) {
    final isSorted = _sortColumnIndex == index;
    final align = numeric ? Alignment.centerRight : Alignment.centerLeft;

    return InkWell(
      onTap: () {
        final ascending = isSorted ? !_sortAscending : true;
        _onSort(index, ascending);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: align,
        child: Row(
          mainAxisSize: numeric ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: isSorted
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isSorted
                  ? (_sortAscending
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded)
                  : Icons.unfold_more_rounded,
              size: 14,
              color: isSorted ? AppTheme.primary : AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(
    PurchaseEntity purchase,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final statusColor = switch (purchase.paymentStatus) {
      PurchasePaymentStatus.paid => AppTheme.success,
      PurchasePaymentStatus.partial => AppTheme.warning,
      PurchasePaymentStatus.unpaid => AppTheme.danger,
    };

    final credit = purchase.dueAmount;
    final debit = purchase.paidAmount;
    final balance = purchase.runningBalance ?? credit - debit;

    String formatDate(DateTime date) {
      final local = date.toLocal();
      return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
    }

    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Action
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionIcon(
                    icon: Icons.visibility_outlined,
                    tooltip: 'View',
                    onTap: () => _showPurchaseDetails(purchase),
                  ),
                  const SizedBox(width: 2),
                  _ActionIcon(
                    icon: Icons.edit_outlined,
                    tooltip: 'Edit',
                    onTap: () => _editPurchase(purchase),
                  ),
                  const SizedBox(width: 2),
                  _ActionIcon(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Delete',
                    color: AppTheme.danger,
                    onTap: () => _confirmDelete(purchase),
                  ),
                ],
              ),
            ),
          ),
          // Purchase No.
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                purchase.purchaseNumber,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Invoice No.
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                purchase.invoiceNumber ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Supplier
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                purchase.supplierName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          // Credit (was Due)
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatCurrency(credit),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: credit > 0 ? AppTheme.danger : AppTheme.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // Debit (was Paid)
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatCurrency(debit),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: debit > 0 ? AppTheme.success : AppTheme.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // Total (running balance)
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatSignedCurrency(balance),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: balance > 0
                      ? AppTheme.primary
                      : (balance < 0 ? AppTheme.danger : AppTheme.textPrimary),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // Date
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                formatDate(purchase.purchaseDate),
                style: textTheme.bodySmall,
              ),
            ),
          ),
          // Status
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  purchase.paymentStatus.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // Note
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DescriptionPreview(
                description: purchase.notes,
                maxLines: 1,
                style: textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(ColorScheme colorScheme, TextTheme textTheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Supplier',
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: _supplierId,
                isDense: true,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<int>(
                    child: Text('All Suppliers'),
                  ),
                  for (final s in _suppliers)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (value) {
                  setState(() {
                    _supplierId =
                        value == _suppliers.firstOrNull?.id ? null : value;
                  });
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Status',
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<PurchasePaymentStatus?>(
                initialValue: _paymentStatus,
                isDense: true,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<PurchasePaymentStatus?>(
                    child: Text('All Statuses'),
                  ),
                  for (final s in PurchasePaymentStatus.values)
                    DropdownMenuItem(
                        value: s, child: Text(s.label)),
                ],
                onChanged: (value) {
                  setState(() => _paymentStatus = value);
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: 170,
          child: _buildDateFilterField(
            label: 'From',
            value: _purchaseDateFrom,
            onPicked: (d) {
              setState(() => _purchaseDateFrom = d);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 170,
          child: _buildDateFilterField(
            label: 'To',
            value: _purchaseDateTo,
            onPicked: (d) {
              setState(() => _purchaseDateTo = d);
              _applyFilters();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilterField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onPicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              helpText: 'Select $label date',
            );
            if (picked != null) onPicked(picked);
          },
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: const InputDecoration(),
            isEmpty: value == null,
            child: Text(
              value == null
                  ? label
                  : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}',
              style: TextStyle(
                color: value == null
                    ? AppTheme.textMuted
                    : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final total = _totalCount;
    final start = total == 0 ? 0 : ((_page - 1) * _pageSize) + 1;
    final end = (_page * _pageSize) > total ? total : (_page * _pageSize);
    final maxPage = (total / _pageSize).ceil().clamp(1, 999999);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Showing $start to $end of $total entries',
                style: textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Text('Rows per page:', style: textTheme.bodySmall),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _pageSize,
                isDense: true,
                underline: const SizedBox.shrink(),
                items: [10, 25, 50, 100].map((sz) {
                  return DropdownMenuItem<int>(
                    value: sz,
                    child: Text('$sz',
                        style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) _onPageSizeChanged(val);
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.chevron_left_rounded, size: 20),
                onPressed: (_page > 1)
                    ? () => _onPageChanged(_page - 1)
                    : null,
                tooltip: 'Previous page',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Page $_page of $maxPage',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded,
                    size: 20),
                onPressed: (_page < maxPage)
                    ? () => _onPageChanged(_page + 1)
                    : null,
                tooltip: 'Next page',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }

  /// Formats the running balance with an explicit sign: "+₹20,000", "-₹5,000",
  /// or "₹0" for a settled account.
  static String _formatSignedCurrency(int paise) {
    if (paise == 0) return '₹0';
    final rupees = paise.abs() / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    final sign = paise > 0 ? '+' : '-';
    return '$sign₹$text';
  }
}

/// Action icon button for the table.
class _ActionIcon extends StatefulWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? AppTheme.textSecondary;
    final activeColor = widget.color ?? AppTheme.primary;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _hovered
                ? (widget.color ?? AppTheme.primary).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? activeColor : baseColor,
            ),
            onPressed: widget.onTap,
          ),
        ),
      ),
    );
  }
}
