import 'package:flutter/material.dart';

import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import 'package:retail_erp/features/master_entry/category/data/repositories/category_repository.dart';
import 'package:retail_erp/features/master_entry/category/domain/entities/category.dart';
import 'package:retail_erp/shared/widgets/breadcrumbs.dart';
import 'package:retail_erp/shared/widgets/content_panel.dart';
import 'package:retail_erp/shared/widgets/labelled_field.dart';
import 'package:retail_erp/shared/widgets/switch_field.dart';

import 'package:retail_erp/features/master_entry/sub_category/data/repositories/sub_category_repository.dart';
import 'package:retail_erp/features/master_entry/sub_category/domain/entities/sub_category.dart';
import 'package:retail_erp/features/master_entry/sub_category/domain/exceptions/sub_category_exceptions.dart';
import 'package:retail_erp/features/master_entry/sub_category/services/sub_category_validator.dart';

/// "Create / Edit Sub Category" form page.
///
/// With [subCategory] `null` the page creates a new sub-category; otherwise it
/// edits the given sub-category (the form is pre-filled). Validation,
/// duplicate checks and saves run through [SubCategoryRepository] — no Drift access here.
class CreateSubCategoryPage extends StatefulWidget {
  const CreateSubCategoryPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.subCategory,
  });

  /// Invoked after a successful save; the caller pops this page.
  final VoidCallback onSave;

  /// Invoked to leave the page without saving.
  final VoidCallback onCancel;

  /// When provided the page edits this sub-category instead of creating one.
  final SubCategory? subCategory;

  @override
  State<CreateSubCategoryPage> createState() => _CreateSubCategoryPageState();
}

class _CreateSubCategoryPageState extends State<CreateSubCategoryPage> {
  late final SubCategoryRepository _repository;
  late final CategoryRepository _categoryRepository;

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;

  List<Category> _categories = const [];
  int? _selectedCategoryId;
  late bool _active;

  bool _loadingCategories = true;
  String? _categoryError;
  String? _nameError;
  String? _codeError;
  String? _descriptionError;
  bool _saving = false;

  bool get _isEditing => widget.subCategory != null;

  @override
  void initState() {
    super.initState();
    _repository = SubCategoryRepository();
    _categoryRepository = CategoryRepository();

    final subCategory = widget.subCategory;
    _selectedCategoryId = subCategory?.categoryId;
    _nameController = TextEditingController(text: subCategory?.subCategoryName);
    _codeController = TextEditingController(text: subCategory?.subCategoryCode);
    _descriptionController =
        TextEditingController(text: subCategory?.description);
    _active = subCategory?.isActive ?? true;

    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final allCategories = await _categoryRepository.getAllCategories();
      final validCategories = allCategories.where((c) {
        if (c.isActive) return true;
        return _isEditing && c.id == widget.subCategory?.categoryId;
      }).toList();

      if (!mounted) return;
      setState(() {
        _categories = validCategories;
        _loadingCategories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCategories = false);
    }
  }

  Future<void> _save() async {
    final categoryId = _selectedCategoryId;
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final description = _descriptionController.text.trim();

    final categoryError = SubCategoryValidator.validateCategory(categoryId);
    final nameError = SubCategoryValidator.validateName(name);
    final codeError = SubCategoryValidator.validateCode(code);
    final descriptionError =
        SubCategoryValidator.validateDescription(description);

    if (categoryError != null ||
        nameError != null ||
        codeError != null ||
        descriptionError != null) {
      setState(() {
        _categoryError = categoryError;
        _nameError = nameError;
        _codeError = codeError;
        _descriptionError = descriptionError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _categoryError = null;
      _nameError = null;
      _codeError = null;
      _descriptionError = null;
    });

    try {
      final isDuplicate = await _repository.existsByName(
        name,
        categoryId!,
        excludeId: widget.subCategory?.id,
      );
      if (isDuplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateSubCategory(
          widget.subCategory!.id,
          categoryId: categoryId,
          name: name,
          code: code,
          description: description,
          isActive: _active,
        );
      } else {
        await _repository.createSubCategory(
          categoryId: categoryId,
          name: name,
          code: code,
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
                  ? 'Sub category updated successfully.'
                  : 'Sub category created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on SubCategoryAlreadyExistsException catch (e) {
      _showDuplicateError(e.message);
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save sub category. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save sub category. Please try again.');
    }
  }

  void _showDuplicateError([String? message]) {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _nameError = message ??
          'A sub-category with this name already exists under this category.';
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
    final title = _isEditing ? 'Edit Sub Category' : 'Create Sub Category';
    final subtitle = _isEditing
        ? 'Update the details of this sub-category.'
        : 'Add a new sub-category under a parent category.';

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
                Breadcrumbs(items: ['Master Entry', 'Sub Category', title]),
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
                      // Category Selection Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Category',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '*',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _loadingCategories
                              ? const SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : DropdownButtonFormField<int>(
                                  initialValue: _selectedCategoryId,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select Category',
                                    errorText: _categoryError,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: _categories.map((c) {
                                    return DropdownMenuItem<int>(
                                      value: c.id,
                                      child: Text(c.categoryName),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedCategoryId = val;
                                      _categoryError = null;
                                    });
                                  },
                                ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LabelledField(
                        label: 'Sub Category Name',
                        isRequired: true,
                        hintText: 'e.g. Mobile Phones',
                        controller: _nameController,
                        errorText: _nameError,
                      ),
                      const SizedBox(height: 20),
                      LabelledField(
                        label: 'Code',
                        hintText: 'e.g. SUB-0001 (Auto-generated if empty)',
                        controller: _codeController,
                        errorText: _codeError,
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
                        description:
                            'New sub-categories are enabled by default.',
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
