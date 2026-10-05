import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../master_entry/customer/domain/entities/customer.dart';

/// Payment checkout dialog with explicit Cancel action.
///
/// Returns [PaymentDialogResult] on confirmation, or `null` if cancelled.
/// Cancelling guarantees that no sale is saved and cart remains intact.
class PaymentDialogResult {
  const PaymentDialogResult({
    required this.paymentMethod,
    required this.amountReceived,
    this.notes,
  });

  final String paymentMethod;
  final int amountReceived;
  final String? notes;
}

Future<PaymentDialogResult?> showPaymentDialog(
  BuildContext context, {
  required int grandTotalPaise,
  required Customer? selectedCustomer,
  required String currencySymbol,
  String initialPaymentMethod = 'Cash',
  int? initialReceivedPaise,
}) async {
  return showDialog<PaymentDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PaymentDialog(
      grandTotalPaise: grandTotalPaise,
      selectedCustomer: selectedCustomer,
      currencySymbol: currencySymbol,
      initialPaymentMethod: initialPaymentMethod,
      initialReceivedPaise: initialReceivedPaise,
    ),
  );
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({
    super.key,
    required this.grandTotalPaise,
    required this.selectedCustomer,
    required this.currencySymbol,
    this.initialPaymentMethod = 'Cash',
    this.initialReceivedPaise,
  });

  final int grandTotalPaise;
  final Customer? selectedCustomer;
  final String currencySymbol;
  final String initialPaymentMethod;
  final int? initialReceivedPaise;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late String _paymentMethod;
  late final TextEditingController _receivedController;
  late final TextEditingController _notesController;
  final FocusNode _receivedFocus = FocusNode();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.initialPaymentMethod;

    final initialPaise = widget.initialReceivedPaise ?? widget.grandTotalPaise;
    _receivedController = TextEditingController(
      text: (initialPaise / 100).toStringAsFixed(2),
    );
    _notesController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_paymentMethod == 'Cash') {
        _receivedFocus.requestFocus();
        _receivedController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _receivedController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _receivedController.dispose();
    _notesController.dispose();
    _receivedFocus.dispose();
    super.dispose();
  }

  int get _receivedAmountPaise {
    final parsed = double.tryParse(_receivedController.text.trim()) ?? 0.0;
    return (parsed * 100).round();
  }

  int get _changeAmountPaise {
    if (_paymentMethod != 'Cash') return 0;
    return (_receivedAmountPaise > widget.grandTotalPaise)
        ? _receivedAmountPaise - widget.grandTotalPaise
        : 0;
  }

  int get _balanceAmountPaise {
    if (_paymentMethod == 'Credit') return widget.grandTotalPaise;
    if (_paymentMethod == 'Cash') {
      return (_receivedAmountPaise < widget.grandTotalPaise)
          ? widget.grandTotalPaise - _receivedAmountPaise
          : 0;
    }
    return 0;
  }

  String _formatAmount(int paise) {
    return '${widget.currencySymbol}${(paise / 100).toStringAsFixed(2)}';
  }

  void _onMethodSelected(String method) {
    setState(() {
      _paymentMethod = method;
      _errorMessage = null;
      if (method == 'Cash') {
        if (_receivedAmountPaise <= 0) {
          _receivedController.text =
              (widget.grandTotalPaise / 100).toStringAsFixed(2);
        }
      } else if (method == 'Credit') {
        _receivedController.text = '0.00';
      } else {
        _receivedController.text =
            (widget.grandTotalPaise / 100).toStringAsFixed(2);
      }
    });
  }

  void _onQuickCash(double amount) {
    setState(() {
      _receivedController.text = amount.toStringAsFixed(2);
      _errorMessage = null;
    });
  }

  void _onConfirm() {
    setState(() => _errorMessage = null);

    if (_paymentMethod == 'Credit' && widget.selectedCustomer == null) {
      setState(() {
        _errorMessage = 'Credit sales require selecting a registered customer.';
      });
      return;
    }

    if (_paymentMethod == 'Cash' &&
        widget.selectedCustomer == null &&
        _receivedAmountPaise < widget.grandTotalPaise) {
      setState(() {
        _errorMessage =
            'Walk-in customer cash sales must be fully paid. Received: ${_formatAmount(_receivedAmountPaise)}, Total: ${_formatAmount(widget.grandTotalPaise)}.';
      });
      return;
    }

    Navigator.of(context).pop(
      PaymentDialogResult(
        paymentMethod: _paymentMethod,
        amountReceived: _receivedAmountPaise,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.payments_rounded,
                      color: AppTheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment / Checkout',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.selectedCustomer != null
                              ? 'Customer: ${widget.selectedCustomer!.customerName}'
                              : 'Customer: Walk-in Customer',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Cancel & Return to POS',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grand Total Hero Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _formatAmount(widget.grandTotalPaise),
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Payment Method Grid
              Text(
                'Payment Method',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildMethodButton('Cash', Icons.money_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMethodButton('UPI', Icons.qr_code_2_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMethodButton('Card', Icons.credit_card_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMethodButton('Credit', Icons.account_balance_wallet_rounded)),
                ],
              ),
              const SizedBox(height: 16),

              // Method-specific Inputs
              if (_paymentMethod == 'Cash') ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Amount Tendered / Received',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      height: 42,
                      child: TextField(
                        controller: _receivedController,
                        focusNode: _receivedFocus,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        decoration: InputDecoration(
                          prefixText: '${widget.currencySymbol} ',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.border),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Quick Cash Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickCashChip(
                        'Exact',
                        widget.grandTotalPaise / 100,
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: _buildQuickCashChip('₹100', 100)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildQuickCashChip('₹200', 200)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildQuickCashChip('₹500', 500)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildQuickCashChip('₹1000', 1000)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildQuickCashChip('₹2000', 2000)),
                  ],
                ),
                const SizedBox(height: 14),

                // Change or Balance calculation
                if (_changeAmountPaise > 0)
                  _buildSummaryItem(
                    'Change to Return',
                    _formatAmount(_changeAmountPaise),
                    color: AppTheme.success,
                    isBold: true,
                  ),
                if (_balanceAmountPaise > 0)
                  _buildSummaryItem(
                    'Balance Due (Credit)',
                    _formatAmount(_balanceAmountPaise),
                    color: AppTheme.warning,
                    isBold: true,
                  ),
              ] else if (_paymentMethod == 'UPI') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.hover,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 24, color: AppTheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Scan store QR code to collect ${_formatAmount(widget.grandTotalPaise)} via UPI.',
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_paymentMethod == 'Card') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.hover,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_rounded, size: 24, color: AppTheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Swipe or tap card on terminal for ${_formatAmount(widget.grandTotalPaise)}.',
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_paymentMethod == 'Credit') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.selectedCustomer != null
                        ? AppTheme.selected
                        : AppTheme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.selectedCustomer != null
                          ? AppTheme.primary.withValues(alpha: 0.3)
                          : AppTheme.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.selectedCustomer != null
                            ? Icons.account_balance_wallet_rounded
                            : Icons.warning_amber_rounded,
                        size: 22,
                        color: widget.selectedCustomer != null ? AppTheme.primary : AppTheme.danger,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.selectedCustomer != null
                              ? 'Credit sale will be added to ${widget.selectedCustomer!.customerName}\'s ledger balance.'
                              : 'Credit sales require selecting a registered customer.',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.selectedCustomer != null
                                ? AppTheme.primary
                                : AppTheme.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.danger.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Actions: Cancel & Confirm Payment
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _onConfirm,
                      icon: const Icon(Icons.check_circle_rounded, size: 20),
                      label: const Text(
                        'Confirm Payment',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButton(String method, IconData icon) {
    final isSelected = _paymentMethod == method;
    return InkWell(
      onTap: () => _onMethodSelected(method),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.selected : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              method,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCashChip(String label, double amount, {bool isPrimary = false}) {
    return OutlinedButton(
      onPressed: () => _onQuickCash(amount),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        minimumSize: Size.zero,
        backgroundColor: isPrimary ? AppTheme.primary.withValues(alpha: 0.08) : null,
        side: BorderSide(color: isPrimary ? AppTheme.primary : AppTheme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
          color: isPrimary ? AppTheme.primary : AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
