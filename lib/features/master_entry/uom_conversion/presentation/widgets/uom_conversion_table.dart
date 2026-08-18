import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/description_preview.dart';
import '../../../../../shared/widgets/table_action_button.dart';
import '../../domain/entities/uom_conversion.dart';

/// Responsive desktop data table for the conversion list powered by
/// [AppDataTable].
class UomConversionTable extends StatefulWidget {
  const UomConversionTable({
    super.key,
    required this.conversions,
    required this.onEdit,
    required this.onDelete,
  });

  final List<UomConversion> conversions;
  final ValueChanged<UomConversion> onEdit;
  final ValueChanged<UomConversion> onDelete;

  @override
  State<UomConversionTable> createState() => _UomConversionTableState();
}

class _UomConversionTableState extends State<UomConversionTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<UomConversion> get _sortedConversions {
    if (_sortColumnIndex == null) return widget.conversions;
    final list = List<UomConversion>.from(widget.conversions);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.fromUnitName.toLowerCase().compareTo(
            b.fromUnitName.toLowerCase(),
          );
          break;
        case 1:
          comparison = a.toUnitName.toLowerCase().compareTo(
            b.toUnitName.toLowerCase(),
          );
          break;
        case 2:
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

    Widget unitCell(String name, String symbol) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            symbol,
            style: textTheme.bodySmall?.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    final columns = [
      AppDataTableColumn<UomConversion>(
        label: 'From Unit',
        flex: 2,
        minWidth: 170,
        sortable: true,
        cellBuilder: (context, conversion) =>
            unitCell(conversion.fromUnitName, conversion.fromUnitSymbol),
      ),
      AppDataTableColumn<UomConversion>(
        label: 'To Unit',
        flex: 2,
        minWidth: 170,
        sortable: true,
        cellBuilder: (context, conversion) =>
            unitCell(conversion.toUnitName, conversion.toUnitSymbol),
      ),
      AppDataTableColumn<UomConversion>(
        label: 'Conversion Factor',
        width: 150,
        sortable: true,
        cellBuilder: (context, conversion) {
          return Text(
            conversion.factorText,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          );
        },
      ),
      AppDataTableColumn<UomConversion>(
        label: 'Description',
        flex: 3,
        minWidth: 200,
        cellBuilder: (context, conversion) {
          return DescriptionPreview(
            description: conversion.description,
            style: mutedStyle,
          );
        },
      ),
      AppDataTableColumn<UomConversion>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, conversion) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableActionButton(
                key: ValueKey('edit-conversion-${conversion.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(conversion),
              ),
              const SizedBox(width: 4),
              TableActionButton(
                key: ValueKey('delete-conversion-${conversion.id}'),
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

    return AppDataTable<UomConversion>(
      items: _sortedConversions,
      columns: columns,
      keyExtractor: (c) => c.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 56.0,
      headerHeight: 44.0,
      minWidth: 940.0,
    );
  }
}
