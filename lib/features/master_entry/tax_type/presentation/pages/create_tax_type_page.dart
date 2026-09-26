import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/tax_type_repository.dart';
import '../../domain/entities/tax_type.dart';
import '../../domain/exceptions/tax_type_exceptions.dart';
import '../../services/tax_type_validator.dart';

/// "Create / Edit Tax Type" form page.
///
/// With [taxType] `null` the page creates a new tax type; otherwise it edits
/// the given tax type (the form is pre-filled). Validation, duplicate
/// checks and saves run through [TaxTypeRepository] — no Drift access here.
class CreateTaxTypePage extends StatefulWidget {
  const CreateTaxTypePage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.taxType,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided the page edits this tax type instead of creating one.
  final TaxType? taxType;

  @override
  State<CreateTaxTypePage> createState() => _CreateTaxTypePageState();
}

class _CreateTaxTypePageState extends State<CreateTaxTypePage> {
  late final TaxTypeRepository _repository;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  String? _nameError;
  String? _descriptionError;
  bool _saving = false;

  bool get _isEditing => widget.taxType != null;

  @override
  void initState() {
    super.initState();
    _repository = TaxTypeRepository();
    final taxType = widget.taxType;
    _nameController = TextEditingController(text: taxType?.taxTypeName);
    _descriptionController = TextEditingController(text: taxType?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final nameError = TaxTypeValidator.validateName(name);
    final descriptionError = TaxTypeValidator.validateDescription(description);
    if (nameError != null || descriptionError != null) {
      setState(() {
        _nameError = nameError;
        _descriptionError = descriptionError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _nameError = null;
      _descriptionError = null;
    });

    try {
      final isDuplicate = await _repository.existsByName(
        name,
        excludeId: widget.taxType?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateTaxType(
          widget.taxType!.id,
          name: name,
          description: description,
        );
      } else {
        await _repository.createTaxType(name: name, description: description);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Tax type updated successfully.'
                  : 'Tax type created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on TaxTypeAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save tax type. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save tax type. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _nameError = 'A tax type with this name already exists.';
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
    final title = _isEditing ? 'Edit Tax Type' : 'Create Tax Type';
    final subtitle = _isEditing
        ? 'Update the details of this tax component.'
        : 'Add a new tax component to the ERP (e.g. GST, CGST, SGST, IGST, CESS).';

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(items: ['Master Entry', 'Tax Type', title]),
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
                        label: 'Tax Type Name',
                        isRequired: true,
                        hintText: 'e.g. GST, CGST, SGST, IGST, CESS',
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
