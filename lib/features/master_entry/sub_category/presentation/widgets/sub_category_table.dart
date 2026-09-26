import 'package:flutter/material.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/shared/widgets/app_data_table.dart';
import 'package:retail_erp/shared/widgets/description_preview.dart';

import '../../domain/entities/sub_category.dart';
import 'sub_category_status_badge.dart';

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

/// Responsive desktop data table for the sub-category list powered by [AppDataTable].
class SubCategoryTable extends StatefulWidget {
  const SubCategoryTable({
    super.key,
    required this.subCategories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SubCategory> subCategories;
  final ValueChanged<SubCategory> onEdit;
  final ValueChanged<SubCategory> onDelete;

  @override
  State<SubCategoryTable> createState() => _SubCategoryTableState();
}

class _SubCategoryTableState extends State<SubCategoryTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<SubCategory> get _sortedSubCategories {
    if (_sortColumnIndex == null) return widget.subCategories;
    final list = List<SubCategory>.from(widget.subCategories);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = (a.categoryName ?? '').compareTo(b.categoryName ?? '');
          break;
        case 1:
          comparison = a.subCategoryName.compareTo(b.subCategoryName);
          break;
        case 2:
          comparison = a.subCategoryCode.compareTo(b.subCategoryCode);
          break;
        case 5:
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
      AppDataTableColumn<SubCategory>(
        label: 'Category',
        flex: 3,
        minWidth: 150,
        sortable: true,
        cellBuilder: (context, subCat) {
          return Text(
            subCat.categoryName ?? '—',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Sub Category Name',
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, subCat) {
          return Text(
            subCat.subCategoryName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Code',
        width: 120,
        sortable: true,
        cellBuilder: (context, subCat) {
          return Text(
            subCat.subCategoryCode,
            style: mutedStyle?.copyWith(fontFamily: 'monospace'),
          );
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Description',
        flex: 4,
        minWidth: 180,
        cellBuilder: (context, subCat) {
          return DescriptionPreview(
            description: subCat.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Status',
        width: 120,
        alignment: Alignment.centerLeft,
        cellBuilder: (context, subCat) {
          return SubCategoryStatusBadge(isActive: subCat.isActive);
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Created Date',
        width: 140,
        sortable: true,
        cellBuilder: (context, subCat) {
          return Text(_formatDate(subCat.createdAt), style: mutedStyle);
        },
      ),
      AppDataTableColumn<SubCategory>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, subCat) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-sub-category-${subCat.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(subCat),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-sub-category-${subCat.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(subCat),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<SubCategory>(
      items: _sortedSubCategories,
      columns: columns,
      keyExtractor: (c) => c.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 850.0,
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
