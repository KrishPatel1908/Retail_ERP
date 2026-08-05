import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/table_action_button.dart';
import '../../domain/entities/unit.dart';

String _typeLabel(String family) {
  return UnitType.fromDbValue(family)?.label ?? family;
}

/// Responsive desktop data table for the unit list powered by [AppDataTable].
class UnitTable extends StatefulWidget {
  const UnitTable({
    super.key,
    required this.units,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Unit> units;
  final ValueChanged<Unit> onEdit;
  final ValueChanged<Unit> onDelete;

  @override
  State<UnitTable> createState() => _UnitTableState();
}

class _UnitTableState extends State<UnitTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<Unit> get _sortedUnits {
    if (_sortColumnIndex == null) return widget.units;
    final list = List<Unit>.from(widget.units);
    list.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.unitName.toLowerCase().compareTo(
            b.unitName.toLowerCase(),
          );
          break;
        case 2:
          comparison = _typeLabel(a.unitFamily).compareTo(
            _typeLabel(b.unitFamily),
          );
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
      AppDataTableColumn<Unit>(
        label: 'Unit Name',
        flex: 3,
        minWidth: 180,
        sortable: true,
        cellBuilder: (context, unit) {
          return Text(
            unit.unitName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<Unit>(
        label: 'Symbol',
        width: 110,
        cellBuilder: (context, unit) {
          return Text(unit.unitSymbol, style: mutedStyle);
        },
      ),
      AppDataTableColumn<Unit>(
        label: 'Measure In',
        width: 140,
        sortable: true,
        cellBuilder: (context, unit) {
          return Text(_typeLabel(unit.unitFamily), style: mutedStyle);
        },
      ),
      AppDataTableColumn<Unit>(
        label: 'Description',
        flex: 4,
        minWidth: 220,
        cellBuilder: (context, unit) {
          final description = unit.description;
          return Text(
            description?.isNotEmpty == true ? description! : '—',
            style: mutedStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      AppDataTableColumn<Unit>(
        label: 'Actions',
        width: 100,
        alignment: Alignment.centerRight,
        cellBuilder: (context, unit) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableActionButton(
                key: ValueKey('edit-unit-${unit.id}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => widget.onEdit(unit),
              ),
              const SizedBox(width: 4),
              TableActionButton(
                key: ValueKey('delete-unit-${unit.id}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => widget.onDelete(unit),
              ),
            ],
          );
        },
      ),
    ];

    return AppDataTable<Unit>(
      items: _sortedUnits,
      columns: columns,
      keyExtractor: (u) => u.id,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: _onSort,
      showPagination: false,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 860.0,
    );
  }
}
