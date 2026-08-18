import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/brand_repository.dart';
import '../../domain/entities/brand.dart';
import '../../domain/exceptions/brand_exceptions.dart';
import '../widgets/brand_table.dart';

/// Brand list module page.
///
/// Loads brands through [BrandRepository] and renders them in a searchable,
/// editable table. Never touches Drift directly.
class BrandListPage extends StatefulWidget {
  const BrandListPage({
    super.key,
    required this.onAddBrand,
    required this.onEditBrand,
  });

  final VoidCallback onAddBrand;
  final ValueChanged<Brand> onEditBrand;

  @override
  State<BrandListPage> createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  late final BrandRepository _repository;

  List<Brand> _brands = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = BrandRepository();
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
      _loading = _brands.isEmpty;
      _error = null;
    });
    try {
      final rows = _query.isEmpty
          ? await _repository.getAllBrands()
          : await _repository.searchBrands(_query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _brands = rows;
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

  Future<void> _confirmDelete(Brand brand) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete brand?'),
        content: Text(
          'Delete "${brand.brandName}"? This action cannot be undone.',
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
      await _repository.deleteBrand(brand.id);
      if (!mounted) return;
      _showSnackBar('Brand deleted successfully.');
      await _load();
    } on BrandInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete brand. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete brand. Please try again.');
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
        title: 'Could not load brands',
        message:
            'Something went wrong while reading the database. '
            'Please try again.',
        action: OutlinedButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
        ),
      );
    }
    if (_brands.isEmpty) {
      return EmptyState(
        icon: Icons.local_offer_outlined,
        title: _query.isEmpty ? 'No brands yet' : 'No brands found',
        message: _query.isEmpty
            ? 'Click "Add Brand" to create your first brand.'
            : 'Try a different search term.',
      );
    }
    return BrandTable(
      brands: _brands,
      onEdit: widget.onEditBrand,
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
              title: 'Brand Master',
              description:
                  'Manage product brands and track assigned product counts.',
              breadcrumbs: const ['Master Entry', 'Brand Master'],
              actions: [
                SearchField(
                  hintText: 'Search brands',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-brand-button'),
                  onPressed: widget.onAddBrand,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Brand'),
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
