import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/description_preview.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../data/repositories/purchase_return_repository.dart';
import '../../domain/entities/purchase_return.dart';
import '../widgets/purchase_return_detail_dialog.dart';

/// Purchase Return History list page with server-side search, filtering and
/// pagination. Supports View, Revert and Delete actions (no Edit).
class PurchaseReturnHistoryPage extends StatefulWidget {
  const PurchaseReturnHistoryPage({super.key, required this.onNewReturn});

  final VoidCallback onNewReturn;

  @override
  State<PurchaseReturnHistoryPage> createState() =>
      _PurchaseReturnHistoryPageState();
}

class _PurchaseReturnHistoryPageState extends State<PurchaseReturnHistoryPage> {
  late final PurchaseReturnRepository _repository;

  List<PurchaseReturnEntity> _returns = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  // Filter state.
  int? _supplierId;
  DateTime? _returnDateFrom;
  DateTime? _returnDateTo;
  PurchaseReturnStatus? _status;

  int _page = 1;
  final int _pageSize = 25;

  // Filter dropdown data.
  List<({int id, String name})> _suppliers = const [];

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    _repository = PurchaseReturnRepository();
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
      _loading = _returns.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: PurchaseReturnFilters(
          supplierId: _supplierId,
          returnDateFrom: _returnDateFrom,
          returnDateTo: _returnDateTo,
          status: _status,
        ),
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _returns = result.items;
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
      _returnDateFrom = null;
      _returnDateTo = null;
      _status = null;
      _page = 1;
    });
    _load();
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  bool get _hasActiveFilters =>
      _supplierId != null ||
      _returnDateFrom != null ||
      _returnDateTo != null ||
      _status != null;

  Future<void> _showDetails(PurchaseReturnEntity purchaseReturn) async {
    try {
      final full = await _repository.getById(purchaseReturn.id);
      if (!mounted) return;
      showPurchaseReturnDetailDialog(context, purchaseReturn: full);
    } catch (_) {
      _showFailure('Could not load the return details.');
    }
  }

  Future<void> _confirmRevert(PurchaseReturnEntity purchaseReturn) async {
    if (purchaseReturn.isReverted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Revert Purchase Return'),
          content: Text(
            'Revert return ${purchaseReturn.returnNumber}?\n\n'
            'This will reverse the inventory and supplier effect of this '
            'return while keeping the original return in history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Revert'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    try {
      await _repository.revertReturn(purchaseReturn.id);
      if (!mounted) return;
      _showMessage('Return ${purchaseReturn.returnNumber} reverted.');
      _load();
    } on PurchaseReturnOperationException catch (e) {
      _showFailure(e.message);
    } catch (_) {
      _showFailure('Failed to revert the return. Please try again.');
    }
  }

  Future<void> _confirmDelete(PurchaseReturnEntity purchaseReturn) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Purchase Return'),
          content: Text(
            'Are you sure you want to permanently delete this purchase '
            'return? Return ${purchaseReturn.returnNumber}\n\n'
            'This will remove the return, its items, its inventory and '
            'supplier transactions. This cannot be undone.',
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
      await _repository.deleteReturn(purchaseReturn.id);
      if (!mounted) return;
      _showMessage('Return ${purchaseReturn.returnNumber} deleted.');
      _load();
    } on PurchaseReturnOperationException catch (e) {
      _showFailure(e.message);
    } catch (_) {
      _showFailure('Failed to delete the return. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
              title: 'Purchase Return History',
              description: 'Track products returned to suppliers.',
              breadcrumbs: const ['Purchase', 'Purchase Return'],
              actions: [
                FilledButton.icon(
                  onPressed: widget.onNewReturn,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New Return'),
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
                          hintText: 'Search return no., purchase, supplier...',
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => setState(
                          () => _filtersExpanded = !_filtersExpanded,
                        ),
                        icon: Icon(
                          _filtersExpanded
                              ? Icons.filter_list_off_rounded
                              : Icons.filter_list_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _hasActiveFilters ? 'Filters ●' : 'Filters',
                        ),
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
                    _buildFiltersRow(textTheme),
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
                      title: 'Could not load returns',
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
                            child: CircularProgressIndicator(strokeWidth: 2.5),
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
                : _returns.isEmpty
                ? EmptyState(
                    icon: Icons.assignment_return_outlined,
                    title: _query.isEmpty && !_hasActiveFilters
                        ? 'No purchase returns'
                        : 'No purchase returns found',
                    message: _query.isEmpty && !_hasActiveFilters
                        ? 'Returns will appear here when products are returned to suppliers.'
                        : 'Try a different search term or clear the filters.',
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeaderRow(colorScheme, textTheme),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _returns.length,
                            itemBuilder: (context, index) => _buildDataRow(
                              _returns[index],
                              colorScheme,
                              textTheme,
                            ),
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
    final cell = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: AppTheme.textSecondary,
    );

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.hover,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          SizedBox(width: 130, child: _pad('Action', cell)),
          SizedBox(width: 130, child: _pad('Return No.', cell)),
          SizedBox(width: 130, child: _pad('Purchase No.', cell)),
          SizedBox(width: 110, child: _pad('Invoice No.', cell)),
          Expanded(flex: 2, child: _pad('Supplier', cell)),
          SizedBox(width: 100, child: _pad('Credit', cell, right: true)),
          SizedBox(width: 100, child: _pad('Debit', cell, right: true)),
          SizedBox(width: 120, child: _pad('Total', cell, right: true)),
          SizedBox(width: 100, child: _pad('Date', cell)),
          SizedBox(width: 100, child: _pad('Status', cell)),
          SizedBox(width: 140, child: _pad('Note', cell)),
        ],
      ),
    );
  }

  Widget _pad(String text, TextStyle style, {bool right = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: style,
      ),
    );
  }

  Widget _buildDataRow(
    PurchaseReturnEntity pr,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final statusColor = pr.isReverted ? AppTheme.warning : AppTheme.success;
    final credit = 0;
    final debit = pr.total;
    final balance = -pr.total;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // Action
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionIcon(
                    icon: Icons.visibility_outlined,
                    tooltip: 'View',
                    onTap: () => _showDetails(pr),
                  ),
                  const SizedBox(width: 2),
                  _ActionIcon(
                    icon: Icons.restore_rounded,
                    tooltip: 'Revert',
                    color: pr.isReverted
                        ? AppTheme.textMuted
                        : AppTheme.warning,
                    onTap: pr.isReverted ? null : () => _confirmRevert(pr),
                  ),
                  const SizedBox(width: 2),
                  _ActionIcon(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Delete',
                    color: AppTheme.danger,
                    onTap: () => _confirmDelete(pr),
                  ),
                ],
              ),
            ),
          ),
          // Return No.
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                pr.returnNumber,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Purchase No.
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                pr.originalPurchaseNumber,
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Invoice No.
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                pr.originalInvoiceNumber ?? '—',
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
                pr.supplierName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          // Credit
          SizedBox(
            width: 100,
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
          // Debit
          SizedBox(
            width: 100,
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
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatSignedCurrency(balance),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: balance < 0 ? AppTheme.danger : AppTheme.textPrimary,
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
                _formatDate(pr.returnDate),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pr.status.label,
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
                description: pr.notes,
                maxLines: 1,
                style: textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(TextTheme textTheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supplier',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: _supplierId,
                isDense: true,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<int>(child: Text('All Suppliers')),
                  for (final s in _suppliers)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (value) {
                  setState(() {
                    _supplierId = value == _suppliers.firstOrNull?.id
                        ? null
                        : value;
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
              Text(
                'Status',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<PurchaseReturnStatus?>(
                initialValue: _status,
                isDense: true,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<PurchaseReturnStatus?>(
                    child: Text('All Statuses'),
                  ),
                  for (final s in PurchaseReturnStatus.values)
                    DropdownMenuItem(value: s, child: Text(s.label)),
                ],
                onChanged: (value) {
                  setState(() => _status = value);
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
            value: _returnDateFrom,
            onPicked: (d) {
              setState(() => _returnDateFrom = d);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 170,
          child: _buildDateFilterField(
            label: 'To',
            value: _returnDateTo,
            onPicked: (d) {
              setState(() => _returnDateTo = d);
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
              value == null ? label : _formatDate(value),
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
          Text(
            'Showing $start to $end of $total entries',
            style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                onPressed: _page > 1 ? () => _onPageChanged(_page - 1) : null,
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
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                onPressed: _page < maxPage
                    ? () => _onPageChanged(_page + 1)
                    : null,
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

  static String _formatSignedCurrency(int paise) {
    if (paise == 0) return '₹0';
    final rupees = paise.abs() / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    final sign = paise > 0 ? '+' : '-';
    return '$sign₹$text';
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
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
  final VoidCallback? onTap;
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
    final enabled = widget.onTap != null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: enabled ? (_) => setState(() => _hovered = false) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: enabled && _hovered
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
                color: enabled && _hovered ? activeColor : baseColor,
              ),
              onPressed: enabled ? widget.onTap : null,
            ),
          ),
        ),
      ),
    );
  }
}
