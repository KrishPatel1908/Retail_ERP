import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../../../shared/widgets/table_action_button.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/entities/inventory.dart';
import '../dialogs/stock_adjustment_dialog.dart';
import '../dialogs/stock_item_detail_dialog.dart';

/// Inventory list page — the central view of the current stock of every
/// sellable product/variant.
///
/// Server-side search, filtering and pagination follow the same architecture
/// as the Purchase / Purchase Return history pages. Rows are never merged:
/// every product and every variant is one stock row.
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  late final InventoryRepository _repository;

  List<InventoryItemEntity> _items = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _requestId = 0;

  // Filter state.
  int? _categoryId;
  int? _brandId;
  StockStatus? _stockStatus;

  int _page = 1;
  final int _pageSize = 25;

  // Filter dropdown data.
  List<({int id, String name})> _categories = const [];
  List<({int id, String name})> _brands = const [];

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository();
    _load();
    _loadFilterOptions();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() {
      _loading = _items.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: InventoryFilters(
          categoryId: _categoryId,
          brandId: _brandId,
          stockStatus: _stockStatus,
        ),
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _items = result.items;
        _totalCount = result.totalCount;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final categories = await _repository.distinctCategories();
      final brands = await _repository.distinctBrands();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _brands = brands;
      });
    } catch (error) {
      // Filter options are non-critical; the list itself remains usable.
      debugPrint('Failed to load inventory filter options: $error');
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

  void _clearFilters() {
    setState(() {
      _categoryId = null;
      _brandId = null;
      _stockStatus = null;
      _page = 1;
    });
    _load();
  }

  bool get _hasActiveFilters =>
      _categoryId != null || _brandId != null || _stockStatus != null;

  Future<void> _showDetails(InventoryItemEntity item) async {
    await showStockItemDetailDialog(context, item: item);
    // The detail dialog may have recorded adjustments; refresh.
    _load();
  }

  Future<void> _openStockAdjustment([InventoryItemEntity? item]) async {
    final saved = await showStockAdjustmentDialog(context, preselected: item);
    if (saved == true && mounted) _load();
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
              title: 'Inventory',
              description:
                  'Current stock of every product and variant, kept in sync '
                  'with purchases, returns and adjustments.',
              breadcrumbs: const ['Inventory'],
              actions: [
                OutlinedButton.icon(
                  onPressed: () => _openStockAdjustment(),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: const Text('Stock Adjustment'),
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
                          hintText: 'Search product, variant, barcode...',
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            setState(() => _filtersExpanded = !_filtersExpanded),
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
                      title: 'Could not load inventory',
                      message:
                          'Something went wrong while reading the database. '
                          'Please try again.',
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

  Widget _buildFiltersRow(TextTheme textTheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 200,
          child: _buildDropdown<int>(
            label: 'Category',
            value: _categoryId,
            items: _categories,
            allLabel: 'All Categories',
            textTheme: textTheme,
            onChanged: (value) {
              setState(() => _categoryId = value);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 200,
          child: _buildDropdown<int>(
            label: 'Brand',
            value: _brandId,
            items: _brands,
            allLabel: 'All Brands',
            textTheme: textTheme,
            onChanged: (value) {
              setState(() => _brandId = value);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 200,
          child: _buildStatusDropdown(textTheme),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(TextTheme textTheme) {
    const options = [
      (status: StockStatus.inStock, label: 'In Stock'),
      (status: StockStatus.lowStock, label: 'Low Stock'),
      (status: StockStatus.outOfStock, label: 'Out of Stock'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stock Status',
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<StockStatus>(
          initialValue: _stockStatus,
          isDense: true,
          isExpanded: true,
          items: [
            const DropdownMenuItem<StockStatus>(child: Text('All')),
            for (final option in options)
              DropdownMenuItem<StockStatus>(
                value: option.status,
                child: Text(option.label),
              ),
          ],
          onChanged: (value) {
            setState(() => _stockStatus = value);
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<({int id, String name})> items,
    required String allLabel,
    required TextTheme textTheme,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          isDense: true,
          isExpanded: true,
          items: [
            DropdownMenuItem<T>(child: Text(allLabel)),
            for (final item in items)
              DropdownMenuItem<T>(value: item.id as T, child: Text(item.name)),
          ],
          onChanged: onChanged,
        ),
      ],
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
                : _items.isEmpty
                ? EmptyState(
                    icon: Icons.warehouse_outlined,
                    title: _query.isEmpty && !_hasActiveFilters
                        ? 'No stock items yet'
                        : 'No matching stock items',
                    message: _query.isEmpty && !_hasActiveFilters
                        ? 'Stock appears here after your first purchase or '
                            'stock adjustment.'
                        : 'Try a different search term or clear the filters.',
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeaderRow(colorScheme, textTheme),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _items.length,
                            itemBuilder: (context, index) =>
                                _buildDataRow(_items[index], textTheme),
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
          Expanded(flex: 3, child: _pad('Product', cell)),
          SizedBox(width: 110, child: _pad('Variant', cell)),
          SizedBox(width: 130, child: _pad('Barcode', cell)),
          Expanded(flex: 2, child: _pad('Category', cell)),
          Expanded(flex: 2, child: _pad('Brand', cell)),
          SizedBox(width: 90, child: _pad('Stock', cell, right: true)),
          SizedBox(width: 80, child: _pad('Unit', cell)),
          SizedBox(width: 100, child: _pad('Price', cell, right: true)),
          SizedBox(width: 100, child: _pad('MRP', cell, right: true)),
          SizedBox(width: 110, child: _pad('Status', cell)),
          SizedBox(width: 100, child: _pad('Actions', cell)),
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

  Widget _buildDataRow(InventoryItemEntity item, TextTheme textTheme) {
    final statusColor = item.status == StockStatus.inStock
        ? AppTheme.success
        : item.status == StockStatus.lowStock
        ? AppTheme.warning
        : AppTheme.danger;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.productName,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.variantName ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.barcode ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.categoryName ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.brandName ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${item.currentStock}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: item.currentStock > 0
                      ? AppTheme.textPrimary
                      : AppTheme.danger,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.unitName ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.purchasePrice == null
                    ? '—'
                    : _formatCurrency(item.purchasePrice!),
                style: textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.mrp == null ? '—' : _formatCurrency(item.mrp!),
                style: textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableActionButton(
                    tooltip: 'View Stock',
                    icon: Icons.visibility_outlined,
                    hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                    iconColor: AppTheme.primary,
                    onPressed: () => _showDetails(item),
                  ),
                  const SizedBox(width: 2),
                  TableActionButton(
                    tooltip: 'Stock Adjustment',
                    icon: Icons.tune_rounded,
                    hoverColor: AppTheme.warning.withValues(alpha: 0.1),
                    iconColor: AppTheme.warning,
                    onPressed: () => _openStockAdjustment(item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final total = _totalCount;
    final start = total == 0 ? 0 : ((_page - 1) * _pageSize) + 1;
    final end = (_page * _pageSize) > total ? total : (_page * _pageSize);
    final maxPage = (total / _pageSize).ceil().clamp(1, 999999);

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          final entriesText = Text(
            'Showing $start to $end of $total entries',
            style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );

          final controls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 16,
                onPressed: _page > 1 ? () => _onPageChanged(_page - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  'Page $_page of $maxPage',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 16,
                onPressed: _page < maxPage
                    ? () => _onPageChanged(_page + 1)
                    : null,
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: entriesText),
                const SizedBox(height: 2),
                Center(child: controls),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: entriesText),
              const SizedBox(width: 8),
              controls,
            ],
          );
        },
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}
