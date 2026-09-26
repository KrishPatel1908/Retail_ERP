import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';

import 'helpers/test_database.dart';

void main() {
  setUp(resetTestDatabase);

  testWidgets('probe inventory footer width in shell', (tester) async {
    await tester.pumpWidget(const RetailErpApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    debugPrint(
      'PROBE: surface size = ${tester.view.physicalSize} dpr=${tester.view.devicePixelRatio}',
    );

    // Find the pagination footer text and measure its row.
    final showing = find.textContaining('Showing');
    if (showing.evaluate().isNotEmpty) {
      final rect = tester.getRect(showing.first);
      debugPrint('PROBE: showing text rect = $rect');
    } else {
      debugPrint('PROBE: no footer text found (loading or table empty)');
      final empty = find.text('No stock items yet');
      debugPrint('PROBE: empty state found = ${empty.evaluate().length}');
      // The footer is shown even when empty (if !_loading).
      debugPrint(
        'PROBE: has pagination "Page 1" = ${find.textContaining('Page 1').evaluate().length}',
      );
      final pageText = find.textContaining('Page ');
      if (pageText.evaluate().isNotEmpty) {
        debugPrint('PROBE: page text rect = ${tester.getRect(pageText.first)}');
      }
    }
  });
}
