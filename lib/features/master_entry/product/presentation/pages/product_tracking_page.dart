import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/product_repository.dart';
import '../../services/product_validator.dart';

/// Display row for the tracking table — each row is either a standalone
/// product or a specific variant of a product.
class _TrackingRow {
  const _TrackingRow({
    required this.productCode,
    required this.productName,
    this.variantName,
    required this.categoryName,
    required this.unitName,
    required this.sellingPrice,
    this.expiryDate,
    required this.hasVariants,
  });

  final String productCode;
  final String productName;
  final String? variantName;
  final String? categoryName;
  final String? unitName;
  final int sellingPrice;
  final DateTime? expiryDate;
  final bool hasVariants;

  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final now = DateTime.now();
    final diff = expiryDate!.difference(now).inDays;
    return diff >= 0 && diff <= 30;
  }
}

/// Product Tracking module — shows product + variant data derived from
/// Product Master. Prioritises expiry information.
class ProductTrackingPage extends StatefulWidget {
  const ProductTrackingPage({super.key});

  @override
  State<ProductTrackingPage> createState() => _ProductTrackingPageState();
}

class _ProductTrackingPageState extends State<ProductTrackingPage> {
  late final ProductRepository _repository;

  List<_TrackingRow> _rows = const [];
  bool _loading = true;
  Object? _error;

  String _query = '';

  @override
  void initState() {
    super.initState();
    _repository = ProductRepository();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _rows.isEmpty;
      _error = null;
    });
    try {
      final products = await _repository.fetchAllWithVariants();
      final rows = <_TrackingRow>[];

      for (final product in products) {
        if (product.hasVariants) {
          // Show each variant as a separate tracking row.
          for (final variant in product.variants) {
            rows.add(_TrackingRow(
              productCode: product.productCode,
              productName: product.productName,
              variantName: variant.variantName,
              categoryName: product.categoryName,
              unitName: product.unitName,
              sellingPrice: variant.sellingPrice,
              expiryDate: variant.expiryDate ?? product.expiryDate,
              hasVariants: true,
            ));
          }
        } else {
          // Standalone product (no variants).
          rows.add(_TrackingRow(
            productCode: product.productCode,
            productName: product.productName,
            categoryName: product.categoryName,
            unitName: product.unitName,
            sellingPrice: product.sellingPrice,
            expiryDate: product.expiryDate,
            hasVariants: false,
          ));
        }
      }

      // Apply client-side search.
      final normalizedQuery = _query.toLowerCase();
      final filtered = normalizedQuery.isEmpty
          ? rows
          : rows.where((row) {
              return row.productName.toLowerCase().contains(normalizedQuery) ||
                  row.productCode.toLowerCase().contains(normalizedQuery) ||
                  (row.variantName ?? '')
                      .toLowerCase()
                      .contains(normalizedQuery) ||
                  (row.categoryName ?? '')
                      .toLowerCase()
                      .contains(normalizedQuery);
            }).toList();

      if (!mounted) return;
      setState(() {
        _rows = filtered;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Product Tracking',
              description:
                  'Track product information and expiry dates from Product Master.',
              breadcrumbs: const ['Master Entry', 'Product Tracking'],
            ),
            const SizedBox(height: 16),

            // Search
            ContentPanel(
              padding: const EdgeInsets.all(16),
              child: SearchField(
                hintText:
                    'Search product name, code, variant, or category...',
                onChanged: (value) {
                  setState(() => _query = value.trim());
                  _load();
                },
              ),
            ),
            const SizedBox(height: 16),

            // Table
            Expanded(
              child: _error != null
                  ? EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load tracking data',
                      message: 'Please try again.',
                      action: OutlinedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                      ),
                    )
                  : AppDataTable<_TrackingRow>(
                      items: _rows,
                      keyExtractor: (r) =>
                          '${r.productCode}-${r.variantName ?? 'standalone'}',
                      isLoading: _loading,
                      showPagination: true,
                      page: 1,
                      pageSize: 50,
                      emptyWidget: EmptyState(
                        icon: Icons.show_chart_outlined,
                        title: 'No tracking data yet',
                        message:
                            'Products from Product Master will appear here automatically.',
                      ),
                      columns: [
                        // Product Code
                        AppDataTableColumn<_TrackingRow>(
                          id: 'code',
                          label: 'Code',
                          width: 120,
                          cellBuilder: (context, row) => Text(
                            row.productCode,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Product Name
                        AppDataTableColumn<_TrackingRow>(
                          id: 'product',
                          label: 'Product',
                          flex: 2,
                          cellBuilder: (context, row) => Text(
                            row.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Variant
                        AppDataTableColumn<_TrackingRow>(
                          id: 'variant',
                          label: 'Variant',
                          flex: 1,
                          cellBuilder: (context, row) => Text(
                            row.variantName ?? '—',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        // Category
                        AppDataTableColumn<_TrackingRow>(
                          id: 'category',
                          label: 'Category',
                          flex: 1,
                          cellBuilder: (context, row) => Text(
                            row.categoryName ?? '—',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Unit
                        AppDataTableColumn<_TrackingRow>(
                          id: 'unit',
                          label: 'Unit',
                          width: 80,
                          cellBuilder: (context, row) =>
                              Text(row.unitName ?? '—'),
                        ),
                        // Selling Price
                        AppDataTableColumn<_TrackingRow>(
                          id: 'price',
                          label: 'Price',
                          width: 100,
                          numeric: true,
                          cellBuilder: (context, row) => Text(
                            ProductValidator.formatCurrency(row.sellingPrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Expiry Date
                        AppDataTableColumn<_TrackingRow>(
                          id: 'expiry',
                          label: 'Expiry Date',
                          width: 120,
                          cellBuilder: (context, row) {
                            if (row.expiryDate == null) {
                              return const Text('—');
                            }
                            final text =
                                '${row.expiryDate!.day.toString().padLeft(2, '0')}/'
                                '${row.expiryDate!.month.toString().padLeft(2, '0')}/'
                                '${row.expiryDate!.year}';
                            Color? color;
                            if (row.isExpired) {
                              color = AppTheme.danger;
                            } else if (row.isExpiringSoon) {
                              color = AppTheme.warning;
                            }
                            return Text(
                              text,
                              style: TextStyle(
                                fontWeight: color != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: color,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
