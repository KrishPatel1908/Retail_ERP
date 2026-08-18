import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/description_preview.dart';
import '../../domain/entities/tax_category.dart';
import 'tax_components_preview.dart';

/// Responsive desktop data table for the tax category list powered by [AppDataTable].
class TaxCategoryTable extends StatefulWidget {
  const TaxCategoryTable({
    super.key,
    required this.taxCategories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<TaxCategory> taxCategories;
  final ValueChanged<TaxCategory> onEdit;
  final ValueChanged<TaxCategory> onDelete;

  @override
  State<TaxCategoryTable> createState() => _TaxCategoryTableState();
}

class _TaxCategoryTableState extends State<TaxCategoryTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<TaxCategory> get _sortedTaxCategories {
    if (_sortColumnIndex == null) return widget.taxCategories;
    final list = List<TaxCategory>.from(widget.taxCategories);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.taxCategoryName.compareTo(b.taxCategoryName);
          break;
        case 1:
          comparison = a.totalTaxPercentage.compareTo(b.totalTaxPercentage);
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

  String _formatTotalTax(double percentage) {
    return '${percentage.toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mutedStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    final columns = [
      AppDataTableColumn<TaxCategory>(
        label: 'Tax Category',
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, category) {
          return Text(
            category.taxCategoryName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<TaxCategory>(
        label: 'Total Tax %',
        flex: 2,
        minWidth: 110,
        sortable: true,
        cellBuilder: (context, category) {
          return Text(
            _formatTotalTax(category.totalTaxPercentage),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          );
        },
      ),
      AppDataTableColumn<TaxCategory>(
        label: 'Components',
        flex: 4,
        minWidth: 220,
        cellBuilder: (context, category) {
          return TaxComponentsPreview(
            components: category.components,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<TaxCategory>(
        label: 'Description',
        flex: 3,
        minWidth: 180,
        cellBuilder: (context, category) {
          return DescriptionPreview(
            description: category.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<TaxCategory>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, category) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-tax-category-${category.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(category),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-tax-category-${category.id}'),
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

    return AppDataTable<TaxCategory>(
      items: _sortedTaxCategories,
      columns: columns,
      keyExtractor: (t) => t.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 770.0,
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
