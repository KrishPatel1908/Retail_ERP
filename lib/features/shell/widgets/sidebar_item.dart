import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_page.dart';

/// A single clickable sidebar destination.
///
/// Renders a full row (icon + label) when [expanded] or an icon-only,
/// tooltip-equipped button when collapsed. The selected destination is shown
/// as a rounded, blue-tinted pill.
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.page,
    required this.expanded,
    required this.selected,
    required this.onTap,
  });

  final AppPage page;
  final bool expanded;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final IconData iconData = selected ? page.filledIcon : page.outlinedIcon;
    final Color iconColor = selected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: expanded ? 10 : 8,
        vertical: expanded ? 2 : 4,
      ),
      padding: expanded
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 11)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: expanded
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: AppConstants.sidebarExpandedWidth - 44,
                child: Row(
                  children: [
                    Icon(iconData, size: 20, color: iconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        page.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 44,
              child: Center(
                child: Icon(iconData, size: 20, color: iconColor),
              ),
            ),
    );

    final Widget item = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: colorScheme.surfaceContainerHigh,
        child: content,
      ),
    );

    // Tooltips are only needed in the collapsed (icon-only) state.
    return expanded ? item : Tooltip(message: page.title, child: item);
  }
}
