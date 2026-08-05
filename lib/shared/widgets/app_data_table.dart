import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_theme.dart';

/// Column definition for [AppDataTable].
class AppDataTableColumn<T> {
  const AppDataTableColumn({
    required this.label,
    required this.cellBuilder,
    this.id,
    this.flex = 1,
    this.width,
    this.minWidth,
    this.numeric = false,
    this.alignment,
    this.sortable = false,
    this.sortValueGetter,
  });

  /// Optional column identifier. Defaults to [label] string if omitted.
  final String? id;

  /// Header label text or widget.
  final String label;

  /// Cell builder function given the item of type [T].
  final Widget Function(BuildContext context, T item) cellBuilder;

  /// Flex factor for responsive width distribution when [width] is null.
  final int flex;

  /// Explicit fixed width in logical pixels. Overrides [flex] if set.
  final double? width;

  /// Minimum width requirement for this column.
  final double? minWidth;

  /// Right-align column header and content if true.
  final bool numeric;

  /// Alignment of cell content. Defaults to left (or right if [numeric] is true).
  final AlignmentGeometry? alignment;

  /// Whether this column can be sorted by clicking the header.
  final bool sortable;

  /// Optional value extractor used for default client-side sorting.
  final Comparable<dynamic>? Function(T item)? sortValueGetter;
}

/// A desktop-first, commercial ERP data table component.
///
/// Features:
/// - Sticky header
/// - Flex / responsive column sizing + horizontal scroll fallback
/// - Multi-select and single-select checkbox support
/// - Column sorting indicators & triggers
/// - Keyboard navigation (Up/Down arrow key focus + Enter/Space action)
/// - Zebra striping and row hover effects
/// - Integrated Pagination footer
/// - Built-in Loading, Empty, and Error states
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.items,
    required this.columns,
    this.keyExtractor,
    this.onRowTap,
    this.selectable = false,
    this.selectedItems = const {},
    this.onSelectionChanged,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.page = 1,
    this.pageSize = 10,
    this.totalItems,
    this.onPageChanged,
    this.onPageSizeChanged,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.showPagination = false,
    this.isLoading = false,
    this.loadingWidget,
    this.error,
    this.errorWidget,
    this.emptyWidget,
    this.zebraRows = true,
    this.rowHeight = 52.0,
    this.headerHeight = 44.0,
    this.minWidth = 750.0,
  });

  /// Data rows to display on the current page.
  final List<T> items;

  /// Column configuration specifications.
  final List<AppDataTableColumn<T>> columns;

  /// Key extractor to identify items for selection comparison.
  final Object Function(T item)? keyExtractor;

  /// Callback when a row is tapped.
  final ValueChanged<T>? onRowTap;

  /// Enable checkbox row selection column.
  final bool selectable;

  /// Set of currently selected items.
  final Set<T> selectedItems;

  /// Selection update callback.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Currently active sort column index.
  final int? sortColumnIndex;

  /// Active sort direction (true = ascending, false = descending).
  final bool sortAscending;

  /// Sorting change callback.
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Current 1-based page index.
  final int page;

  /// Current page size.
  final int pageSize;

  /// Total number of items across all pages (defaults to [items.length]).
  final int? totalItems;

  /// Page change callback.
  final ValueChanged<int>? onPageChanged;

  /// Page size change callback.
  final ValueChanged<int>? onPageSizeChanged;

  /// Options for page size selector dropdown.
  final List<int> pageSizeOptions;

  /// Whether to render the pagination footer.
  final bool showPagination;

  /// Whether the table is currently loading data.
  final bool isLoading;

  /// Custom widget during loading.
  final Widget? loadingWidget;

  /// Error object if data fetch failed.
  final Object? error;

  /// Custom widget when an error occurs.
  final Widget? errorWidget;

  /// Custom empty state widget when [items] is empty.
  final Widget? emptyWidget;

  /// Enable subtle alternate row backgrounds.
  final bool zebraRows;

  /// Fixed row height in pixels.
  final double rowHeight;

  /// Fixed header row height in pixels.
  final double headerHeight;

  /// Minimum total table width before horizontal scroll engages.
  final double minWidth;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  int? _focusedRowIndex;

  Object _getItemKey(T item) {
    if (widget.keyExtractor != null) {
      return widget.keyExtractor!(item);
    }
    return item as Object;
  }

  bool _isItemSelected(T item) {
    final key = _getItemKey(item);
    return widget.selectedItems.any((e) => _getItemKey(e) == key);
  }

  void _toggleSelectAll() {
    if (widget.onSelectionChanged == null) return;
    final allSelected = widget.items.isNotEmpty && widget.items.every(_isItemSelected);
    if (allSelected) {
      final updated = Set<T>.from(widget.selectedItems);
      for (final item in widget.items) {
        final key = _getItemKey(item);
        updated.removeWhere((e) => _getItemKey(e) == key);
      }
      widget.onSelectionChanged!(updated);
    } else {
      final updated = Set<T>.from(widget.selectedItems)..addAll(widget.items);
      widget.onSelectionChanged!(updated);
    }
  }

  void _toggleSelectItem(T item) {
    if (widget.onSelectionChanged == null) return;
    final updated = Set<T>.from(widget.selectedItems);
    final key = _getItemKey(item);
    if (_isItemSelected(item)) {
      updated.removeWhere((e) => _getItemKey(e) == key);
    } else {
      updated.add(item);
    }
    widget.onSelectionChanged!(updated);
  }

  void _handleSort(int index) {
    final col = widget.columns[index];
    if (!col.sortable || widget.onSort == null) return;
    final isCurrent = widget.sortColumnIndex == index;
    final ascending = isCurrent ? !widget.sortAscending : true;
    widget.onSort!(index, ascending);
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent || widget.items.isEmpty) return;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        if (_focusedRowIndex == null) {
          _focusedRowIndex = 0;
        } else if (_focusedRowIndex! < widget.items.length - 1) {
          _focusedRowIndex = _focusedRowIndex! + 1;
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        if (_focusedRowIndex != null && _focusedRowIndex! > 0) {
          _focusedRowIndex = _focusedRowIndex! - 1;
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_focusedRowIndex != null &&
          _focusedRowIndex! >= 0 &&
          _focusedRowIndex! < widget.items.length) {
        final item = widget.items[_focusedRowIndex!];
        widget.onRowTap?.call(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyDown(event);
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final selectWidth = widget.selectable ? 48.0 : 0.0;
          final totalFixedWidth = selectWidth +
              widget.columns.fold<double>(
                0.0,
                (sum, col) => sum + (col.width ?? 0.0),
              );

          final minRequiredFlexWidth = widget.columns.fold<double>(
            0.0,
            (sum, col) => sum + (col.width == null ? (col.minWidth ?? 80.0) : 0.0),
          );

          final minTableWidth = math.max(
            widget.minWidth,
            totalFixedWidth + minRequiredFlexWidth,
          );

          final effectiveTableWidth = constraints.maxWidth < minTableWidth
              ? minTableWidth
              : constraints.maxWidth;

          final remainingFlexWidth = (effectiveTableWidth - totalFixedWidth)
              .clamp(0.0, double.infinity);

          final totalFlex = widget.columns.fold<int>(
            0,
            (sum, col) => sum + (col.width == null ? col.flex : 0),
          );

          List<double> columnWidths = [];
          for (final col in widget.columns) {
            if (col.width != null) {
              columnWidths.add(col.width!);
            } else if (totalFlex > 0) {
              final w = (col.flex / totalFlex) * remainingFlexWidth;
              final finalW =
                  col.minWidth != null && w < col.minWidth! ? col.minWidth! : w;
              columnWidths.add(finalW);
            } else {
              columnWidths.add(120.0);
            }
          }

          final calculatedSum =
              selectWidth + columnWidths.fold<double>(0.0, (s, w) => s + w);
          final finalTableWidth = math.max(effectiveTableWidth, calculatedSum);

          Widget tableContent;
          if (widget.isLoading) {
            tableContent = widget.loadingWidget ?? _buildDefaultLoading();
          } else if (widget.error != null) {
            tableContent = widget.errorWidget ?? _buildDefaultError();
          } else if (widget.items.isEmpty) {
            tableContent = widget.emptyWidget ?? _buildDefaultEmpty();
          } else {
            tableContent = _buildRowsList(columnWidths, finalTableWidth);
          }

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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: finalTableWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeaderRow(
                            columnWidths,
                            textTheme,
                            colorScheme,
                          ),
                          Expanded(child: tableContent),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.showPagination && !widget.isLoading)
                  _buildPaginationFooter(textTheme, colorScheme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
    List<double> columnWidths,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final allSelected =
        widget.items.isNotEmpty && widget.items.every(_isItemSelected);
    final someSelected =
        widget.items.any(_isItemSelected) && !allSelected;

    return Container(
      height: widget.headerHeight,
      decoration: BoxDecoration(
        color: AppTheme.hover,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          if (widget.selectable)
            SizedBox(
              width: 48,
              child: Center(
                child: Checkbox(
                  value: allSelected ? true : (someSelected ? null : false),
                  tristate: true,
                  onChanged: (val) => _toggleSelectAll(),
                ),
              ),
            ),
          for (int i = 0; i < widget.columns.length; i++) ...[
            SizedBox(
              width: columnWidths[i],
              child: _buildHeaderCell(i, textTheme, colorScheme),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    int index,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final col = widget.columns[index];
    final isSorted = widget.sortColumnIndex == index;
    final align =
        col.alignment ??
        (col.numeric ? Alignment.centerRight : Alignment.centerLeft);

    Widget headerLabel = Text(
      col.label,
      style: textTheme.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: isSorted ? AppTheme.primary : AppTheme.textSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (col.sortable) {
      headerLabel = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: headerLabel),
          const SizedBox(width: 4),
          Icon(
            isSorted
                ? (widget.sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded)
                : Icons.unfold_more_rounded,
            size: 14,
            color: isSorted ? AppTheme.primary : AppTheme.textMuted,
          ),
        ],
      );
    }

    return InkWell(
      onTap: col.sortable ? () => _handleSort(index) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: align,
        child: headerLabel,
      ),
    );
  }

  Widget _buildRowsList(List<double> columnWidths, double totalWidth) {
    return ListView.separated(
      itemCount: widget.items.length,
      separatorBuilder:
          (context, index) =>
              Divider(height: 1, thickness: 1, color: AppTheme.border.withValues(alpha: 0.5)),
      itemBuilder: (context, rowIndex) {
        final item = widget.items[rowIndex];
        final isSelected = _isItemSelected(item);
        final isFocused = _focusedRowIndex == rowIndex;
        final isEven = rowIndex % 2 == 0;

        return _AppDataTableRow<T>(
          key: ValueKey(_getItemKey(item)),
          item: item,
          rowIndex: rowIndex,
          columns: widget.columns,
          columnWidths: columnWidths,
          isSelected: isSelected,
          isFocused: isFocused,
          isEven: isEven,
          rowHeight: widget.rowHeight,
          selectable: widget.selectable,
          zebraRows: widget.zebraRows,
          onTap: () {
            setState(() => _focusedRowIndex = rowIndex);
            widget.onRowTap?.call(item);
          },
          onSelectChanged: (val) => _toggleSelectItem(item),
        );
      },
    );
  }

  Widget _buildDefaultLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              'Loading data...',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 36),
            const SizedBox(height: 12),
            Text(
              'An error occurred: ${widget.error}',
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Text(
          'No records found',
          style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final total = widget.totalItems ?? widget.items.length;
    final page = widget.page;
    final pageSize = widget.pageSize;

    final start = total == 0 ? 0 : ((page - 1) * pageSize) + 1;
    final end = (page * pageSize) > total ? total : (page * pageSize);
    final maxPage = (total / pageSize).ceil().clamp(1, 999999);

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
                style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              ),
              if (widget.onPageSizeChanged != null) ...[
                const SizedBox(width: 16),
                Text('Rows per page:', style: textTheme.bodySmall),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: pageSize,
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  items: widget.pageSizeOptions.map((sz) {
                    return DropdownMenuItem<int>(
                      value: sz,
                      child: Text('$sz', style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) widget.onPageSizeChanged!(val);
                  },
                ),
              ],
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                onPressed: (page > 1 && widget.onPageChanged != null)
                    ? () => widget.onPageChanged!(page - 1)
                    : null,
                tooltip: 'Previous page',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Page $page of $maxPage',
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                onPressed: (page < maxPage && widget.onPageChanged != null)
                    ? () => widget.onPageChanged!(page + 1)
                    : null,
                tooltip: 'Next page',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppDataTableRow<T> extends StatefulWidget {
  const _AppDataTableRow({
    super.key,
    required this.item,
    required this.rowIndex,
    required this.columns,
    required this.columnWidths,
    required this.isSelected,
    required this.isFocused,
    required this.isEven,
    required this.rowHeight,
    required this.selectable,
    required this.zebraRows,
    required this.onTap,
    required this.onSelectChanged,
  });

  final T item;
  final int rowIndex;
  final List<AppDataTableColumn<T>> columns;
  final List<double> columnWidths;
  final bool isSelected;
  final bool isFocused;
  final bool isEven;
  final double rowHeight;
  final bool selectable;
  final bool zebraRows;
  final VoidCallback onTap;
  final ValueChanged<bool?> onSelectChanged;

  @override
  State<_AppDataTableRow<T>> createState() => _AppDataTableRowState<T>();
}

class _AppDataTableRowState<T> extends State<_AppDataTableRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    if (widget.isSelected) {
      bg = AppTheme.selected;
    } else if (_isHovered) {
      bg = AppTheme.hover;
    } else if (widget.zebraRows && !widget.isEven) {
      bg = const Color(0xFFFAFAFC);
    }

    if (widget.isFocused) {
      bg = AppTheme.selected;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: widget.rowHeight,
          decoration: BoxDecoration(
            color: bg,
            boxShadow: widget.isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 0,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (widget.selectable)
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Checkbox(
                      value: widget.isSelected,
                      onChanged: widget.onSelectChanged,
                    ),
                  ),
                ),
              for (int i = 0; i < widget.columns.length; i++) ...[
                SizedBox(
                  width: widget.columnWidths[i],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment:
                        widget.columns[i].alignment ??
                        (widget.columns[i].numeric
                            ? Alignment.centerRight
                            : Alignment.centerLeft),
                    child: widget.columns[i].cellBuilder(context, widget.item),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
