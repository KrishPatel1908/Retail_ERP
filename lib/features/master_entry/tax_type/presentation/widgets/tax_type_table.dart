import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/description_preview.dart';
import '../../domain/entities/tax_type.dart';

/// Responsive desktop data table for the tax type list powered by [AppDataTable].
class TaxTypeTable extends StatefulWidget {
  const TaxTypeTable({
    super.key,
    required this.taxTypes,
    required this.onEdit,
    required this.onDelete,
  });

  final List<TaxType> taxTypes;
  final ValueChanged<TaxType> onEdit;
  final ValueChanged<TaxType> onDelete;

  @override
  State<TaxTypeTable> createState() => _TaxTypeTableState();
}

class _TaxTypeTableState extends State<TaxTypeTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<TaxType> get _sortedTaxTypes {
    if (_sortColumnIndex == null) return widget.taxTypes;
    final list = List<TaxType>.from(widget.taxTypes);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.taxTypeName.compareTo(b.taxTypeName);
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
      AppDataTableColumn<TaxType>(
        label: 'Tax Type Name',
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, taxType) {
          return Text(
            taxType.taxTypeName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<TaxType>(
        label: 'Description',
        flex: 4,
        minWidth: 200,
        cellBuilder: (context, taxType) {
          return DescriptionPreview(
            description: taxType.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<TaxType>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, taxType) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                key: ValueKey('edit-tax-type-${taxType.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(taxType),
              ),
              const SizedBox(width: 4),
              _ActionButton(
                key: ValueKey('delete-tax-type-${taxType.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(taxType),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<TaxType>(
      items: _sortedTaxTypes,
      columns: columns,
      keyExtractor: (t) => t.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 500.0,
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
