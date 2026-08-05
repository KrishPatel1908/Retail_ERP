import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Minimal top application bar: sidebar toggle and brand.
///
/// Deliberately quiet — the user profile now lives at the bottom of the
/// sidebar, keeping this bar reserved for the brand identity.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.onToggleSidebar,
    required this.sidebarExpanded,
  });

  final VoidCallback onToggleSidebar;
  final bool sidebarExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      child: Container(
        height: AppConstants.topBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            IconButton(
              key: const ValueKey('sidebar-toggle'),
              onPressed: onToggleSidebar,
              tooltip: sidebarExpanded ? 'Collapse sidebar' : 'Expand sidebar',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  sidebarExpanded
                      ? Icons.menu_open_rounded
                      : Icons.menu_rounded,
                  key: ValueKey(sidebarExpanded),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Brand mark.
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.storefront_rounded,
                size: 21,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppConstants.appName,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
