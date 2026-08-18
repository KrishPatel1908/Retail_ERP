import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/description_preview.dart';
import '../../domain/entities/brand.dart';

/// Responsive desktop data table for the brand list powered by [AppDataTable].
class BrandTable extends StatefulWidget {
  const BrandTable({
    super.key,
    required this.brands,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Brand> brands;
  final ValueChanged<Brand> onEdit;
  final ValueChanged<Brand> onDelete;

  @override
  State<BrandTable> createState() => _BrandTableState();
}

class _BrandTableState extends State<BrandTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<Brand> get _sortedBrands {
    if (_sortColumnIndex == null) return widget.brands;
    final list = List<Brand>.from(widget.brands);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.brandName.compareTo(b.brandName);
          break;
        case 2:
          comparison = a.productCount.compareTo(b.productCount);
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
      AppDataTableColumn<Brand>(
        label: 'Brand Name',
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, brand) {
          return Text(
            brand.brandName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<Brand>(
        label: 'Description',
        flex: 4,
        minWidth: 200,
        cellBuilder: (context, brand) {
          return DescriptionPreview(
            description: brand.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<Brand>(
        label: 'Products',
        width: 120,
        sortable: true,
        alignment: Alignment.centerLeft,
        cellBuilder: (context, brand) {
          return Text(
            '${brand.productCount}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          );
        },
      ),
      AppDataTableColumn<Brand>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, brand) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-brand-${brand.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(brand),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-brand-${brand.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(brand),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<Brand>(
      items: _sortedBrands,
      columns: columns,
      keyExtractor: (b) => b.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 600.0,
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
