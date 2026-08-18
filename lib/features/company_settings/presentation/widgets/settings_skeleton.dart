import 'package:flutter/material.dart';

/// Static loading skeleton shown while company settings are being read.
///
/// Mirrors the real page layout (title, then one block per settings card) so
/// the transition to the loaded form is seamless.
class SettingsSkeleton extends StatelessWidget {
  const SettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final blockColor = colorScheme.surfaceContainerHighest;

    Widget block({double? width, double height = 14}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: blockColor,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    Widget card() {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(width: 180, height: 18),
            const SizedBox(height: 18),
            block(width: double.infinity),
            const SizedBox(height: 12),
            block(width: double.infinity),
          ],
        ),
      );
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
        children: [
          block(width: 240, height: 26),
          const SizedBox(height: 10),
          block(width: 440, height: 13),
          const SizedBox(height: 24),
          for (var i = 0; i < 7; i++) ...[
            card(),
            if (i < 6) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
