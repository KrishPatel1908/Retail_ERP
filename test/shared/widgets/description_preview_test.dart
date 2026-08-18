import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/shared/widgets/description_preview.dart';

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
      return null;
    });
  });
  Widget wrapWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  testWidgets('displays dash when description is null or empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWidget(const DescriptionPreview(description: null)),
    );
    expect(find.text('—'), findsOneWidget);

    await tester.pumpWidget(
      wrapWidget(const DescriptionPreview(description: '')),
    );
    expect(find.text('—'), findsOneWidget);

    await tester.pumpWidget(
      wrapWidget(const DescriptionPreview(description: '   ')),
    );
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('tapping empty description does not open dialog', (tester) async {
    await tester.pumpWidget(
      wrapWidget(const DescriptionPreview(description: null)),
    );
    await tester.tap(find.text('—'));
    await tester.pumpAndSettle();

    expect(find.text('Description'), findsNothing);
  });

  testWidgets('renders non-empty description string', (tester) async {
    await tester.pumpWidget(
      wrapWidget(
        const DescriptionPreview(description: 'Sample description text'),
      ),
    );

    expect(find.text('Sample description text'), findsOneWidget);
  });

  testWidgets('tapping description opens modal dialog with full text', (
    tester,
  ) async {
    const fullText =
        'This is a long description text that gets displayed inside the centered dialog when clicked.';

    await tester.pumpWidget(
      wrapWidget(const DescriptionPreview(description: fullText)),
    );

    await tester.tap(find.text(fullText));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text(fullText), findsWidgets);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Close'), findsWidgets);
  });

  testWidgets('closing dialog removes modal', (tester) async {
    await tester.pumpWidget(
      wrapWidget(
        const DescriptionPreview(description: 'Test close behavior'),
      ),
    );

    await tester.tap(find.text('Test close behavior'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Close'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('clicking copy button updates button label to Copied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWidget(
        const DescriptionPreview(description: 'Text to copy'),
      ),
    );

    await tester.tap(find.text('Text to copy'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Copy'));
    await tester.pump();

    expect(find.text('Copied'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
