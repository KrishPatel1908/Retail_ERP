import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/tax_category_repository.dart';
import '../../domain/entities/tax_category.dart';
import '../../domain/exceptions/tax_category_exceptions.dart';
import '../widgets/tax_category_table.dart';

/// Tax Category list module page.
///
/// Loads tax categories through [TaxCategoryRepository] and renders them in a
/// searchable, editable table. Never touches Drift directly.
class TaxCategoryListPage extends StatefulWidget {
  const TaxCategoryListPage({
    super.key,
    required this.onAddTaxCategory,
    required this.onEditTaxCategory,
  });

  final VoidCallback onAddTaxCategory;
  final ValueChanged<TaxCategory> onEditTaxCategory;

  @override
  State<TaxCategoryListPage> createState() => _TaxCategoryListPageState();
}

class _TaxCategoryListPageState extends State<TaxCategoryListPage> {
  late final TaxCategoryRepository _repository;

  List<TaxCategory> _taxCategories = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = TaxCategoryRepository();
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
      _loading = _taxCategories.isEmpty;
      _error = null;
    });
    try {
      final rows = _query.isEmpty
          ? await _repository.getAllTaxCategories()
          : await _repository.searchTaxCategories(_query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _taxCategories = rows;
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

  Future<void> _confirmDelete(TaxCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete tax category?'),
        content: Text(
          'Delete "${category.taxCategoryName}"? This action cannot be undone.',
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
      await _repository.deleteTaxCategory(category.id);
      if (!mounted) return;
      _showSnackBar('Tax category deleted successfully.');
      await _load();
    } on TaxCategoryInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete tax category. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete tax category. Please try again.');
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
        title: 'Could not load tax categories',
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
    if (_taxCategories.isEmpty) {
      return EmptyState(
        icon: Icons.request_quote_outlined,
        title: _query.isEmpty ? 'No tax categories yet' : 'No tax categories found',
        message: _query.isEmpty
            ? 'Click "Add Tax Category" to create your first tax category configuration.'
            : 'Try a different search term.',
      );
    }
    return TaxCategoryTable(
      taxCategories: _taxCategories,
      onEdit: widget.onEditTaxCategory,
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
              title: 'Tax Category Master',
              description:
                  'Manage reusable tax configurations used across the ERP.',
              breadcrumbs: const ['Master Entry', 'Tax Category'],
              actions: [
                SearchField(
                  hintText: 'Search tax categories',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-tax-category-button'),
                  onPressed: widget.onAddTaxCategory,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Tax Category'),
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
