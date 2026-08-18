import 'package:flutter/material.dart';

import '../utils/form_focus_controller.dart';

/// A labelled dropdown styled to match [LabelledField].
class LabelledDropdown<T> extends StatelessWidget {
  const LabelledDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.hintText,
    this.value,
    this.errorText,
    this.keyValue,
    this.focusNode,
    this.containerKey,
  });

  final String label;
  final bool isRequired;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  /// When provided the dropdown is keyed by this value (plus its type) so
  /// its internal selection state can be reset when the value changes.
  final String? keyValue;
  final FocusNode? focusNode;
  final Key? containerKey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormFocusController.applyOrder(
      focusNode,
      Column(
        key: containerKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            key: keyValue == null ? null : ValueKey('$keyValue-$T'),
            initialValue: value,
            focusNode: focusNode,
            isExpanded: true,
            isDense: true,
            items: items,
            onChanged: onChanged,
            hint: hintText == null ? null : Text(hintText!),
            decoration: InputDecoration(errorText: errorText, errorMaxLines: 2),
          ),
        ],
      ),
    );
  }
}
