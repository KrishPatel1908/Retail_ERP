import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../domain/party_query.dart';

/// Compact filter toolbar shared by the customer and supplier list pages.
///
/// Offers Status / City / State / Opening Balance dropdowns plus Due Date and
/// Created Date range pickers.
/// The page owns the actual filter values; this widget only reports changes.
class PartyFiltersBar extends StatelessWidget {
  const PartyFiltersBar({
    super.key,
    required this.cities,
    required this.states,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.cityFilter,
    required this.onCityChanged,
    required this.stateFilter,
    required this.onStateChanged,
    required this.openingBalanceOption,
    required this.onOpeningBalanceOptionChanged,
    required this.dueFrom,
    required this.dueTo,
    required this.onDueRangeChanged,
    required this.createdFrom,
    required this.createdTo,
    required this.onCreatedRangeChanged,
    required this.onClear,
    required this.hasActiveFilters,
    required this.searchHint,
    required this.onSearchChanged,
  });

  final List<String> cities;
  final List<String> states;
  final bool? statusFilter;
  final ValueChanged<bool?> onStatusChanged;
  final String? cityFilter;
  final ValueChanged<String?> onCityChanged;
  final String? stateFilter;
  final ValueChanged<String?> onStateChanged;

  final OpeningBalanceFilterOption openingBalanceOption;
  final ValueChanged<OpeningBalanceFilterOption> onOpeningBalanceOptionChanged;

  final DateTime? dueFrom;
  final DateTime? dueTo;
  final ValueChanged<DateTimeRange> onDueRangeChanged;

  final DateTime? createdFrom;
  final DateTime? createdTo;
  final ValueChanged<DateTimeRange> onCreatedRangeChanged;

  final VoidCallback onClear;
  final bool hasActiveFilters;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final dueDateField = _FilterField(
      label: 'Due Date',
      child: _DateFilterButton(
        buttonKey: const ValueKey('party-due-date-filter'),
        title: 'Filter by payment due date',
        defaultLabel: 'Due Date',
        from: dueFrom,
        to: dueTo,
        onChanged: onDueRangeChanged,
      ),
    );

    final createdDateField = _FilterField(
      label: 'Created Date',
      child: _DateFilterButton(
        buttonKey: const ValueKey('party-created-date-filter'),
        title: 'Filter by created date',
        defaultLabel: 'Created Date',
        from: createdFrom,
        to: createdTo,
        onChanged: onCreatedRangeChanged,
      ),
    );

    final dropdownFields = <Widget>[
      _FilterField(
        label: 'Status',
        child: _PartyFilterDropdown<int>(
          hint: 'Status',
          value: switch (statusFilter) {
            null => 0,
            true => 1,
            false => 2,
          },
          items: const [0, 1, 2],
          displayLabelOf: (value) => switch (value) {
            0 => 'Status',
            1 => 'Active',
            _ => 'Inactive',
          },
          menuLabelOf: (value) => switch (value) {
            0 => 'All',
            1 => 'Active',
            _ => 'Inactive',
          },
          onChanged: (value) {
            if (value == null) return;
            onStatusChanged(
              value == 1
                  ? true
                  : value == 2
                  ? false
                  : null,
            );
          },
        ),
      ),
      _FilterField(
        label: 'City',
        child: _PartyFilterDropdown<String>(
          hint: 'City',
          value: cityFilter,
          items: cities,
          displayLabelOf: (item) => item,
          menuLabelOf: (item) => item,
          onChanged: onCityChanged,
        ),
      ),
      _FilterField(
        label: 'State',
        child: _PartyFilterDropdown<String>(
          hint: 'State',
          value: stateFilter,
          items: states,
          displayLabelOf: (item) => item,
          menuLabelOf: (item) => item,
          onChanged: onStateChanged,
        ),
      ),
      _FilterField(
        label: 'Balance Type',
        child: _PartyFilterDropdown<OpeningBalanceFilterOption>(
          hint: 'Balance Type',
          value: openingBalanceOption,
          items: OpeningBalanceFilterOption.values,
          displayLabelOf: (item) => switch (item) {
            OpeningBalanceFilterOption.all => 'Balance Type',
            _ => item.label,
          },
          menuLabelOf: (item) => switch (item) {
            OpeningBalanceFilterOption.all => 'All',
            _ => item.label,
          },
          onChanged: (value) {
            if (value != null) onOpeningBalanceOptionChanged(value);
          },
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchField(hintText: searchHint, onChanged: onSearchChanged),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final field in dropdownFields)
                      SizedBox(
                        width: (constraints.maxWidth - 12) / 2,
                        child: field,
                      ),
                    SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: dueDateField,
                    ),
                    SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: createdDateField,
                    ),
                  ],
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SearchField(
                      hintText: searchHint,
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  dueDateField,
                  const SizedBox(width: 12),
                  createdDateField,
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < dropdownFields.length; i++) ...[
                    Expanded(child: dropdownFields[i]),
                    if (i < dropdownFields.length - 1)
                      const SizedBox(width: 12),
                  ],
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                      label: const Text('Clear'),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A compact, unlabelled filter dropdown.
class _PartyFilterDropdown<T> extends StatelessWidget {
  const _PartyFilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.displayLabelOf,
    required this.menuLabelOf,
    required this.onChanged,
  });

  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) displayLabelOf;
  final String Function(T item) menuLabelOf;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = value;
    final effectiveItems = (selected != null && !items.contains(selected))
        ? <T>[selected, ...items]
        : items;
    return DropdownButtonFormField<T>(
      key: ValueKey('$hint-$value'),
      initialValue: value,
      isDense: true,
      isExpanded: true,
      hint: Text(
        hint,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      dropdownColor: colorScheme.surface,
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      menuMaxHeight: 280,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18,
        color: colorScheme.onSurface,
      ),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      selectedItemBuilder: (context) {
        return effectiveItems.map((item) {
          return Text(
            displayLabelOf(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          );
        }).toList();
      },
      items: [
        for (final item in effectiveItems)
          DropdownMenuItem<T>(
            value: item,
            child: Text(
              menuLabelOf(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      child,
    ],
  );
}

/// Button that opens the shared date-range dialog for filtering.
class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.buttonKey,
    required this.title,
    required this.defaultLabel,
    required this.from,
    required this.to,
    required this.onChanged,
  });

  final Key buttonKey;
  final String title;
  final String defaultLabel;
  final DateTime? from;
  final DateTime? to;
  final ValueChanged<DateTimeRange> onChanged;

  bool get _active => from != null || to != null;

  String get _label {
    if (from == null && to == null) return defaultLabel;
    String format(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    if (from != null && to != null) {
      return '${format(from!)} – ${format(to!)}';
    }
    if (from != null) return 'From ${format(from!)}';
    return 'Until ${format(to!)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      key: buttonKey,
      onPressed: () async {
        final range = await showPartyDateRangeDialog(
          context,
          title: title,
          from: from,
          to: to,
        );
        if (range != null) onChanged(range);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: _active ? AppTheme.primary : colorScheme.onSurface,
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      icon: Icon(
        _active ? Icons.event_available_rounded : Icons.event_outlined,
        size: 16,
      ),
      label: Text(_label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// Shows the shared date range dialog.
///
/// Returns the selected [DateTimeRange] when the user applies, or `null` when
/// the dialog is dismissed.
Future<DateTimeRange?> showPartyDateRangeDialog(
  BuildContext context, {
  String title = 'Filter by date',
  DateTime? from,
  DateTime? to,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (dialogContext) =>
        _PartyDateRangeDialog(title: title, from: from, to: to),
  );
}

class _PartyDateRangeDialog extends StatefulWidget {
  const _PartyDateRangeDialog({
    this.title = 'Filter by date',
    this.from,
    this.to,
  });

  final String title;
  final DateTime? from;
  final DateTime? to;

  @override
  State<_PartyDateRangeDialog> createState() => _PartyDateRangeDialogState();
}

class _PartyDateRangeDialogState extends State<_PartyDateRangeDialog> {
  late DateTime? _from = widget.from;
  late DateTime? _to = widget.to;

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select start date',
    );
    if (picked == null) return;
    setState(() {
      _from = picked;
      if (_to != null && _to!.isBefore(picked)) _to = picked;
    });
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _to ?? _from ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select end date',
    );
    if (picked == null) return;
    setState(() {
      _to = picked;
      if (_from != null && _from!.isAfter(picked)) _from = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String format(DateTime? d) => d == null
        ? 'Not set'
        : '${d.day.toString().padLeft(2, '0')}/'
              '${d.month.toString().padLeft(2, '0')}/${d.year}';

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Records within this range are shown.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickFrom,
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: Text('From: ${format(_from)}'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickTo,
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: Text('To: ${format(_to)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_from == null && _to == null) {
              Navigator.of(context).pop();
              return;
            }
            Navigator.of(
              context,
            ).pop(DateTimeRange(start: _from!, end: _to ?? _from!));
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
