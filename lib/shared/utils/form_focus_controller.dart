import 'package:flutter/material.dart';

/// Owns deterministic focus order and error positioning for an ERP form.
///
/// Shared controls can call [applyOrder] with one of this controller's nodes;
/// this keeps the explicit order intact even when responsive layouts rebuild.
class FormFocusController {
  FormFocusController([this.fieldOrder = const []]);

  final List<String> fieldOrder;
  final Map<String, FocusNode> _nodes = {};
  final Map<String, GlobalKey> _keys = {};

  static final Map<FocusNode, NumericFocusOrder> _focusOrders = {};

  FocusNode node(String fieldKey) {
    return _nodes.putIfAbsent(fieldKey, () {
      final node = FocusNode(debugLabel: 'erp-form-$fieldKey');
      final index = fieldOrder.indexOf(fieldKey);
      if (index >= 0) {
        _focusOrders[node] = NumericFocusOrder(index.toDouble() + 1);
      }
      return node;
    });
  }

  GlobalKey key(String fieldKey) {
    return _keys.putIfAbsent(fieldKey, () => GlobalKey());
  }

  /// Applies this form's [NumericFocusOrder] to a focusable shared control.
  static Widget applyOrder(FocusNode? focusNode, Widget child) {
    final order = focusNode == null ? null : _focusOrders[focusNode];
    return order == null
        ? child
        : FocusTraversalOrder(order: order, child: child);
  }

  /// Focuses and scrolls the earliest invalid control in the canonical order.
  void focusFirstError(
    Object errorsOrOrder, [
    Map<String, String?>? legacyErrors,
  ]) {
    // The optional second argument preserves compatibility with existing forms
    // while new forms keep the order in the controller constructor.
    final errors = legacyErrors ?? errorsOrOrder as Map<String, String?>;
    final order = legacyErrors == null
        ? fieldOrder
        : errorsOrOrder as List<String>;
    for (final fieldKey in order) {
      if (errors[fieldKey] == null) continue;
      final focusNode = _nodes[fieldKey];
      if (focusNode == null) continue;
      focusNode.requestFocus();
      final context = _keys[fieldKey]?.currentContext ?? focusNode.context;
      if (context != null && context.mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 250),
          alignment: 0.2,
        );
      }
      break;
    }
  }

  void dispose() {
    for (final node in _nodes.values) {
      _focusOrders.remove(node);
      node.dispose();
    }
    _nodes.clear();
    _keys.clear();
  }
}
