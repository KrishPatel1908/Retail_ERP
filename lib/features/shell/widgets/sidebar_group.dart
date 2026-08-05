import 'package:flutter/material.dart';

import '../../../core/navigation/app_page.dart';
import '../../../core/navigation/nav_item.dart';
import 'sidebar_item.dart';

/// An expandable sidebar group (e.g. "Master Entry").
///
/// Expanded: an animated disclosure header with a tree-guide indented child
/// list. Collapsed: an icon button that opens a popup menu of its children.
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
  bool _open = false;

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
    // Keep the group expanded when a child is selected externally.
    if (_hasSelection && !_open) {
      _open = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.expanded ? _buildExpanded(context) : _buildCollapsed(context);
  }

  Widget _buildExpanded(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(10),
            hoverColor: colorScheme.surfaceContainerHigh,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: _hasSelection
                    ? colorScheme.surfaceContainerHigh
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: _hasSelection
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
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
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeOut,
          crossFadeState: _open
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            margin: const EdgeInsets.only(left: 26, right: 8, bottom: 2),
            padding: const EdgeInsets.only(left: 10),
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
                      expanded: true,
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

  Widget _buildCollapsed(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MenuAnchor(
        alignmentOffset: const Offset(8, 0),
        menuChildren: [
          for (final child in widget.children)
            if (child.page != null)
              MenuItemButton(
                leadingIcon: Icon(child.page!.outlinedIcon, size: 18),
                onPressed: () => widget.onSelect(child.page!),
                child: Text(child.title),
              ),
        ],
        builder: (context, controller, _) {
          return Tooltip(
            message: widget.title,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: controller.open,
                borderRadius: BorderRadius.circular(10),
                hoverColor: colorScheme.surfaceContainerHigh,
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
