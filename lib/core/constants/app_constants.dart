/// Application-wide constants shared across the app.
abstract final class AppConstants {
  static const String appName = 'Retail ERP';

  static const String appVersion = '1.0.0';

  /// Placeholder user shown until authentication is implemented.
  static const String placeholderUserName = 'Krish Patel';
  static const String placeholderUserRole = 'Owner';

  // Layout breakpoints and dimensions (desktop-first).
  static const double sidebarExpandedWidth = 264;
  static const double sidebarCollapsedWidth = 88;

  /// Below this window width the sidebar is forced into its collapsed state.
  static const double autoCollapseSidebarBelowWidth = 760;

  /// Below this window width the user name/role text in the top bar is hidden.
  static const double compactTopBarBelowWidth = 900;

  static const double topBarHeight = 64;
  static const double statusBarHeight = 32;
}
