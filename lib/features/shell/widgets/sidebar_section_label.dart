import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

/// A small uppercase label that groups sidebar entries.
///
/// When collapsed it is replaced by a thin divider to preserve visual rhythm.
class SidebarSectionLabel extends StatelessWidget {
  const SidebarSectionLabel({
    super.key,
    required this.label,
    required this.expanded,
  });

  final String label;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Divider(color: colorScheme.outlineVariant),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: AppTheme.textMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }
}
