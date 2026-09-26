import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/entities/inventory.dart';
import '../../domain/services/stock_service.dart';

/// Result of a confirmed stock adjustment.
class StockAdjustmentResult {
  const StockAdjustmentResult({
    required this.newStock,
    required this.direction,
    required this.quantity,
  });

  final int newStock;
  final StockAdjustmentDirection direction;
  final int quantity;
}

/// Opens the Stock Adjustment dialog. Returns true when an adjustment was
/// saved so the caller can refresh its data.
Future<bool> showStockAdjustmentDialog(
  BuildContext context, {
  InventoryItemEntity? preselected,
}) async {
  final result = await showDialog<StockAdjustmentResult>(
    context: context,
    builder: (_) => _StockAdjustmentDialog(preselected: preselected),
  );
  return result != null;
}

class _StockAdjustmentDialog extends StatefulWidget {
  const _StockAdjustmentDialog({this.preselected});

  final InventoryItemEntity? preselected;

  @override
  State<_StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<_StockAdjustmentDialog> {
  late final InventoryRepository _repository;

  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityFocusNode = FocusNode();
  final _reasonFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();

  List<StockAdjustmentOption> _options = const [];
  StockAdjustmentOption? _selected;
  bool _loadingOptions = true;
  StockAdjustmentDirection _direction = StockAdjustmentDirection.increase;
  bool _saving = false;
  String? _quantityError;
  String? _reasonError;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository();
    _loadOptions();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    _quantityFocusNode.dispose();
    _reasonFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final options = await _repository.adjustmentOptions();
      if (!mounted) return;
      setState(() {
        _options = options;
        _loadingOptions = false;
        if (widget.preselected != null) {
          _selected = options
              .where(
                (o) =>
                    o.productId == widget.preselected!.productId &&
                    o.variantId == widget.preselected!.variantId,
              )
              .firstOrNull;
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingOptions = false);
      debugPrint('Failed to load stock items: $error');
    }
  }

  int get _currentStock => _selected?.currentStock ?? 0;

  int? get _parsedQuantity {
    final text = _quantityController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text.replaceAll(',', ''));
  }

  int? get _computedNewStock {
    final quantity = _parsedQuantity;
    if (quantity == null || quantity <= 0) return null;
    return _direction == StockAdjustmentDirection.increase
        ? _currentStock + quantity
        : _currentStock - quantity;
  }

  String? _validateQuantity(String? _) {
    final quantity = _parsedQuantity;
    if (quantity == null) return 'Enter a valid quantity.';
    if (quantity <= 0) return 'Quantity must be greater than 0.';
    if (_direction == StockAdjustmentDirection.decrease &&
        quantity > _currentStock) {
      return 'Insufficient stock. Available stock: $_currentStock.';
    }
    return null;
  }

  Future<void> _save() async {
    final quantityError = _validateQuantity(null);
    final reasonError = _reasonController.text.trim().isEmpty
        ? 'A reason is required.'
        : null;
    if (_selected == null) {
      setState(() {
        _quantityError = quantityError;
        _reasonError = reasonError;
      });
      _showFailure('Select a product or variant first.');
      return;
    }
    setState(() {
      _quantityError = quantityError;
      _reasonError = reasonError;
    });
    if (quantityError != null || reasonError != null) return;

    final quantity = _parsedQuantity!;
    final direction = _direction;
    final currentStock = _currentStock;
    final newStock = direction == StockAdjustmentDirection.increase
        ? currentStock + quantity
        : currentStock - quantity;
    final itemName = _selected!.itemName;

    // Confirmation before saving, per the adjustment rules.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Stock Adjustment'),
        content: Text(
          '$itemName\n\n'
          'Current stock: $currentStock\n'
          'Adjustment: ${direction == StockAdjustmentDirection.increase ? '+' : '-'}$quantity\n'
          'New stock: $newStock\n\n'
          'A stock movement will be recorded for this adjustment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save Adjustment'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await _repository.createAdjustment(
        productId: _selected!.productId,
        variantId: _selected!.variantId,
        direction: direction,
        quantity: quantity,
        reason: _reasonController.text,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text,
        adjustmentDate: DateTime.now(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(
        StockAdjustmentResult(
          newStock: newStock,
          direction: direction,
          quantity: quantity,
        ),
      );
    } on InsufficientStockException catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _quantityError = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      debugPrint('Stock adjustment failed: $error');
      _showFailure('Could not save the adjustment. Please try again.');
    }
  }

  void _showFailure(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final newStock = _computedNewStock;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Stock Adjustment',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Close',
                      onPressed: _saving ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_loadingOptions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  )
                else ...[
                  // Product / Variant picker.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product / Variant',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<StockAdjustmentOption>(
                        initialValue: _selected,
                        isDense: true,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          hintText: 'Select a product or variant',
                        ),
                        items: [
                          for (final option in _options)
                            DropdownMenuItem(
                              value: option,
                              child: Text(
                                '${option.itemName}'
                                '${option.barcode == null ? '' : '  ·  ${option.barcode}'}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: _saving
                            ? null
                            : (value) => setState(() {
                                _selected = value;
                                _quantityError = null;
                              }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Current stock + adjustment type.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Stock',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 44,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.hover,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Text(
                                '$_currentStock'
                                '${_selected == null ? '' : '  ${_selected!.unitName}'}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adjustment Type',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SegmentedButton<StockAdjustmentDirection>(
                              segments: const [
                                ButtonSegment(
                                  value: StockAdjustmentDirection.increase,
                                  icon: Icon(Icons.add_rounded, size: 16),
                                  label: Text('Increase'),
                                ),
                                ButtonSegment(
                                  value: StockAdjustmentDirection.decrease,
                                  icon: Icon(Icons.remove_rounded, size: 16),
                                  label: Text('Decrease'),
                                ),
                              ],
                              selected: {_direction},
                              onSelectionChanged: _saving
                                  ? null
                                  : (selection) => setState(() {
                                      _direction = selection.first;
                                      _quantityError = _validateQuantity(null);
                                    }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Quantity + new stock.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: LabelledField(
                          label: 'Adjustment Quantity',
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          enabled: !_saving,
                          errorText: _quantityError,
                          onChanged: (_) => setState(() {
                            _quantityError = _validateQuantity(null);
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Stock',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 44,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.hover,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Text(
                                newStock == null
                                    ? '—'
                                    : '${_direction == StockAdjustmentDirection.increase ? '+' : '-'} → $newStock',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: newStock != null && newStock < 0
                                      ? AppTheme.danger
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  LabelledField(
                    label: 'Reason',
                    isRequired: true,
                    controller: _reasonController,
                    focusNode: _reasonFocusNode,
                    hintText: 'e.g. Damaged goods, stock count correction',
                    enabled: !_saving,
                    errorText: _reasonError,
                    onChanged: (_) => setState(() => _reasonError = null),
                  ),
                  const SizedBox(height: 14),
                  LabelledField(
                    label: 'Note',
                    controller: _noteController,
                    focusNode: _noteFocusNode,
                    hintText: 'Optional note',
                    enabled: !_saving,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Save Adjustment'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
