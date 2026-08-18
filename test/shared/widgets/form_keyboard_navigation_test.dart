import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/shared/utils/form_focus_controller.dart';
import 'package:retail_erp/shared/widgets/labelled_field.dart';

void main() {
  testWidgets('Enter key moves focus to next field for single-line inputs', (
    tester,
  ) async {
    final focus1 = FocusNode();
    final focus2 = FocusNode();
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                LabelledField(
                  label: 'Field 1',
                  controller: controller1,
                  focusNode: focus1,
                  nextFocusNode: focus2,
                  fieldKey: const ValueKey('field-1'),
                ),
                LabelledField(
                  label: 'Field 2',
                  controller: controller2,
                  focusNode: focus2,
                  fieldKey: const ValueKey('field-2'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('field-1')));
    await tester.pumpAndSettle();
    expect(focus1.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    expect(focus2.hasFocus, isTrue);
  });

  testWidgets('Multiline text fields preserve Enter newline editing', (
    tester,
  ) async {
    final focus = FocusNode();
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabelledField(
            label: 'Notes',
            maxLines: 3,
            controller: controller,
            focusNode: focus,
            fieldKey: const ValueKey('notes-field'),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('notes-field')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('notes-field')), 'Line 1');
    await tester.testTextInput.receiveAction(TextInputAction.newline);
    await tester.pumpAndSettle();

    expect(focus.hasFocus, isTrue);
  });

  testWidgets('FormFocusController focuses the first invalid field and scrolls', (
    tester,
  ) async {
    final focusController = FormFocusController();
    final errors = {'field2': 'Field 2 is required.'};
    final fieldOrder = ['field1', 'field2', 'field3'];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 1000), // Push field2 offscreen
                LabelledField(
                  label: 'Field 1',
                  focusNode: focusController.node('field1'),
                  containerKey: focusController.key('field1'),
                ),
                LabelledField(
                  label: 'Field 2',
                  errorText: errors['field2'],
                  focusNode: focusController.node('field2'),
                  containerKey: focusController.key('field2'),
                ),
                LabelledField(
                  label: 'Field 3',
                  focusNode: focusController.node('field3'),
                  containerKey: focusController.key('field3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    focusController.focusFirstError(fieldOrder, errors);
    await tester.pumpAndSettle();

    expect(focusController.node('field2').hasFocus, isTrue);
  });
}
