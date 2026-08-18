import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/description_preview.dart';
import '../../domain/entities/product_uom_display.dart';

/// Read-only desktop table for the Product UOM list powered by [AppDataTable].
class ProductUomTable extends StatefulWidget {
  const ProductUomTable({
    super.key,
    required this.conversions,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProductUomDisplay> conversions;
  final ValueChanged<ProductUomDisplay> onEdit;
  final ValueChanged<ProductUomDisplay> onDelete;

  @override
  State<ProductUomTable> createState() => _ProductUomTableState();
}

class _ProductUomTableState extends State<ProductUomTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<ProductUomDisplay> get _sortedConversions {
    if (_sortColumnIndex == null) return widget.conversions;
    final list = List<ProductUomDisplay>.from(widget.conversions);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.productName.compareTo(b.productName);
          break;
        case 3:
          comparison = a.conversionFactor.compareTo(b.conversionFactor);
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
      AppDataTableColumn<ProductUomDisplay>(
        label: 'Product',
        flex: 3,
        minWidth: 150,
        sortable: true,
        cellBuilder: (context, conversion) {
          return Text(
            conversion.productName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'From Unit',
        flex: 2,
        minWidth: 110,
        cellBuilder: (context, conversion) {
          return Text(
            '${conversion.fromUnitName} (${conversion.fromUnitSymbol})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'To Unit',
        flex: 2,
        minWidth: 110,
        cellBuilder: (context, conversion) {
          return Text(
            '${conversion.toUnitName} (${conversion.toUnitSymbol})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'Factor',
        width: 110,
        numeric: true,
        sortable: true,
        cellBuilder: (context, conversion) {
          return Text(
            conversion.factorText,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'Default',
        width: 110,
        alignment: Alignment.centerLeft,
        cellBuilder: (context, conversion) {
          if (!conversion.isDefault) {
            return Text('—', style: mutedStyle);
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 12,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Default',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'Description',
        flex: 3,
        minWidth: 150,
        cellBuilder: (context, conversion) {
          return DescriptionPreview(
            description: conversion.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<ProductUomDisplay>(
        label: 'Actions',
        width: 90,
        alignment: Alignment.centerRight,
        cellBuilder: (context, conversion) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-product-uom-${conversion.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(conversion),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-product-uom-${conversion.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(conversion),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<ProductUomDisplay>(
      items: _sortedConversions,
      columns: columns,
      keyExtractor: (c) => c.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 800.0,
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
