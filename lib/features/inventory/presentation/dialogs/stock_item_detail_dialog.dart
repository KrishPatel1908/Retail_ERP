import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/entities/inventory.dart';

/// Opens the read-only stock detail view for one product/variant, including
/// its stock movement history.
Future<void> showStockItemDetailDialog(
  BuildContext context, {
  required InventoryItemEntity item,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _StockItemDetailDialog(item: item),
  );
}

class _StockItemDetailDialog extends StatefulWidget {
  const _StockItemDetailDialog({required this.item});

  final InventoryItemEntity item;

  @override
  State<_StockItemDetailDialog> createState() => _StockItemDetailDialogState();
}

class _StockItemDetailDialogState extends State<_StockItemDetailDialog> {
  late final InventoryRepository _repository;
  List<StockMovementEntity> _movements = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  int _page = 1;
  final int _pageSize = 10;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository();
    _loadMovements();
  }

  Future<void> _loadMovements() async {
    final requestId = ++_requestId;
    setState(() {
      _loading = _movements.isEmpty;
      _error = null;
    });
    try {
      final page = await _repository.fetchMovements(
        productId: widget.item.productId,
        variantId: widget.item.variantId,
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _movements = page.items;
        _totalCount = page.totalCount;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final item = widget.item;

    final statusColor = item.status == StockStatus.inStock
        ? AppTheme.success
        : item.status == StockStatus.lowStock
        ? AppTheme.warning
        : AppTheme.danger;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860, maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header.
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
                      Icons.warehouse_outlined,
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
                                item.productName,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.status.label,
                                style: textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Product Code: ${item.productCode}'
                          '${item.variantName == null ? '' : '  ·  Variant: ${item.variantName}'}',
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

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Details.
                      Text(
                        'Stock Details',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 28,
                        runSpacing: 16,
                        children: [
                          _detail('Current Stock',
                              '${item.currentStock} ${item.unitName ?? ''}'),
                          _detail('Barcode', item.barcode ?? '—'),
                          _detail('Category', item.categoryName ?? '—'),
                          _detail('Brand', item.brandName ?? '—'),
                          _detail('Unit', item.unitName ?? '—'),
                          _detail(
                            'Purchase Price',
                            item.purchasePrice == null
                                ? '—'
                                : _formatCurrency(item.purchasePrice!),
                          ),
                          _detail(
                            'Selling Price',
                            item.sellingPrice == null
                                ? '—'
                                : _formatCurrency(item.sellingPrice!),
                          ),
                          _detail(
                            'MRP',
                            item.mrp == null
                                ? '—'
                                : _formatCurrency(item.mrp!),
                          ),
                          _detail('Minimum Stock', '${item.minimumStock}'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Movement history.
                      Text(
                        'Stock Movement History',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        )
                      else if (_error != null)
                        EmptyState(
                          icon: Icons.error_outline_rounded,
                          title: 'Could not load movements',
                          message: 'Please try again.',
                          action: OutlinedButton(
                            onPressed: _loadMovements,
                            child: const Text('Retry'),
                          ),
                        )
                      else if (_movements.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No stock movements recorded yet.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        )
                      else ...[
                        _buildMovementHeader(),
                        for (final movement in _movements)
                          _buildMovementRow(movement),
                        if (_totalCount > _pageSize) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Showing $_page–${_movements.length} of $_totalCount',
                                  style: textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Previous page',
                                    icon: const Icon(
                                      Icons.chevron_left_rounded,
                                      size: 20,
                                    ),
                                    onPressed: _page > 1
                                        ? () {
                                            setState(() => _page -= 1);
                                            _loadMovements();
                                          }
                                        : null,
                                  ),
                                  IconButton(
                                    tooltip: 'Next page',
                                    icon: const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 20,
                                    ),
                                    onPressed:
                                        (_page * _pageSize) < _totalCount
                                            ? () {
                                                setState(() => _page += 1);
                                                _loadMovements();
                                              }
                                            : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementHeader() {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: AppTheme.textSecondary,
    );
    Widget pad(String text, {bool right = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            textAlign: right ? TextAlign.right : TextAlign.left,
            style: style,
          ),
        );

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.hover,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          SizedBox(width: 90, child: pad('Date')),
          Expanded(flex: 2, child: pad('Transaction')),
          SizedBox(width: 110, child: pad('Reference')),
          SizedBox(width: 70, child: pad('In', right: true)),
          SizedBox(width: 70, child: pad('Out', right: true)),
          SizedBox(width: 80, child: pad('Previous', right: true)),
          SizedBox(width: 70, child: pad('New', right: true)),
          Expanded(child: pad('Note')),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMovementRow(StockMovementEntity movement) {
    final textTheme = Theme.of(context).textTheme;
    final inColor = AppTheme.success;
    final outColor = AppTheme.danger;

    String textOrDash(String? value) =>
        (value == null || value.trim().isEmpty) ? '—' : value.trim();
    String qtyOrDash(int? value) => value == null ? '—' : '$value';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              movement.transactionDate == null
                  ? '—'
                  : _formatDate(movement.transactionDate!),
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              movement.typeLabel,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              textOrDash(movement.referenceNumber),
              style: textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                movement.isIn ? '+${movement.quantity}' : '—',
                style: textTheme.bodySmall?.copyWith(
                  color: inColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                movement.isOut ? '${movement.quantity}' : '—',
                style: textTheme.bodySmall?.copyWith(
                  color: outColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                qtyOrDash(movement.previousQuantity),
                style: textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                qtyOrDash(movement.newQuantity),
                style: textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Text(
              textOrDash(movement.note),
              style: textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}
