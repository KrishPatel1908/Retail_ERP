import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/utils/form_focus_controller.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/brand_repository.dart';
import '../../domain/entities/brand.dart';
import '../../domain/exceptions/brand_exceptions.dart';
import '../../services/brand_validator.dart';

/// "Create / Edit Brand" form page.
class CreateBrandPage extends StatefulWidget {
  const CreateBrandPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.brand,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final Brand? brand;

  @override
  State<CreateBrandPage> createState() => _CreateBrandPageState();
}

class _CreateBrandPageState extends State<CreateBrandPage> {
  late final BrandRepository _repository;
  late final FormFocusController _focusController;

  static const _fieldOrder = ['name', 'description'];

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  String? _nameError;
  String? _descriptionError;
  bool _saving = false;

  bool get _isEditing => widget.brand != null;

  @override
  void initState() {
    super.initState();
    _repository = BrandRepository();
    _focusController = FormFocusController();

    final brand = widget.brand;
    _nameController = TextEditingController(text: brand?.brandName);
    _descriptionController = TextEditingController(text: brand?.description);
  }

  @override
  void dispose() {
    _focusController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final nameError = BrandValidator.validateName(name);
    final descriptionError = BrandValidator.validateDescription(description);
    final errors = {'name': nameError, 'description': descriptionError};

    if (nameError != null || descriptionError != null) {
      setState(() {
        _nameError = nameError;
        _descriptionError = descriptionError;
      });
      _focusController.focusFirstError(_fieldOrder, errors);
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
        excludeId: widget.brand?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateBrand(
          widget.brand!.id,
          name: name,
          description: description,
        );
      } else {
        await _repository.createBrand(
          name: name,
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
                  ? 'Brand updated successfully.'
                  : 'Brand created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on BrandAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save brand. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save brand. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    final errors = {'name': 'A brand with this name already exists.'};
    setState(() {
      _saving = false;
      _nameError = 'A brand with this name already exists.';
    });
    _focusController.focusFirstError(_fieldOrder, errors);
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
    final title = _isEditing ? 'Edit Brand' : 'Create Brand';
    final subtitle = _isEditing
        ? 'Update the details of this brand.'
        : 'Add a new product brand to the ERP.';

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
                Breadcrumbs(items: ['Master Entry', 'Brand Master', title]),
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
                  child: FocusTraversalGroup(
                    policy: WidgetOrderTraversalPolicy(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabelledField(
                          label: 'Brand Name',
                          isRequired: true,
                          hintText: 'e.g. Apple, Samsung, Nike',
                          controller: _nameController,
                          errorText: _nameError,
                          focusNode: _focusController.node('name'),
                          containerKey: _focusController.key('name'),
                        ),
                        const SizedBox(height: 20),
                        LabelledField(
                          label: 'Description',
                          hintText: 'Optional description',
                          maxLines: 3,
                          controller: _descriptionController,
                          errorText: _descriptionError,
                          focusNode: _focusController.node('description'),
                          containerKey: _focusController.key('description'),
                        ),
                      ],
                    ),
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
