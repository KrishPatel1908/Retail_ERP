import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/purchase.dart';

/// Shows a read-only purchase details dialog.
void showPurchaseDetailDialog(
  BuildContext context, {
  required PurchaseEntity purchase,
  VoidCallback? onEdit,
}) {
  showDialog(
    context: context,
    builder: (context) => PurchaseDetailDialog(
      purchase: purchase,
      onEdit: onEdit,
    ),
  );
}

class PurchaseDetailDialog extends StatelessWidget {
  const PurchaseDetailDialog({
    super.key,
    required this.purchase,
    this.onEdit,
  });

  final PurchaseEntity purchase;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header.
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase #${purchase.purchaseNumber}',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _StatusBadge(
                              status: purchase.paymentStatus,
                            ),
                            if (purchase.isReturn) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RETURN',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppTheme.danger,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit'),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Purchase Information.
                    _buildInfoSection(textTheme, colorScheme),
                    const SizedBox(height: 24),

                    // Products table.
                    _buildProductsTable(textTheme, colorScheme),
                    const SizedBox(height: 24),

                    // Summary.
                    _buildSummary(textTheme, colorScheme),

                    if (purchase.notes != null &&
                        purchase.notes!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildNotes(textTheme, colorScheme),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(TextTheme textTheme, ColorScheme colorScheme) {
    String formatDate(DateTime date) {
      final local = date.toLocal();
      return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
    }

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(textTheme: textTheme, title: 'Purchase Information'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoField(
                  label: 'Supplier',
                  value: purchase.supplierName,
                  textTheme: textTheme,
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'Purchase Date',
                  value: formatDate(purchase.purchaseDate),
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoField(
                  label: 'Invoice No.',
                  value: purchase.invoiceNumber ?? '—',
                  textTheme: textTheme,
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'Payment Method',
                  value: purchase.paymentMethod ?? '—',
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTable(TextTheme textTheme, ColorScheme colorScheme) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(textTheme: textTheme, title: 'Products'),
          const SizedBox(height: 16),
          if (purchase.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No items',
                style: textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Header.
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.hover,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('Product',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Variant',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              )),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text('Qty',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              )),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text('Unit',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              )),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text('Price',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.right),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text('Tax',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.right),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text('Total',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                  ),
                  // Rows.
                  for (var i = 0; i < purchase.items.length; i++)
                    _ProductRow(
                      item: purchase.items[i],
                      isEven: i % 2 == 0,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummary(TextTheme textTheme, ColorScheme colorScheme) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(textTheme: textTheme, title: 'Summary'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: financial summary.
              Expanded(
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: _formatCurrency(purchase.subtotal),
                      textTheme: textTheme,
                    ),
                    _SummaryRow(
                      label: 'Discount',
                      value: '- ${_formatCurrency(purchase.discount)}',
                      textTheme: textTheme,
                    ),
                    _SummaryRow(
                      label: 'Tax',
                      value: _formatCurrency(purchase.tax),
                      textTheme: textTheme,
                    ),
                    Divider(color: colorScheme.outlineVariant),
                    _SummaryRow(
                      label: 'Grand Total',
                      value: _formatCurrency(purchase.total),
                      textTheme: textTheme,
                      bold: true,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Paid Amount',
                      value: _formatCurrency(purchase.paidAmount),
                      textTheme: textTheme,
                    ),
                    _SummaryRow(
                      label: 'Due Amount',
                      value: _formatCurrency(purchase.dueAmount),
                      textTheme: textTheme,
                      valueColor: purchase.dueAmount > 0
                          ? AppTheme.danger
                          : AppTheme.textPrimary,
                    ),
                    _SummaryRow(
                      label: 'Payment Status',
                      value: purchase.paymentStatus.label,
                      textTheme: textTheme,
                      valueColor: switch (purchase.paymentStatus) {
                        PurchasePaymentStatus.paid => AppTheme.success,
                        PurchasePaymentStatus.partial => AppTheme.warning,
                        PurchasePaymentStatus.unpaid => AppTheme.danger,
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(TextTheme textTheme, ColorScheme colorScheme) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(textTheme: textTheme, title: 'Notes'),
          const SizedBox(height: 8),
          Text(
            purchase.notes!,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}

// ─── Helper widgets ───

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.textTheme, required this.title});

  final TextTheme textTheme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle,
            size: 6,
            color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.item,
    required this.isEven,
    required this.textTheme,
    required this.colorScheme,
  });

  final PurchaseItemEntity item;
  final bool isEven;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: isEven ? null : colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.productName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.variantName ?? '—',
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text('${item.quantity}', style: textTheme.bodySmall),
          ),
          SizedBox(
            width: 80,
            child: Text(
              item.unitName ?? '—',
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              _formatCurrency(item.purchasePrice),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '${item.taxRate.toStringAsFixed(1)}%',
              style: textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              _formatCurrency(item.lineTotal),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textTheme,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final PurchasePaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PurchasePaymentStatus.paid => AppTheme.success,
      PurchasePaymentStatus.partial => AppTheme.warning,
      PurchasePaymentStatus.unpaid => AppTheme.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
