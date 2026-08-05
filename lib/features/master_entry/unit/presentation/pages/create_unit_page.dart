import 'package:flutter/material.dart';

import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../domain/entities/unit.dart';
import '../widgets/unit_form.dart';

/// "Create / Edit Unit" form page.
///
/// With [unit] `null` the page creates a new unit; otherwise it edits the
/// given unit (the form is pre-filled). The actual fields, validation and
/// save flow live in [UnitForm] so the standalone page and the compact
/// "Add New Unit" dialog behave identically.
class CreateUnitPage extends StatelessWidget {
  const CreateUnitPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.unit,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided the page edits this unit instead of creating one.
  final Unit? unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEditing = unit != null;
    final title = isEditing ? 'Edit Unit' : 'Create Unit';
    final subtitle = isEditing
        ? 'Update the details of this unit.'
        : 'Add a new unit of measure to the ERP.';

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(items: ['Master Entry', 'Unit Master', title]),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ContentPanel(
                  padding: const EdgeInsets.all(28),
                  child: UnitForm(
                    onSaved: (_) => onSave(),
                    onCancel: onCancel,
                    unit: unit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
