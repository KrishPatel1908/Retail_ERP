import 'package:flutter/material.dart';

import '../../domain/entities/unit.dart';
import 'unit_form.dart';

/// Opens the compact "Create Unit" dialog used by other modules (e.g. the
/// UOM Conversion form) to create a unit on the fly.
///
/// Returns the persisted [Unit] when a unit was created, or `null` when the
/// dialog was dismissed without saving.
Future<Unit?> showCreateUnitDialog(BuildContext context) {
  return showDialog<Unit>(
    context: context,
    builder: (dialogContext) => const _CreateUnitDialog(),
  );
}

class _CreateUnitDialog extends StatelessWidget {
  const _CreateUnitDialog();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Create Unit'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a new unit of measure. It becomes available in '
                'every unit picker immediately.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              UnitForm(
                onSaved: (unit) => Navigator.of(context).pop(unit),
                onCancel: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
