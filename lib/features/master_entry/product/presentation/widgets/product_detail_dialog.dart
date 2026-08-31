import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../../services/product_validator.dart';

/// Shows a read-only detail dialog for a [ProductEntity] including its variants.
Future<void> showProductDetailDialog(
  BuildContext context, {
  required ProductEntity product,
  VoidCallback? onEdit,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => ProductDetailDialog(
      product: product,
      onEdit: onEdit,
    ),
  );
}

/// Dedicated read-only product detail dialog widget.
class ProductDetailDialog extends StatelessWidget {
  const ProductDetailDialog({
    super.key,
    required this.product,
    this.onEdit,
  });

  final ProductEntity product;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String textOrDash(String? value) {
      if (value == null || value.trim().isEmpty) return '—';
      return value.trim();
    }

    String currencyOrDash(int? paise) {
      if (paise == null) return '—';
      return ProductValidator.formatCurrency(paise);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840, maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.productName,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _StatusBadge(isActive: product.isActive),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Product Code: ${product.productCode}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Basic Information
                      _buildSectionTitle(context, 'Basic Information'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(context, 'Category',
                            textOrDash(product.categoryName)),
                        _buildDetailItem(context, 'Sub Category',
                            textOrDash(product.subCategoryName)),
                        _buildDetailItem(
                            context, 'Brand', textOrDash(product.brandName)),
                        _buildDetailItem(
                            context, 'Unit', textOrDash(product.unitName)),
                        _buildDetailItem(context, 'Barcode / SKU',
                            textOrDash(product.barcode)),
                        _buildDetailItem(context, 'HSN/SAC Code',
                            textOrDash(product.hsnCode)),
                      ]),
                      const SizedBox(height: 20),

                      // Pricing & Tax Information
                      _buildSectionTitle(
                        context,
                        'Pricing & Tax Information',
                      ),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Selling Price',
                          ProductValidator.formatCurrency(product.sellingPrice),
                          isBold: true,
                        ),
                        _buildDetailItem(
                          context,
                          'Purchase Price',
                          currencyOrDash(product.purchasePrice),
                        ),
                        _buildDetailItem(
                          context,
                          'MRP',
                          currencyOrDash(product.mrp),
                        ),
                        _buildDetailItem(
                          context,
                          'Wholesale Price',
                          currencyOrDash(product.wholesalePrice),
                        ),
                        _buildDetailItem(
                          context,
                          'Tax',
                          textOrDash(product.taxCategoryName),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Additional Information
                      _buildSectionTitle(context, 'Additional Information'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Expiry Date',
                          product.expiryDate != null
                              ? _formatDate(product.expiryDate!)
                              : '—',
                        ),
                        _buildDetailItem(
                            context, 'Notes', textOrDash(product.notes)),
                      ]),
                      const SizedBox(height: 20),

                      // Variants
                      if (product.variants.isNotEmpty) ...[
                        _buildSectionTitle(
                          context,
                          'Variants (${product.variants.length})',
                        ),
                        const SizedBox(height: 12),
                        _buildVariantsTable(context, product.variants),
                        const SizedBox(height: 20),
                      ],

                      // System Information
                      _buildSectionTitle(context, 'System Information'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Created Date',
                          _formatDate(product.createdAt),
                        ),
                        _buildDetailItem(
                          context,
                          'Last Updated',
                          _formatDateTime(product.updatedAt),
                        ),
                      ]),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  if (onEdit != null) ...[
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Product'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantsTable(
    BuildContext context,
    List<ProductVariantEntity> variants,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String currencyOrDash(int? paise) {
      if (paise == null) return '—';
      return ProductValidator.formatCurrency(paise);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.hover,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Variant Name',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'Selling Price',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'Purchase Price',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'MRP',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'Wholesale',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'Barcode',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Expiry Date',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Notes',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          for (var i = 0; i < variants.length; i++)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: i < variants.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      variants[i].variantName,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      ProductValidator.formatCurrency(
                        variants[i].sellingPrice,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      currencyOrDash(variants[i].purchasePrice),
                      style: textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      currencyOrDash(variants[i].mrp),
                      style: textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      currencyOrDash(variants[i].wholesalePrice),
                      style: textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      variants[i].barcode ?? '—',
                      style: textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      variants[i].expiryDate != null
                          ? _formatDate(variants[i].expiryDate!)
                          : '—',
                      style: textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      variants[i].notes ?? '—',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 480 ? 2 : 1;
        if (crossAxisCount == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += 2) {
          final first = children[i];
          final hasSecond = i + 1 < children.length;
          final second = hasSecond ? children[i + 1] : const SizedBox.shrink();

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: first),
                const SizedBox(width: 16),
                Expanded(child: second),
              ],
            ),
          );
          if (i + 2 < children.length) {
            rows.add(const SizedBox(height: 12));
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final d = dateTime.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    final d = dateTime.toLocal();
    final hourInt = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}, '
        '${hourInt.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} $period';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: textTheme.labelSmall?.copyWith(
          color: isActive ? AppTheme.success : AppTheme.danger,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
