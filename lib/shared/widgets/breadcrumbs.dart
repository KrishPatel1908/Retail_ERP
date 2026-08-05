import 'package:flutter/material.dart';

/// A horizontal chain of breadcrumb items separated by chevrons.
///
/// The last item is emphasised as the current location.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 2,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          Text(
            items[i],
            style: textTheme.bodySmall?.copyWith(
              color: i == items.length - 1
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              fontWeight: i == items.length - 1
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
