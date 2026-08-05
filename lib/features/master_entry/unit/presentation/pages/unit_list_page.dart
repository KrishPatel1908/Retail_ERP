import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/unit_repository.dart';
import '../../domain/entities/unit.dart';
import '../../domain/exceptions/unit_exceptions.dart';
import '../widgets/unit_table.dart';

/// Unit Master list page.
///
/// Loads units through [UnitRepository] and renders them in a searchable,
/// editable table. Never touches Drift directly.
class UnitListPage extends StatefulWidget {
  const UnitListPage({
    super.key,
    required this.onAddUnit,
    required this.onEditUnit,
  });

  final VoidCallback onAddUnit;
  final ValueChanged<Unit> onEditUnit;

  @override
  State<UnitListPage> createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  late final UnitRepository _repository;

  List<Unit> _units = const [];
  bool _loading = true;
  Object? _error;
  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _repository = UnitRepository();
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
      // Only block the view on the very first load; keep the previous list
      // visible while searching or refreshing.
      _loading = _units.isEmpty;
      _error = null;
    });
    try {
      final rows = _query.isEmpty
          ? await _repository.getAllUnits()
          : await _repository.searchUnits(_query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _units = rows;
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

  Future<void> _confirmDelete(Unit unit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete unit?'),
        content: Text(
          'Delete "${unit.unitName}"? This action cannot be undone.',
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
      await _repository.deleteUnit(unit.id);
      if (!mounted) return;
      _showSnackBar('Unit deleted successfully.');
      await _load();
    } on UnitInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete unit. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete unit. Please try again.');
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
        title: 'Could not load units',
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
    if (_units.isEmpty) {
      return EmptyState(
        icon: Icons.straighten_outlined,
        title: _query.isEmpty ? 'No units yet' : 'No units found',
        message: _query.isEmpty
            ? 'Click "Add Unit" to create your first unit of measure.'
            : 'Try a different search term.',
      );
    }
    return UnitTable(
      units: _units,
      onEdit: widget.onEditUnit,
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
              title: 'Unit Master',
              description:
                  'Manage the units of measure used across the ERP.',
              breadcrumbs: const ['Master Entry', 'Unit Master'],
              actions: [
                SearchField(
                  hintText: 'Search units',
                  width: 340,
                  onChanged: _onSearchChanged,
                ),
                FilledButton.icon(
                  key: const ValueKey('add-unit-button'),
                  onPressed: widget.onAddUnit,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Unit'),
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
