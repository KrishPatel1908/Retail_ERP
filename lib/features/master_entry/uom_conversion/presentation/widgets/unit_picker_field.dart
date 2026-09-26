import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../master_entry/unit/domain/entities/unit.dart';
import '../../../../master_entry/unit/presentation/widgets/create_unit_dialog.dart';

/// A searchable unit picker styled like the other form fields.
///
/// The field itself is read-only — free-text typing is not allowed. Tapping
/// it opens a search dialog with the available units; the "+ Add New Unit"
/// action inside the dialog creates a unit on the fly (through
/// [showCreateUnitDialog]) and selects it afterwards. The caller owns the
/// [units] list and must refresh it when [onAddNewUnit] returns a new id.
class UnitPickerField extends StatelessWidget {
  const UnitPickerField({
    super.key,
    required this.label,
    required this.units,
    required this.selectedId,
    required this.onChanged,
    required this.onAddNewUnit,
    this.isRequired = false,
    this.showAddNewUnitButton = false,
    this.hintText = 'Select a unit',
    this.errorText,
    this.excludeIds = const {},
  });

  final String label;
  final bool isRequired;
  final bool showAddNewUnitButton;
  final List<Unit> units;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  /// Creates a unit on the fly and returns its id, or `null` when the user
  /// cancelled. The caller is responsible for refreshing [units].
  final Future<int?> Function() onAddNewUnit;

  final String? hintText;
  final String? errorText;

  /// Units that must not be selectable (e.g. the other picker's selection).
  final Set<int> excludeIds;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showDialog<int>(
      context: context,
      builder: (dialogContext) => _UnitPickerDialog(
        units: units,
        selectedId: selectedId,
        excludeIds: excludeIds,
        onAddNewUnit: onAddNewUnit,
      ),
    );
    if (selected != null) onChanged(selected);
  }

  /// Creates a unit directly from the "+ Add New Unit" action next to the
  /// field and selects it immediately.
  Future<void> _addNewUnit() async {
    final newId = await onAddNewUnit();
    if (newId != null) onChanged(newId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selected = units.where((u) => u.id == selectedId).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (showAddNewUnitButton) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: _addNewUnit,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('+ Add New Unit'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: InputDecoration(errorText: errorText, errorMaxLines: 2),
            child: Row(
              children: [
                Expanded(
                  child: selected == null
                      ? Text(
                          hintText!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '${selected.unitName} (${selected.unitSymbol})',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The searchable picker dialog.
class _UnitPickerDialog extends StatefulWidget {
  const _UnitPickerDialog({
    required this.units,
    required this.selectedId,
    required this.excludeIds,
    required this.onAddNewUnit,
  });

  final List<Unit> units;
  final int? selectedId;
  final Set<int> excludeIds;
  final Future<int?> Function() onAddNewUnit;

  @override
  State<_UnitPickerDialog> createState() => _UnitPickerDialogState();
}

class _UnitPickerDialogState extends State<_UnitPickerDialog> {
  String _query = '';

  List<Unit> get _filteredUnits {
    final normalized = _query.trim().toLowerCase();
    return widget.units.where((unit) {
      if (widget.excludeIds.contains(unit.id)) return false;
      if (normalized.isEmpty) return true;
      final measure = UnitType.fromDbValue(unit.unitFamily)?.label ?? '';
      return unit.unitName.toLowerCase().contains(normalized) ||
          unit.unitSymbol.toLowerCase().contains(normalized) ||
          measure.toLowerCase().contains(normalized);
    }).toList();
  }

  Future<void> _addNewUnit() async {
    final newId = await widget.onAddNewUnit();
    if (!mounted || newId == null) return;
    Navigator.of(context).pop(newId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filteredUnits;

    return AlertDialog(
      title: const Text('Select Unit'),
      content: SizedBox(
        width: 400,
        height: 440,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search units',
                prefixIcon: Icon(Icons.search_rounded, size: 20),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No units match your search.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final unit = filtered[index];
                        final isSelected = unit.id == widget.selectedId;
                        return ListTile(
                          dense: true,
                          title: Text(
                            unit.unitName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '${unit.unitSymbol} · '
                            '${UnitType.fromDbValue(unit.unitFamily)?.label ?? unit.unitFamily}',
                            style: textTheme.bodySmall,
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: AppTheme.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(unit.id),
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            ListTile(
              dense: true,
              leading: const Icon(Icons.add_rounded, size: 20),
              title: const Text('Add New Unit'),
              subtitle: const Text('Create a unit and select it'),
              onTap: _addNewUnit,
            ),
          ],
        ),
      ),
    );
  }
}
