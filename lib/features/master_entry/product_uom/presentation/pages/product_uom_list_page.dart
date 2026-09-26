import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/product_uom_repository.dart';
import '../../domain/entities/product_uom_display.dart';
import '../widgets/product_uom_table.dart';

/// Product UOM Conversion list page.
class ProductUomListPage extends StatefulWidget {
  const ProductUomListPage({
    super.key,
    required this.onAddConversion,
    required this.onEditConversion,
  });

  final VoidCallback onAddConversion;
  final ValueChanged<ProductUomDisplay> onEditConversion;

  @override
  State<ProductUomListPage> createState() => _ProductUomListPageState();
}

class _ProductUomListPageState extends State<ProductUomListPage> {
  late final ProductUomRepository _repository;

  List<ProductUomDisplay> _conversions = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = ProductUomRepository();
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
      _loading = _conversions.isEmpty;
      _error = null;
    });
    try {
      final rows = _query.isEmpty
          ? await _repository.getAllConversions()
          : await _repository.searchConversions(_query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _conversions = rows;
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
    setState(() => _query = value.trim());
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), _load);
  }

  Future<void> _confirmDelete(ProductUomDisplay conversion) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product conversion?'),
        content: Text(
          'Delete conversion for "${conversion.productName}" '
          '(${conversion.fromUnitName} → ${conversion.toUnitName})? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _repository.deleteConversion(conversion.id);
      if (!mounted) return;
      _showSnackBar('Product conversion deleted successfully.');
      await _load();
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete product conversion. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete product conversion. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load product conversions',
        message:
            'Something went wrong while reading the database. Please try again.',
        action: OutlinedButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
        ),
      );
    }
    if (_conversions.isEmpty) {
      return EmptyState(
        icon: Icons.transform_outlined,
        title: _query.isEmpty
            ? 'No product conversions yet'
            : 'No product conversions found',
        message: _query.isEmpty
            ? 'Click "Add Product Conversion" to define product-specific unit rules.'
            : 'Try a different search term.',
      );
    }
    return ProductUomTable(
      conversions: _conversions,
      onEdit: widget.onEditConversion,
      onDelete: _confirmDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Product UOM Conversion',
              description:
                  'Define product-specific unit conversions and set default sales/purchase units.',
              breadcrumbs: const ['Master Entry', 'Product UOM Conversion'],
              actions: [
                SearchField(
                  hintText: 'Search product conversions',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-product-uom-button'),
                  onPressed: widget.onAddConversion,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Product Conversion'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
}
