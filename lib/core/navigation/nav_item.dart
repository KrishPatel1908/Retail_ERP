import 'package:flutter/material.dart';

import 'app_page.dart';

/// A single entry in the sidebar.
///
/// A [NavItem] is either a navigable [AppPage] link or, when [children] is
/// non-empty, an expandable group that wraps a set of links.
class NavItem {
  const NavItem(this.title, this.page, {this.icon, this.children = const []});

  /// Label shown in the sidebar.
  final String title;

  /// Destination page. Null for expandable groups.
  final AppPage? page;

  /// Optional icon, required for expandable groups.
  final IconData? icon;

  /// Child links for expandable groups.
  final List<NavItem> children;

  bool get isGroup => children.isNotEmpty;
}

/// A titled group of sidebar entries used to visually separate navigation.
class NavSection {
  const NavSection(this.title, this.items);

  final String title;
  final List<NavItem> items;
}
