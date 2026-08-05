import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_page.dart';

/// Thin bottom status bar showing application state at a glance.
class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.selectedPage});

  final AppPage selectedPage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mutedStyle = textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Container(
      height: AppConstants.statusBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text('Ready', style: mutedStyle),
          const Spacer(),
          Text(selectedPage.title, style: mutedStyle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('•', style: mutedStyle),
          ),
          Text('v${AppConstants.appVersion}', style: mutedStyle),
        ],
      ),
    );
  }
}
