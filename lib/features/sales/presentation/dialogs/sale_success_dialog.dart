import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/sale.dart';

/// Opens the sale completion receipt / success dialog.
Future<void> showSaleSuccessDialog(
  BuildContext context, {
  required SaleEntity sale,
  required String currencySymbol,
  required VoidCallback onNewSale,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => SaleSuccessDialog(
      sale: sale,
      currencySymbol: currencySymbol,
      onNewSale: onNewSale,
    ),
  );
}

class SaleSuccessDialog extends StatelessWidget {
  const SaleSuccessDialog({
    super.key,
    required this.sale,
    required this.currencySymbol,
    required this.onNewSale,
  });

  final SaleEntity sale;
  final String currencySymbol;
  final VoidCallback onNewSale;

  String _formatAmount(int paise) {
    return '$currencySymbol${(paise / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Success Icon
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Sale Completed Successfully!',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  sale.saleNumber,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.hover,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'Customer',
                      sale.customerName ?? 'Walk-in Customer',
                      textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'Date & Time',
                      '${sale.saleDate.day.toString().padLeft(2, '0')}/${sale.saleDate.month.toString().padLeft(2, '0')}/${sale.saleDate.year} '
                      '${sale.saleDate.hour.toString().padLeft(2, '0')}:${sale.saleDate.minute.toString().padLeft(2, '0')}',
                      textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'Payment Method',
                      '${sale.paymentMethod} (${sale.paymentStatus.label})',
                      textTheme,
                    ),
                    const Divider(height: 20, color: AppTheme.border),
                    _buildRow('Subtotal', _formatAmount(sale.subtotal), textTheme),
                    if (sale.discount > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        'Discount',
                        '-${_formatAmount(sale.discount)}',
                        textTheme,
                        valueColor: AppTheme.success,
                      ),
                    ],
                    if (sale.tax > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow('Tax', _formatAmount(sale.tax), textTheme),
                    ],
                    const Divider(height: 20, color: AppTheme.border),
                    _buildRow(
                      'Grand Total',
                      _formatAmount(sale.grandTotal),
                      textTheme,
                      isBold: true,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'Amount Paid',
                      _formatAmount(sale.paidAmount),
                      textTheme,
                    ),
                    if (sale.changeAmount > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        'Change Returned',
                        _formatAmount(sale.changeAmount),
                        textTheme,
                        valueColor: AppTheme.success,
                        isBold: true,
                      ),
                    ],
                    if (sale.balanceAmount > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        'Outstanding Due',
                        _formatAmount(sale.balanceAmount),
                        textTheme,
                        valueColor: AppTheme.danger,
                        isBold: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt sent to printer.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.print_rounded, size: 18),
                      label: const Text('Print Receipt'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onNewSale();
                      },
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                      label: const Text('Next Sale'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildRow(
    String label,
    String value,
    TextTheme textTheme, {
    bool isBold = false,
    double? fontSize,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: valueColor ?? AppTheme.textPrimary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
