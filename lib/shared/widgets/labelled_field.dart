import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/form_focus_controller.dart';

/// A text field with a label above it, optional required marker, keyboard focus
/// management, and automatic scroll-into-view.
class LabelledField extends StatefulWidget {
  const LabelledField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hintText,
    this.maxLines = 1,
    this.controller,
    this.errorText,
    this.fieldKey,
    this.containerKey,
    this.focusNode,
    this.nextFocusNode,
    this.onSubmitted,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
  });

  final String label;

  /// When true, an asterisk is shown next to the label.
  final bool isRequired;

  final String? hintText;
  final int maxLines;
  final TextEditingController? controller;

  /// Validation message shown below the field in the error style.
  final String? errorText;

  /// Optional key for the inner [TextField] itself, so tests and other code
  /// can target the field directly.
  final Key? fieldKey;

  /// Key attached to the outer container for scroll-into-view positioning.
  final Key? containerKey;

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;

  @override
  State<LabelledField> createState() => _LabelledFieldState();
}

class _LabelledFieldState extends State<LabelledField> {
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(LabelledField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null && _internalFocusNode != null) {
        _internalFocusNode!.dispose();
        _internalFocusNode = null;
      }
      _effectiveFocusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_effectiveFocusNode.hasFocus && mounted) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.2,
      );
    }
  }

  void _handleSubmitted(String value) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    } else if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    } else {
      FocusScope.of(context).nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isSingleLine = widget.maxLines == 1;
    final effectiveInputAction =
        widget.textInputAction ??
        (isSingleLine ? TextInputAction.next : TextInputAction.newline);

    return FormFocusController.applyOrder(
      _effectiveFocusNode,
      Column(
        key: widget.containerKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isRequired) ...[
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
            key: widget.fieldKey,
            controller: widget.controller,
            focusNode: _effectiveFocusNode,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: effectiveInputAction,
            onSubmitted: isSingleLine ? _handleSubmitted : widget.onSubmitted,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText,
              errorMaxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
