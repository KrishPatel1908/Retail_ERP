import 'package:flutter/material.dart';

/// A text field with a label above it and an optional required marker.
class LabelledField extends StatelessWidget {
  const LabelledField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hintText,
    this.maxLines = 1,
    this.controller,
    this.errorText,
  });

  final String label;

  /// When true, an asterisk is shown next to the label.
  final bool isRequired;

  final String? hintText;
  final int maxLines;
  final TextEditingController? controller;

  /// Validation message shown below the field in the error style.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
