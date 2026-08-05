import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// A rounded, white content region used to host lists and data areas.
///
/// The panel is a soft card: white surface, subtle border and a gentle shadow
/// for a light sense of elevation without heaviness.
class ContentPanel extends StatelessWidget {
  const ContentPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: AppTheme.softShadow,
      ),
      child: child,
    );
  }
}
