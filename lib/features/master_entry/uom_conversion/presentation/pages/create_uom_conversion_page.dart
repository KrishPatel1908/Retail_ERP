import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../../../master_entry/unit/data/repositories/unit_repository.dart';
import '../../../../master_entry/unit/domain/entities/unit.dart';
import '../../../../master_entry/unit/presentation/widgets/create_unit_dialog.dart';
import '../../data/repositories/uom_conversion_repository.dart';
import '../../domain/entities/uom_conversion.dart';
import '../../domain/exceptions/uom_conversion_exceptions.dart';
import '../../services/uom_conversion_validator.dart';
import '../widgets/unit_picker_field.dart';

/// "Create / Edit Conversion" form page.
///
/// With [conversion] `null` the page creates a new global conversion;
/// otherwise it edits the given one. From / To units are picked through
/// searchable pickers that can also create a new unit on the fly. No Drift
/// access here.
class CreateUomConversionPage extends StatefulWidget {
  const CreateUomConversionPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.conversion,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided the page edits this conversion instead of creating one.
  final UomConversion? conversion;

  @override
  State<CreateUomConversionPage> createState() =>
      _CreateUomConversionPageState();
}

class _CreateUomConversionPageState extends State<CreateUomConversionPage> {
  late final UomConversionRepository _repository;
  late final UnitRepository _unitRepository;
  late final TextEditingController _factorController;
  late final TextEditingController _descriptionController;

  List<Unit> _units = const [];
  int? _fromUnitId;
  int? _toUnitId;

  String? _fromError;
  String? _toError;
  String? _factorError;
  String? _descriptionError;
  String? _duplicateError;
  bool _saving = false;

  bool get _isEditing => widget.conversion != null;

  @override
  void initState() {
    super.initState();
    _repository = UomConversionRepository();
    _unitRepository = UnitRepository();
    final conversion = widget.conversion;
    _fromUnitId = conversion?.fromUnitId;
    _toUnitId = conversion?.toUnitId;
    _factorController = TextEditingController(
      text: conversion == null ? '' : conversion.factorText,
    );
    _descriptionController = TextEditingController(
      text: conversion?.description,
    );
    _loadUnits();
  }

  @override
  void dispose() {
    _factorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUnits() async {
    try {
      final units = await _unitRepository.getAllUnits();
      if (!mounted) return;
      setState(() => _units = units);
    } catch (_) {
      if (!mounted) return;
      setState(() => _units = const []);
    }
  }

  /// Creates a unit through the shared dialog, refreshes the available
  /// units and returns the new unit's id so the picker can select it.
  Future<int?> _addNewUnit() async {
    final unit = await showCreateUnitDialog(context);
    if (unit == null) return null;
    await _loadUnits();
    return unit.id;
  }

  void _onFromChanged(int? id) {
    setState(() {
      _fromUnitId = id;
      _fromError = null;
      _duplicateError = null;
    });
  }

  void _onToChanged(int? id) {
    setState(() {
      _toUnitId = id;
      _toError = null;
      _duplicateError = null;
    });
  }

  void _swapUnits() {
    if (_fromUnitId == null && _toUnitId == null) return;
    setState(() {
      final from = _fromUnitId;
      _fromUnitId = _toUnitId;
      _toUnitId = from;
      _fromError = null;
      _toError = null;
      _duplicateError = null;
    });
  }

  Future<void> _save() async {
    final fromError = UomConversionValidator.validateFromUnit(_fromUnitId);
    final toError = UomConversionValidator.validateToUnit(_toUnitId);
    final differentError = UomConversionValidator.validateDifferentUnits(
      _fromUnitId,
      _toUnitId,
    );
    final factorError = UomConversionValidator.validateFactor(
      _factorController.text,
    );
    final descriptionError = UomConversionValidator.validateDescription(
      _descriptionController.text,
    );

    if (fromError != null ||
        toError != null ||
        differentError != null ||
        factorError != null ||
        descriptionError != null) {
      setState(() {
        _fromError = fromError;
        _toError = toError ?? differentError;
        _factorError = factorError;
        _descriptionError = descriptionError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _duplicateError = null;
    });

    try {
      final factor = double.parse(_factorController.text.trim());
      final description = _descriptionController.text.trim();

      final duplicate = await _repository.existsBetween(
        _fromUnitId!,
        _toUnitId!,
        excludeId: widget.conversion?.id,
      );
      if (duplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateConversion(
          widget.conversion!.id,
          fromUnitId: _fromUnitId!,
          toUnitId: _toUnitId!,
          conversionFactor: factor,
          description: description,
        );
      } else {
        await _repository.createConversion(
          fromUnitId: _fromUnitId!,
          toUnitId: _toUnitId!,
          conversionFactor: factor,
          description: description,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Conversion updated successfully.'
                  : 'Conversion created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on UomConversionAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save conversion. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save conversion. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _duplicateError = 'A conversion between these units already exists.';
    });
  }

  void _showFailure(String message) {
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = _isEditing ? 'Edit Conversion' : 'Create Conversion';
    final subtitle = _isEditing
        ? 'Update this universal unit conversion.'
        : 'Define a universal conversion, e.g. 1 Kilogram = 1000 Gram.';

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
                Breadcrumbs(items: ['Master Entry', 'UOM Conversion', title]),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: UnitPickerField(
                              key: const ValueKey('from-unit-picker'),
                              label: 'From Unit',
                              isRequired: true,
                              units: _units,
                              selectedId: _fromUnitId,
                              excludeIds: _toUnitId == null
                                  ? const {}
                                  : {_toUnitId!},
                              onChanged: _onFromChanged,
                              onAddNewUnit: _addNewUnit,
                              errorText: _fromError,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              left: 4,
                              right: 4,
                            ),
                            child: IconButton(
                              tooltip: 'Swap units',
                              onPressed: _saving ? null : _swapUnits,
                              icon: const Icon(
                                Icons.swap_horiz_rounded,
                                size: 22,
                              ),
                            ),
                          ),
                          Expanded(
                            child: UnitPickerField(
                              key: const ValueKey('to-unit-picker'),
                              label: 'To Unit',
                              isRequired: true,
                              units: _units,
                              selectedId: _toUnitId,
                              excludeIds: _fromUnitId == null
                                  ? const {}
                                  : {_fromUnitId!},
                              onChanged: _onToChanged,
                              onAddNewUnit: _addNewUnit,
                              errorText: _toError,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _saving
                              ? null
                              : () async {
                                  final newUnitId = await _addNewUnit();
                                  if (newUnitId != null) {
                                    if (_fromUnitId == null) {
                                      _onFromChanged(newUnitId);
                                    } else if (_toUnitId == null) {
                                      _onToChanged(newUnitId);
                                    }
                                  }
                                },
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('+ Add New Unit'),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(0, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LabelledField(
                        label: 'Conversion Factor',
                        isRequired: true,
                        hintText: 'e.g. 1000',
                        controller: _factorController,
                        errorText: _factorError,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1 To Unit = Factor × From Unit. The reverse '
                        'direction is automatic (divide by the factor).',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LabelledField(
                        label: 'Description',
                        hintText: 'Optional description',
                        maxLines: 3,
                        controller: _descriptionController,
                        errorText: _descriptionError,
                      ),
                      if (_duplicateError != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 18,
                                color: colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _duplicateError!,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check_rounded, size: 18),
                            label: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
