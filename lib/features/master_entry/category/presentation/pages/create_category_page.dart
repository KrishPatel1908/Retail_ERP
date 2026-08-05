import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../../../../shared/widgets/switch_field.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/exceptions/category_exceptions.dart';
import '../../services/category_validator.dart';

/// "Create / Edit Category" form page.
///
/// With [category] `null` the page creates a new category; otherwise it edits
/// the given category (the form is pre-filled). Validation, duplicate
/// checks and saves run through [CategoryRepository] — no Drift access here.
class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.category,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided the page edits this category instead of creating one.
  final Category? category;

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  late final CategoryRepository _repository;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _active;

  String? _nameError;
  String? _descriptionError;
  bool _saving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _repository = CategoryRepository();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.categoryName);
    _descriptionController = TextEditingController(text: category?.description);
    _active = category?.isActive ?? true;
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

    final nameError = CategoryValidator.validateName(name);
    final descriptionError = CategoryValidator.validateDescription(description);
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
        excludeId: widget.category?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateCategory(
          widget.category!.id,
          name: name,
          description: description,
          isActive: _active,
        );
      } else {
        await _repository.createCategory(
          name: name,
          description: description,
          isActive: _active,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Category updated successfully.'
                  : 'Category created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on CategoryAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save category. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save category. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _nameError = 'A category with this name already exists.';
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
    final title = _isEditing ? 'Edit Category' : 'Create Category';
    final subtitle = _isEditing
        ? 'Update the details of this category.'
        : 'Add a new category to organise your products.';

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
                Breadcrumbs(items: ['Master Entry', 'Category', title]),
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
                        label: 'Category Name',
                        isRequired: true,
                        hintText: 'e.g. Electronics',
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
                      const SizedBox(height: 20),
                      SwitchField(
                        title: 'Active',
                        description: 'New categories are enabled by default.',
                        value: _active,
                        onChanged: (value) => setState(() => _active = value),
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
