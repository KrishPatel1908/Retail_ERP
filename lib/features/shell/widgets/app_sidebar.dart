import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/navigation/app_page.dart';
import 'sidebar_group.dart';
import 'sidebar_item.dart';
import 'sidebar_section_label.dart';

/// The collapsible left navigation sidebar.
///
/// Expanded shows icon + label rows and expandable groups; collapsed shows a
/// narrow rail of icon-only destinations with tooltips. A fixed user profile
/// block sits at the bottom of the sidebar in both states.
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.expanded,
    required this.selectedPage,
    required this.onSelect,
  });

  final bool expanded;
  final AppPage selectedPage;
  final ValueChanged<AppPage> onSelect;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final ScrollController _expandedController = ScrollController();
  final ScrollController _collapsedController = ScrollController();

  @override
  void dispose() {
    _expandedController.dispose();
    _collapsedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: widget.expanded
          ? AppConstants.sidebarExpandedWidth
          : AppConstants.sidebarCollapsedWidth,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outlineVariant)),
      ),
      // Content is always laid out at full width; it is clipped by the
      // animating container for a smooth "drawer" slide effect.
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OverflowBox(
              alignment: Alignment.centerLeft,
              minWidth: 0,
              maxWidth: AppConstants.sidebarExpandedWidth,
              minHeight: 0,
              maxHeight: constraints.maxHeight,
              child: SizedBox(
                width: AppConstants.sidebarExpandedWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [...previousChildren, ?currentChild],
                          );
                        },
                        child: widget.expanded
                            ? _buildExpandedList()
                            : SizedBox(
                                width: AppConstants.sidebarCollapsedWidth,
                                child: _buildCollapsedList(),
                              ),
                      ),
                    ),
                    _buildProfileFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandedList() {
    return Scrollbar(
      key: const ValueKey('sidebar-expanded'),
      controller: _expandedController,
      thumbVisibility: true,
      child: ListView(
        controller: _expandedController,
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: _buildItems(expanded: true),
      ),
    );
  }

  Widget _buildCollapsedList() {
    return Scrollbar(
      key: const ValueKey('sidebar-collapsed'),
      controller: _collapsedController,
      thumbVisibility: true,
      child: ListView(
        controller: _collapsedController,
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: _buildItems(expanded: false),
      ),
    );
  }

  /// Builds the sidebar entries for a given UI mode.
  List<Widget> _buildItems({required bool expanded}) {
    return [
      for (final section in appNavigation) ...[
        SidebarSectionLabel(label: section.title, expanded: expanded),
        for (final item in section.items)
          if (item.isGroup)
            SidebarGroup(
              title: item.title,
              icon: item.icon ?? Icons.folder_outlined,
              children: item.children,
              expanded: expanded,
              selectedPage: widget.selectedPage,
              onSelect: widget.onSelect,
            )
          else
            SidebarItem(
              page: item.page!,
              expanded: expanded,
              selected: widget.selectedPage == item.page,
              onTap: () => widget.onSelect(item.page!),
            ),
      ],
    ];
  }

  /// Fixed user profile block pinned to the bottom of the sidebar.
  Widget _buildProfileFooter() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: widget.expanded
              ? double.infinity
              : AppConstants.sidebarCollapsedWidth - 24,
          child: widget.expanded
              ? _buildExpandedProfile()
              : _buildCollapsedProfile(),
        ),
      ),
    );
  }

  Widget _buildExpandedProfile() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                _initials(AppConstants.placeholderUserName),
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.placeholderUserName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppConstants.placeholderUserRole,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Sign out action (visual placeholder — auth is not wired up yet).
        _SignOutButton(),
      ],
    );
  }

  Widget _buildCollapsedProfile() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            _initials(AppConstants.placeholderUserName),
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Visual placeholder only — authentication is not wired up yet.
        IconButton(
          tooltip: 'Sign Out',
          onPressed: () {},
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.logout_rounded, size: 18),
        ),
      ],
    );
  }

  static String _initials(String fullName) {
    return fullName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }
}

/// Outlined-style sign-out row that stretches to the footer width.
class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          // Visual placeholder only — authentication is not wired up yet.
        },
        borderRadius: BorderRadius.circular(10),
        hoverColor: colorScheme.surfaceContainerHigh,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Sign Out',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
