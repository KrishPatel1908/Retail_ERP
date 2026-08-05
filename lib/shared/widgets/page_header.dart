import 'package:flutter/material.dart';

import 'breadcrumbs.dart';

/// Title block for a content page with optional breadcrumbs, a short
/// description and action widgets (e.g. toolbar buttons).
///
/// On narrow windows actions wrap below the title, each independently.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.description,
    this.breadcrumbs = const [],
    this.actions = const [],
  });

  final String title;

  /// A one-line summary shown under the title.
  final String? description;

  final List<String> breadcrumbs;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumbs.isNotEmpty) ...[
          Breadcrumbs(items: breadcrumbs),
          const SizedBox(height: 10),
        ],
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    description!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            ...actions,
          ],
        ),
      ],
    );
  }
}
