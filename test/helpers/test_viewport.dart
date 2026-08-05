import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Enlarges the widget-test surface so dropdown menus and lazily built
/// table rows fit on screen, then restores the default size when the test
/// finishes.
///
/// The default Flutter test surface (800×600) is too small for the
/// measure dropdowns (8 items) and for asserting rows that sort below the
/// fold of a lazy [ListView]-backed table.
void useTallViewport(
  WidgetTester tester, {
  Size size = const Size(1400, 2200),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
