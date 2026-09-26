import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/purchase_return.dart';

/// Shows a read-only purchase return details dialog.
void showPurchaseReturnDetailDialog(
  BuildContext context, {
  required PurchaseReturnEntity purchaseReturn,
}) {
  showDialog(
    context: context,
    builder: (context) =>
        PurchaseReturnDetailDialog(purchaseReturn: purchaseReturn),
  );
}

class PurchaseReturnDetailDialog extends StatelessWidget {
  const PurchaseReturnDetailDialog({super.key, required this.purchaseReturn});

  final PurchaseReturnEntity purchaseReturn;

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
                          'Purchase Return #${purchaseReturn.returnNumber}',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _StatusBadge(status: purchaseReturn.status),
                            const SizedBox(width: 8),
                            Text(
                              'For ${purchaseReturn.originalPurchaseNumber}',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
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
                    _buildInfoSection(textTheme, colorScheme),
                    const SizedBox(height: 24),
                    _buildProductsTable(textTheme, colorScheme),
                    const SizedBox(height: 24),
                    _buildSummary(textTheme, colorScheme),
                    if (purchaseReturn.notes != null &&
                        purchaseReturn.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
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
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(textTheme: textTheme, title: 'Return Information'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoField(
                  label: 'Supplier',
                  value: purchaseReturn.supplierName,
                  textTheme: textTheme,
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'Return Date',
                  value: _formatDate(purchaseReturn.returnDate),
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
                  label: 'Original Purchase No.',
                  value: purchaseReturn.originalPurchaseNumber,
                  textTheme: textTheme,
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'Invoice No.',
                  value: purchaseReturn.originalInvoiceNumber ?? '—',
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
          _SectionTitle(textTheme: textTheme, title: 'Returned Products'),
          const SizedBox(height: 16),
          if (purchaseReturn.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No items',
                style: textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
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
                          child: Text(
                            'Product',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Variant',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                          child: Text(
                            'Return Qty',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 90,
                          child: Text(
                            'Price',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                          child: Text(
                            'Tax',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 90,
                          child: Text(
                            'Line Total',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rows.
                  for (var i = 0; i < purchaseReturn.items.length; i++)
                    _ReturnProductRow(
                      item: purchaseReturn.items[i],
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
          _SummaryRow(
            label: 'Subtotal',
            value: _formatCurrency(purchaseReturn.subtotal),
            textTheme: textTheme,
          ),
          _SummaryRow(
            label: 'Discount',
            value: '- ${_formatCurrency(purchaseReturn.discount)}',
            textTheme: textTheme,
          ),
          _SummaryRow(
            label: 'Tax',
            value: _formatCurrency(purchaseReturn.tax),
            textTheme: textTheme,
          ),
          Divider(color: colorScheme.outlineVariant),
          _SummaryRow(
            label: 'Total Return Amount',
            value: _formatCurrency(purchaseReturn.total),
            textTheme: textTheme,
            bold: true,
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
            purchaseReturn.notes!,
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

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
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
        Icon(
          Icons.circle,
          size: 6,
          color: Theme.of(context).colorScheme.primary,
        ),
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
          style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ReturnProductRow extends StatelessWidget {
  const _ReturnProductRow({
    required this.item,
    required this.isEven,
    required this.textTheme,
    required this.colorScheme,
  });

  final PurchaseReturnItemEntity item;
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
            width: 70,
            child: Text(
              '${item.returnQuantity}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              _formatCurrency(item.purchasePrice),
              textAlign: TextAlign.right,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              '${item.taxRate.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              _formatCurrency(item.lineTotal),
              textAlign: TextAlign.right,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
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
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final bool bold;

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
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final PurchaseReturnStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == PurchaseReturnStatus.reverted
        ? AppTheme.warning
        : AppTheme.success;
    final label = status == PurchaseReturnStatus.reverted
        ? 'REVERTED'
        : 'COMPLETED';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
