import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_page.dart';
import '../../../core/navigation/nav_item.dart';
import 'sidebar_item.dart';

/// An expandable sidebar group (e.g. "Master Entry").
///
/// In both expanded and collapsed modes, renders a group header and an
/// indented tree guide column of child items.
/// Expanded: displays group icon, title text, chevron, and labeled child items.
/// Collapsed: displays group icon with tooltip, and icon-only child items.
class SidebarGroup extends StatefulWidget {
  const SidebarGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.expanded,
    required this.selectedPage,
    required this.onSelect,
  });

  final String title;
  final IconData icon;
  final List<NavItem> children;

  /// Sidebar UI mode (expanded vs collapsed).
  final bool expanded;

  final AppPage selectedPage;
  final ValueChanged<AppPage> onSelect;

  @override
  State<SidebarGroup> createState() => _SidebarGroupState();
}

class _SidebarGroupState extends State<SidebarGroup> {
  late bool _open;

  bool get _hasSelection =>
      widget.children.any((child) => child.page == widget.selectedPage);

  @override
  void initState() {
    super.initState();
    _open = _hasSelection;
  }

  @override
  void didUpdateWidget(SidebarGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the group open when a child is selected externally.
    if (_hasSelection && !_open) {
      _open = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final IconData groupIcon = widget.icon;
    final Color iconColor = _hasSelection
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final Widget headerContent = Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: widget.expanded ? 10 : 8,
        vertical: widget.expanded ? 2 : 4,
      ),
      padding: widget.expanded
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 11)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _hasSelection
            ? colorScheme.surfaceContainerHigh
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget.expanded
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: AppConstants.sidebarExpandedWidth - 44,
                child: Row(
                  children: [
                    Icon(groupIcon, size: 20, color: iconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: _hasSelection
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _hasSelection
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 44,
              child: Center(child: Icon(groupIcon, size: 20, color: iconColor)),
            ),
    );

    final Widget headerItem = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => setState(() => _open = !_open),
        borderRadius: BorderRadius.circular(10),
        hoverColor: colorScheme.surfaceContainerHigh,
        child: headerContent,
      ),
    );

    final Widget headerWithTooltip = widget.expanded
        ? headerItem
        : Tooltip(message: widget.title, child: headerItem);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        headerWithTooltip,
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeOut,
          crossFadeState: _open
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            margin: widget.expanded
                ? const EdgeInsets.only(left: 26, right: 8, bottom: 2)
                : const EdgeInsets.only(left: 24, right: 8, bottom: 4),
            padding: EdgeInsets.only(left: widget.expanded ? 10 : 6),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: colorScheme.outlineVariant, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final child in widget.children)
                  if (child.page != null)
                    SidebarItem(
                      page: child.page!,
                      expanded: widget.expanded,
                      selected: widget.selectedPage == child.page,
                      onTap: () => widget.onSelect(child.page!),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
