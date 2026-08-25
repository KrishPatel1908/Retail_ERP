import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../domain/entities/purchase.dart';
import '../widgets/purchase_detail_dialog.dart';

/// Purchase Returns list page — shows returns made against purchases.
class PurchaseReturnsPage extends StatefulWidget {
  const PurchaseReturnsPage({
    super.key,
    required this.onNewReturn,
  });

  final VoidCallback onNewReturn;

  @override
  State<PurchaseReturnsPage> createState() => _PurchaseReturnsPageState();
}

class _PurchaseReturnsPageState extends State<PurchaseReturnsPage> {
  late final PurchaseRepository _repository;

  List<PurchaseEntity> _returns = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;
  int _page = 1;
  final int _pageSize = 25;

  @override
  void initState() {
    super.initState();
    _repository = PurchaseRepository();
    _load();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final requestId = ++_searchRequestId;
    setState(() {
      _loading = _returns.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: const PurchaseFilters(isReturn: true),
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _returns = result.items;
        _totalCount = result.totalCount;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim();
      _page = 1;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), _load);
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  void _showDetails(PurchaseEntity purchase) async {
    final full = await _repository.getById(purchase.id);
    if (!mounted) return;
    showPurchaseDetailDialog(context, purchase: full);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String formatDate(DateTime date) {
      final local = date.toLocal();
      return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Purchase Returns',
              description: 'Track products returned to suppliers.',
              breadcrumbs: const ['Purchase', 'Purchase Returns'],
            ),
            const SizedBox(height: 16),
            ContentPanel(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      hintText: 'Search returns...',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _error != null
                  ? EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load returns',
                      message: 'Please try again.',
                      action: OutlinedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                      ),
                    )
                  : Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _loading
                                ? const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2.5))
                                : _returns.isEmpty
                                    ? EmptyState(
                                        icon: Icons.assignment_return_outlined,
                                        title: 'No purchase returns',
                                        message: 'Returns will appear here when products are returned to suppliers.',
                                      )
                                    : ListView.builder(
                                        itemCount: _returns.length,
                                        itemBuilder: (context, index) {
                                          final r = _returns[index];
                                          return Container(
                                            height: 52,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: colorScheme.outlineVariant),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 80,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.visibility_outlined,
                                                          size: 18),
                                                      tooltip: 'View',
                                                      onPressed: () => _showDetails(r),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 140,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                    child: Text(
                                                      r.purchaseNumber,
                                                      style: textTheme.bodyMedium
                                                          ?.copyWith(
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                    child: Text(r.supplierName,
                                                        overflow: TextOverflow.ellipsis),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 110,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                    child: Text(formatDate(r.purchaseDate),
                                                        style: textTheme.bodySmall),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                    child: Text(
                                                      '₹${(r.total / 100).toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                          ),
                          if (!_loading)
                            _buildPaginationFooter(textTheme, colorScheme),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final total = _totalCount;
    final start = total == 0 ? 0 : ((_page - 1) * _pageSize) + 1;
    final end = (_page * _pageSize) > total ? total : (_page * _pageSize);
    final maxPage = (total / _pageSize).ceil().clamp(1, 999999);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $start to $end of $total entries',
            style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                onPressed: _page > 1 ? () => _onPageChanged(_page - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Page $_page of $maxPage',
                    style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                onPressed: _page < maxPage ? () => _onPageChanged(_page + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
