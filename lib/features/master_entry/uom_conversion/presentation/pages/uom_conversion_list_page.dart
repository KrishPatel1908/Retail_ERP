import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/uom_conversion_repository.dart';
import '../../domain/entities/uom_conversion.dart';
import '../../domain/exceptions/uom_conversion_exceptions.dart';
import '../widgets/uom_conversion_table.dart';

/// UOM Conversion list page.
///
/// Loads global conversions through [UomConversionRepository] and renders
/// them in a searchable, editable table. Never touches Drift directly.
class UomConversionListPage extends StatefulWidget {
  const UomConversionListPage({
    super.key,
    required this.onAddConversion,
    required this.onEditConversion,
  });

  final VoidCallback onAddConversion;
  final ValueChanged<UomConversion> onEditConversion;

  @override
  State<UomConversionListPage> createState() => _UomConversionListPageState();
}

class _UomConversionListPageState extends State<UomConversionListPage> {
  late final UomConversionRepository _repository;

  List<UomConversion> _conversions = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = UomConversionRepository();
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

  Future<void> _confirmDelete(UomConversion conversion) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete conversion?'),
        content: Text(
          'Delete "${conversion.summary}"? This action cannot be undone.',
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
      _showSnackBar('Conversion deleted successfully.');
      await _load();
    } on UomConversionNotFoundException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete conversion. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete conversion. Please try again.');
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
        title: 'Could not load conversions',
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
    if (_conversions.isEmpty) {
      return EmptyState(
        icon: Icons.swap_horiz_rounded,
        title: _query.isEmpty ? 'No conversions yet' : 'No conversions found',
        message: _query.isEmpty
            ? 'Click "Add Conversion" to define a universal unit conversion '
                  '(e.g. 1 Kilogram = 1000 Gram).'
            : 'Try a different search term.',
      );
    }
    return UomConversionTable(
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
              title: 'UOM Conversion',
              description:
                  'Universal conversions between units — the reverse '
                  'direction is derived automatically.',
              breadcrumbs: const ['Master Entry', 'UOM Conversion'],
              actions: [
                SearchField(
                  hintText: 'Search conversions',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-conversion-button'),
                  onPressed: widget.onAddConversion,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Conversion'),
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
