import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:retail_erp/features/master_entry/tax_type/data/repositories/tax_type_repository.dart';
import 'package:retail_erp/features/master_entry/tax_type/domain/entities/tax_type.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/tax_category_repository.dart';
import '../../domain/entities/tax_category.dart';
import '../../domain/entities/tax_category_component.dart';
import '../../domain/exceptions/tax_category_exceptions.dart';
import '../../services/tax_category_validator.dart';

/// Row helper for managing component form state.
class _ComponentRowState {
  _ComponentRowState({
    this.taxTypeId,
    required String percentageText,
  }) : percentageController = TextEditingController(text: percentageText);

  int? taxTypeId;
  final TextEditingController percentageController;

  void dispose() {
    percentageController.dispose();
  }
}

/// "Create / Edit Tax Category" form page.
///
/// With [category] `null` the page creates a new tax category; otherwise it edits
/// the given category (pre-filled with components).
class CreateTaxCategoryPage extends StatefulWidget {
  const CreateTaxCategoryPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.category,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided, the page edits this tax category instead of creating one.
  final TaxCategory? category;

  @override
  State<CreateTaxCategoryPage> createState() => _CreateTaxCategoryPageState();
}

class _CreateTaxCategoryPageState extends State<CreateTaxCategoryPage> {
  late final TaxCategoryRepository _categoryRepository;
  late final TaxTypeRepository _taxTypeRepository;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  final List<_ComponentRowState> _componentRows = [];
  List<TaxType> _availableTaxTypes = const [];
  bool _loadingTaxTypes = true;

  String? _nameError;
  String? _descriptionError;
  String? _componentsError;
  bool _saving = false;

  bool get _isEditing => widget.category != null;

  double get _calculatedTotalTax {
    double total = 0.0;
    for (final row in _componentRows) {
      final parsed = double.tryParse(row.percentageController.text.trim()) ?? 0.0;
      total += parsed;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _categoryRepository = TaxCategoryRepository();
    _taxTypeRepository = TaxTypeRepository();

    final category = widget.category;
    _nameController = TextEditingController(text: category?.taxCategoryName);
    _descriptionController = TextEditingController(text: category?.description);

    if (category != null && category.components.isNotEmpty) {
      for (final comp in category.components) {
        _componentRows.add(
          _ComponentRowState(
            taxTypeId: comp.taxTypeId,
            percentageText: comp.percentage.toStringAsFixed(
              comp.percentage.truncateToDouble() == comp.percentage ? 0 : 2,
            ),
          ),
        );
      }
    } else {
      _componentRows.add(_ComponentRowState(taxTypeId: null, percentageText: ''));
    }

    _loadTaxTypes();
  }

  Future<void> _loadTaxTypes() async {
    try {
      final types = await _taxTypeRepository.getAllTaxTypes();
      if (!mounted) return;
      setState(() {
        _availableTaxTypes = types;
        _loadingTaxTypes = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingTaxTypes = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final row in _componentRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addComponentRow() {
    setState(() {
      _componentRows.add(_ComponentRowState(taxTypeId: null, percentageText: ''));
      _componentsError = null;
    });
  }

  void _removeComponentRow(int index) {
    if (_componentRows.length <= 1) {
      setState(() {
        _componentsError = 'At least one Tax Component is required.';
      });
      return;
    }
    setState(() {
      final removed = _componentRows.removeAt(index);
      removed.dispose();
      _componentsError = null;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final nameError = TaxCategoryValidator.validateName(name);
    final descriptionError = TaxCategoryValidator.validateDescription(description);

    // Build components from row states
    final componentsList = <TaxCategoryComponent>[];
    for (final row in _componentRows) {
      final taxTypeId = row.taxTypeId;
      if (taxTypeId == null) continue;
      final typeObj = _availableTaxTypes.firstWhere(
        (t) => t.id == taxTypeId,
        orElse: () => TaxType(
          id: taxTypeId,
          taxTypeName: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      final pct = double.tryParse(row.percentageController.text.trim()) ?? -1.0;
      componentsList.add(
        TaxCategoryComponent(
          taxTypeId: taxTypeId,
          taxTypeName: typeObj.taxTypeName,
          percentage: pct,
        ),
      );
    }

    final componentsError = TaxCategoryValidator.validateComponents(componentsList);

    if (nameError != null || descriptionError != null || componentsError != null) {
      setState(() {
        _nameError = nameError;
        _descriptionError = descriptionError;
        _componentsError = componentsError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _nameError = null;
      _descriptionError = null;
      _componentsError = null;
    });

    try {
      final isDuplicate = await _categoryRepository.existsByName(
        name,
        excludeId: widget.category?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _categoryRepository.updateTaxCategory(
          widget.category!.id,
          name: name,
          description: description,
          components: componentsList,
        );
      } else {
        await _categoryRepository.createTaxCategory(
          name: name,
          description: description,
          components: componentsList,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Tax category updated successfully.'
                  : 'Tax category created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on TaxCategoryAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save tax category. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save tax category. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _nameError = 'A tax category with this name already exists.';
    });
  }

  void _showFailure(String message) {
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Returns set of selected taxTypeIds excluding the current row's selection.
  Set<int> _getSelectedTaxTypeIdsExcluding(int rowIndex) {
    final set = <int>{};
    for (int i = 0; i < _componentRows.length; i++) {
      if (i != rowIndex && _componentRows[i].taxTypeId != null) {
        set.add(_componentRows[i].taxTypeId!);
      }
    }
    return set;
  }

  Widget _buildComponentRow(int index, _ComponentRowState row) {
    final colorScheme = Theme.of(context).colorScheme;
    final excludedIds = _getSelectedTaxTypeIdsExcluding(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tax Type Dropdown
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<int>(
              initialValue: row.taxTypeId,
              decoration: InputDecoration(
                labelText: 'Tax Type',
                hintText: 'Select Tax Type',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: _availableTaxTypes.map((taxType) {
                final isSelectedElsewhere = excludedIds.contains(taxType.id);
                return DropdownMenuItem<int>(
                  value: taxType.id,
                  enabled: !isSelectedElsewhere,
                  child: Text(
                    taxType.taxTypeName,
                    style: TextStyle(
                      color: isSelectedElsewhere
                          ? colorScheme.onSurface.withValues(alpha: 0.38)
                          : colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  row.taxTypeId = val;
                  _componentsError = null;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          // Percentage Field
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: row.percentageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Percentage %',
                hintText: 'e.g. 9',
                suffixText: '%',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (_) => setState(() => _componentsError = null),
            ),
          ),
          const SizedBox(width: 8),
          // Delete row button
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: IconButton(
              icon: Icon(
                Icons.remove_circle_outline_rounded,
                color: _componentRows.length > 1
                    ? AppTheme.danger
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                size: 22,
              ),
              tooltip: 'Remove Component',
              onPressed: () => _removeComponentRow(index),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = _isEditing ? 'Edit Tax Category' : 'Create Tax Category';
    final subtitle = _isEditing
        ? 'Update the tax category details and rate breakdown.'
        : 'Configure a reusable tax category template for ERP products.';

    final totalTaxStr = _calculatedTotalTax.toStringAsFixed(
      _calculatedTotalTax.truncateToDouble() == _calculatedTotalTax ? 0 : 2,
    );

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(items: ['Master Entry', 'Tax Category', title]),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ContentPanel(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LabelledField(
                        label: 'Tax Category Name',
                        isRequired: true,
                        hintText: 'e.g. GST 18%, IGST 18%, Tax Free',
                        controller: _nameController,
                        errorText: _nameError,
                      ),
                      const SizedBox(height: 20),
                      LabelledField(
                        label: 'Description',
                        hintText: 'Optional description',
                        maxLines: 3,
                        controller: _descriptionController,
                        errorText: _descriptionError,
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax Components *',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Total Tax: $totalTaxStr%',
                              style: textTheme.labelLarge?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_loadingTaxTypes)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        for (int i = 0; i < _componentRows.length; i++)
                          _buildComponentRow(i, _componentRows[i]),
                        if (_componentsError != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _componentsError!,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppTheme.danger,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: _addComponentRow,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Component'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _saving ? null : widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
