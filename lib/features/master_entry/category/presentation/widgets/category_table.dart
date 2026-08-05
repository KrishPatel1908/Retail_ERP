import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/category.dart';
import 'category_status_badge.dart';

const List<String> _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${_monthAbbreviations[date.month - 1]} ${date.year}';
}

/// Responsive desktop data table for the category list powered by [AppDataTable].
class CategoryTable extends StatefulWidget {
  const CategoryTable({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Category> categories;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onDelete;

  @override
  State<CategoryTable> createState() => _CategoryTableState();
}

class _CategoryTableState extends State<CategoryTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<Category> get _sortedCategories {
    if (_sortColumnIndex == null) return widget.categories;
    final list = List<Category>.from(widget.categories);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.categoryName.compareTo(b.categoryName);
          break;
        case 3:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        default:
          comparison = 0;
      }
      return _sortAscending ? comparison : -comparison;
    });
    return list;
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mutedStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    final columns = [
      AppDataTableColumn<Category>(
        label: 'Category Name',
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, category) {
          return Text(
            category.categoryName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<Category>(
        label: 'Description',
        flex: 4,
        minWidth: 200,
        cellBuilder: (context, category) {
          return Text(
            category.description != null && category.description!.isNotEmpty
                ? category.description!
                : '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<Category>(
        label: 'Status',
        width: 130,
        alignment: Alignment.centerLeft,
        cellBuilder: (context, category) {
          return CategoryStatusBadge(isActive: category.isActive);
        },
      ),
      AppDataTableColumn<Category>(
        label: 'Created Date',
        width: 140,
        sortable: true,
        cellBuilder: (context, category) {
          return Text(
            _formatDate(category.createdAt),
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<Category>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, category) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-category-${category.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(category),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-category-${category.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(category),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<Category>(
      items: _sortedCategories,
      columns: columns,
      keyExtractor: (c) => c.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 700.0,
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.hoverColor,
    required this.iconColor,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color hoverColor;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
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
            color: _hovered ? widget.hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? widget.iconColor : AppTheme.textSecondary,
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
