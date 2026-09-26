import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../domain/entities/product_lookup_item.dart';

/// Searchable product picker field.
class ProductPickerField extends StatelessWidget {
  const ProductPickerField({
    super.key,
    required this.products,
    required this.selectedId,
    required this.onChanged,
    required this.onNavigateToProducts,
    this.label = 'Product',
    this.isRequired = true,
    this.hintText = 'Select a product',
    this.errorText,
  });

  final String label;
  final bool isRequired;
  final List<ProductLookupItem> products;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final VoidCallback onNavigateToProducts;
  final String hintText;
  final String? errorText;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showDialog<int>(
      context: context,
      builder: (dialogContext) => _ProductPickerDialog(
        products: products,
        selectedId: selectedId,
        onNavigateToProducts: onNavigateToProducts,
      ),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selected = products.where((p) => p.id == selectedId).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: InputDecoration(errorText: errorText, errorMaxLines: 2),
            child: Row(
              children: [
                Expanded(
                  child: selected == null
                      ? Text(
                          hintText,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '${selected.productName} (${selected.productCode})',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductPickerDialog extends StatefulWidget {
  const _ProductPickerDialog({
    required this.products,
    required this.selectedId,
    required this.onNavigateToProducts,
  });

  final List<ProductLookupItem> products;
  final int? selectedId;
  final VoidCallback onNavigateToProducts;

  @override
  State<_ProductPickerDialog> createState() => _ProductPickerDialogState();
}

class _ProductPickerDialogState extends State<_ProductPickerDialog> {
  String _query = '';

  List<ProductLookupItem> get _filteredProducts {
    final normalized = _query.trim().toLowerCase();
    return widget.products.where((p) {
      if (normalized.isEmpty) return true;
      return p.productName.toLowerCase().contains(normalized) ||
          p.productCode.toLowerCase().contains(normalized);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filteredProducts;

    return AlertDialog(
      title: const Text('Select Product'),
      content: SizedBox(
        width: 420,
        height: 440,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search_rounded, size: 20),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: widget.products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 40,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No products found. Please create a product first.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.onNavigateToProducts();
                            },
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Go to Product Master'),
                          ),
                        ],
                      ),
                    )
                  : filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No products match your search.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        final isSelected = product.id == widget.selectedId;
                        return ListTile(
                          dense: true,
                          title: Text(
                            product.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            product.productCode,
                            style: textTheme.bodySmall,
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: AppTheme.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(product.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
