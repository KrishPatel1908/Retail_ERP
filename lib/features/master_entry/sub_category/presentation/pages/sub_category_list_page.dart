import 'dart:async';

import 'package:flutter/material.dart';

import 'package:retail_erp/app/theme/app_theme.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import 'package:retail_erp/shared/widgets/empty_state.dart';
import 'package:retail_erp/shared/widgets/page_header.dart';
import 'package:retail_erp/shared/widgets/search_field.dart';

import '../../data/repositories/sub_category_repository.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/exceptions/sub_category_exceptions.dart';
import '../widgets/sub_category_table.dart';

/// Sub Category list module page.
///
/// Loads sub-categories through [SubCategoryRepository] and renders them in a
/// searchable, editable table. Never touches Drift directly.
class SubCategoryListPage extends StatefulWidget {
  const SubCategoryListPage({
    super.key,
    required this.onAddSubCategory,
    required this.onEditSubCategory,
  });

  final VoidCallback onAddSubCategory;
  final ValueChanged<SubCategory> onEditSubCategory;

  @override
  State<SubCategoryListPage> createState() => _SubCategoryListPageState();
}

class _SubCategoryListPageState extends State<SubCategoryListPage> {
  late final SubCategoryRepository _repository;

  List<SubCategory> _subCategories = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = SubCategoryRepository();
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
      _loading = _subCategories.isEmpty;
      _error = null;
    });
    try {
      final rows = _query.isEmpty
          ? await _repository.getAllSubCategories()
          : await _repository.searchSubCategories(_query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _subCategories = rows;
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

  Future<void> _confirmDelete(SubCategory subCategory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete sub category?'),
        content: Text(
          'Delete "${subCategory.subCategoryName}"? This action cannot be undone.',
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
      await _repository.deleteSubCategory(subCategory.id);
      if (!mounted) return;
      _showSnackBar('Sub category deleted successfully.');
      await _load();
    } on SubCategoryInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete sub category. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete sub category. Please try again.');
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
        title: 'Could not load sub-categories',
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
    if (_subCategories.isEmpty) {
      return EmptyState(
        icon: Icons.account_tree_outlined,
        title:
            _query.isEmpty ? 'No sub-categories yet' : 'No sub-categories found',
        message: _query.isEmpty
            ? 'Click "Add Sub Category" to create your first sub-category.'
            : 'Try a different search term.',
      );
    }
    return SubCategoryTable(
      subCategories: _subCategories,
      onEdit: widget.onEditSubCategory,
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
              title: 'Sub Category',
              description:
                  'Organise categories into detailed, searchable sub-categories.',
              breadcrumbs: const ['Master Entry', 'Sub Category'],
              actions: [
                SearchField(
                  hintText: 'Search sub-categories',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-sub-category-button'),
                  onPressed: widget.onAddSubCategory,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Sub Category'),
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
