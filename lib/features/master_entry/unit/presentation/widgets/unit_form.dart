import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/unit_repository.dart';
import '../../domain/entities/unit.dart';
import '../../domain/exceptions/unit_exceptions.dart';
import '../../services/unit_validator.dart';

/// The Unit create / edit form body.
///
/// Owns the field controllers, inline validation and the save flow. Used by
/// both the full "Create / Edit Unit" page and the compact "Add New Unit"
/// dialog (e.g. from the UOM Conversion form), so unit creation behaves
/// identically everywhere. With [unit] `null` the form creates a new unit;
/// otherwise it edits the given unit. No Drift access here.
class UnitForm extends StatefulWidget {
  const UnitForm({
    super.key,
    required this.onSaved,
    required this.onCancel,
    this.unit,
  });

  /// Invoked with the persisted unit after a successful save.
  final ValueChanged<Unit> onSaved;

  /// Invoked to leave the form without saving.
  final VoidCallback onCancel;

  /// When provided the form edits this unit instead of creating one.
  final Unit? unit;

  @override
  State<UnitForm> createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {
  late final UnitRepository _repository;
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _descriptionController;
  late String _family;

  String? _nameError;
  String? _symbolError;
  String? _descriptionError;
  bool _saving = false;

  bool get _isEditing => widget.unit != null;

  @override
  void initState() {
    super.initState();
    _repository = UnitRepository();
    final unit = widget.unit;
    _nameController = TextEditingController(text: unit?.unitName);
    _symbolController = TextEditingController(text: unit?.unitSymbol);
    _descriptionController = TextEditingController(text: unit?.description);
    _family = unit?.unitFamily ?? UnitType.count.dbValue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final symbol = _symbolController.text.trim();
    final description = _descriptionController.text.trim();

    final nameError = UnitValidator.validateName(name);
    final symbolError = UnitValidator.validateSymbol(symbol);
    final descriptionError = UnitValidator.validateDescription(description);
    if (nameError != null ||
        symbolError != null ||
        descriptionError != null) {
      setState(() {
        _nameError = nameError;
        _symbolError = symbolError;
        _descriptionError = descriptionError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _nameError = null;
      _symbolError = null;
      _descriptionError = null;
    });

    try {
      final isDuplicate = await _repository.existsByName(
        name,
        excludeId: widget.unit?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      final Unit saved;
      if (_isEditing) {
        saved = await _repository.updateUnit(
          widget.unit!.id,
          name: name,
          symbol: symbol,
          family: _family,
          description: description,
        );
      } else {
        saved = await _repository.createUnit(
          name: name,
          symbol: symbol,
          family: _family,
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
                  ? 'Unit updated successfully.'
                  : 'Unit created successfully.',
            ),
          ),
        );
      widget.onSaved(saved);
    } on UnitAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save unit. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save unit. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _nameError = 'A unit with this name already exists.';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelledField(
          label: 'Unit Name',
          isRequired: true,
          hintText: 'e.g. Kilogram',
          controller: _nameController,
          errorText: _nameError,
        ),
        const SizedBox(height: 20),
        LabelledField(
          label: 'Unit Symbol',
          isRequired: true,
          hintText: 'e.g. kg',
          controller: _symbolController,
          errorText: _symbolError,
        ),
        const SizedBox(height: 20),
        LabelledDropdown<UnitType>(
          label: 'Measure In',
          isRequired: true,
          hintText: 'Select measure',
          keyValue: 'measure-in-dropdown',
          value: UnitType.fromDbValue(_family),
          items: [
            for (final type in UnitType.values)
              DropdownMenuItem(value: type, child: Text(type.label)),
          ],
          onChanged: (type) {
            if (type != null) setState(() => _family = type.dbValue);
          },
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
    );
  }
}
