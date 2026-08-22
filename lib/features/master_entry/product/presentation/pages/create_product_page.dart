import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/utils/form_focus_controller.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/exceptions/product_exceptions.dart';
import '../../services/product_validator.dart';
import '../../../party/presentation/widgets/party_form_sections.dart';

/// Data model for a variant row in the creation/edit form.
class _VariantRow {
  _VariantRow({
    required this.nameController,
    required this.priceController,
    this.expiryDate,
    required this.notesController,
  });

  final TextEditingController nameController;
  final TextEditingController priceController;
  DateTime? expiryDate;
  final TextEditingController notesController;

  /// Focus nodes for this variant row.
  late final FocusNode nameFocusNode;
  late final FocusNode priceFocusNode;
  late final FocusNode expiryFocusNode;
  late final FocusNode notesFocusNode;
  late final GlobalKey nameContainerKey;
  late final GlobalKey priceContainerKey;
  late final GlobalKey expiryContainerKey;
  late final GlobalKey notesContainerKey;

  bool _focusInitialized = false;

  void initFocusNodes(int variantIndex) {
    if (_focusInitialized) return;
    _focusInitialized = true;
    nameFocusNode = FocusNode(debugLabel: 'variant-$variantIndex-name');
    priceFocusNode = FocusNode(debugLabel: 'variant-$variantIndex-price');
    expiryFocusNode = FocusNode(debugLabel: 'variant-$variantIndex-expiry');
    notesFocusNode = FocusNode(debugLabel: 'variant-$variantIndex-notes');
    nameContainerKey = GlobalKey();
    priceContainerKey = GlobalKey();
    expiryContainerKey = GlobalKey();
    notesContainerKey = GlobalKey();
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    notesController.dispose();
    if (_focusInitialized) {
      nameFocusNode.dispose();
      priceFocusNode.dispose();
      expiryFocusNode.dispose();
      notesFocusNode.dispose();
    }
  }
}

/// "Create / Edit Product" form page with inline variant management.
class CreateProductPage extends StatefulWidget {
  const CreateProductPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.product,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final ProductEntity? product;

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late final ProductRepository _repository;
  late final FormFocusController _focusController;

  // The field order determines exact Tab key traversal.
  // Variants are inserted dynamically after "notes".
  static const _baseFieldOrder = [
    'name',
    'code',
    'category',
    'subCategory',
    'brand',
    'unit',
    'sellingPrice',
    'tax',
    'expiryDate',
    'notes',
    'addVariant',
    'cancel',
    'save',
  ];

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _notesController;

  // Dropdown state
  int? _categoryId;
  int? _subCategoryId;
  int? _brandId;
  int? _unitId;
  int? _taxTypeId;

  // Expiry date
  DateTime? _expiryDate;

  // Variant rows
  List<_VariantRow> _variantRows = [];

  // Dropdown data
  List<db.Category> _categories = const [];
  List<db.SubCategory> _subCategories = const [];
  List<db.Brand> _brands = const [];
  List<db.Unit> _units = const [];
  List<db.TaxType> _taxTypes = const [];

  Map<String, String?> _errors = const {};
  bool _saving = false;

  bool get _isEditing => widget.product != null;
  bool get _hasVariants => _variantRows.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _repository = ProductRepository();
    _focusController = FormFocusController(_baseFieldOrder);

    final product = widget.product;
    _nameController = TextEditingController(text: product?.productName);
    _codeController = TextEditingController(text: product?.productCode);
    _sellingPriceController = TextEditingController(
      text: product == null || product.sellingPrice == 0
          ? ''
          : ProductValidator.formatPaise(product.sellingPrice),
    );
    _notesController = TextEditingController(text: product?.notes);

    _categoryId = product?.categoryId;
    _subCategoryId = product?.subCategoryId;
    _brandId = product?.brandId;
    _unitId = product?.unitId;
    _taxTypeId = product?.taxTypeId;
    _expiryDate = product?.expiryDate;

    // Initialize variant rows from existing product variants.
    if (product != null && product.variants.isNotEmpty) {
      _variantRows = product.variants.map((v) {
        return _VariantRow(
          nameController: TextEditingController(text: v.variantName),
          priceController: TextEditingController(
            text: v.sellingPrice == 0
                ? ''
                : ProductValidator.formatPaise(v.sellingPrice),
          ),
          expiryDate: v.expiryDate,
          notesController: TextEditingController(text: v.notes ?? ''),
        );
      }).toList();
      for (var i = 0; i < _variantRows.length; i++) {
        _variantRows[i].initFocusNodes(i);
      }
    }

    _loadDropdowns();
  }



  @override
  void dispose() {
    _focusController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _sellingPriceController.dispose();
    _notesController.dispose();
    for (final row in _variantRows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _loadDropdowns() async {
    final database = DatabaseProvider.instance.database;
    try {
      final categories = await (database.select(database.categories)
            ..orderBy([(t) => OrderingTerm.asc(t.categoryName.lower())]))
          .get();
      final brands = await (database.select(database.brands)
            ..orderBy([(t) => OrderingTerm.asc(t.brandName.lower())]))
          .get();
      final units = await (database.select(database.units)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.unitName.lower())]))
          .get();
      final taxTypes = await (database.select(database.taxTypes)
            ..orderBy([(t) => OrderingTerm.asc(t.taxTypeName.lower())]))
          .get();

      List<db.SubCategory> subCategories = const [];
      if (_categoryId != null) {
        subCategories = await (database.select(database.subCategories)
              ..where((t) => t.categoryId.equals(_categoryId!))
              ..orderBy([
                (t) => OrderingTerm.asc(t.subCategoryName.lower()),
              ]))
            .get();
      } else {
        subCategories = await (database.select(database.subCategories)
              ..orderBy([
                (t) => OrderingTerm.asc(t.subCategoryName.lower()),
              ]))
            .get();
      }

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _brands = brands;
        _units = units;
        _taxTypes = taxTypes;
        _subCategories = subCategories;
      });
    } catch (_) {
      // Dropdowns stay empty; form still usable.
    }
  }

  Future<void> _onCategoryChanged(int? categoryId) async {
    setState(() {
      _categoryId = categoryId;
      _subCategoryId = null;
    });

    final database = DatabaseProvider.instance.database;
    try {
      final query = database.select(database.subCategories)
        ..orderBy([
          (t) => OrderingTerm.asc(t.subCategoryName.lower()),
        ]);
      if (categoryId != null) {
        query.where((t) => t.categoryId.equals(categoryId));
      }
      final subCategories = await query.get();
      if (!mounted) return;
      setState(() => _subCategories = subCategories);
    } catch (_) {}
  }

  void _addVariant() {
    final row = _VariantRow(
      nameController: TextEditingController(),
      priceController: TextEditingController(),
      notesController: TextEditingController(),
    );
    row.initFocusNodes(_variantRows.length);
    setState(() {
      _variantRows.add(row);
    });

    // Focus the new variant's name field after the frame renders.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_variantRows.isNotEmpty && mounted) {
        _variantRows.last.nameFocusNode.requestFocus();
      }
    });
  }

  void _removeVariant(int index) {
    setState(() {
      final removed = _variantRows.removeAt(index);
      removed.dispose();
    });
  }

  void _focusFirstError(Map<String, String?> errors) {
    // 1. Check base fields first in canonical order.
    for (final field in _baseFieldOrder) {
      if (errors[field] != null) {
        _focusController.focusFirstError(errors);
        return;
      }
    }
    // 2. Check variant errors in row order.
    for (var i = 0; i < _variantRows.length; i++) {
      final row = _variantRows[i];
      if (errors['variant_${i}_name'] != null) {
        row.nameFocusNode.requestFocus();
        _scrollToContext(row.nameContainerKey.currentContext);
        return;
      }
      if (errors['variant_${i}_price'] != null) {
        row.priceFocusNode.requestFocus();
        _scrollToContext(row.priceContainerKey.currentContext);
        return;
      }
      if (errors['variant_${i}_notes'] != null) {
        row.notesFocusNode.requestFocus();
        _scrollToContext(row.notesContainerKey.currentContext);
        return;
      }
    }
  }

  void _scrollToContext(BuildContext? context) {
    if (context != null && context.mounted) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.2,
      );
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final sellingPriceText = _sellingPriceController.text.trim();
    final notes = _notesController.text.trim();

    // Collect variant data.
    final variantInputs = <VariantInput>[];
    final variantErrors = <String, String?>{};

    for (var i = 0; i < _variantRows.length; i++) {
      final row = _variantRows[i];
      final vName = row.nameController.text.trim();
      final vPrice = row.priceController.text.trim();
      final vNotes = row.notesController.text.trim();

      final nameErr = ProductValidator.validateVariantName(vName);
      final priceErr = ProductValidator.validateVariantSellingPrice(vPrice);

      if (nameErr != null) variantErrors['variant_${i}_name'] = nameErr;
      if (priceErr != null) variantErrors['variant_${i}_price'] = priceErr;

      if (nameErr == null && priceErr == null) {
        variantInputs.add(VariantInput(
          variantName: vName,
          sellingPrice: ProductValidator.parseRupeesToPaise(vPrice) ?? 0,
          expiryDate: row.expiryDate,
          notes: vNotes.isEmpty ? null : vNotes,
        ));
      }
    }

    // Check for duplicate variant names.
    final duplicateCheck = ProductValidator.validateVariantNamesUnique(
      _variantRows.map((r) => r.nameController.text).toList(),
    );

    final errors = <String, String?>{
      'name': ProductValidator.validateName(name),
      'code': ProductValidator.validateProductCode(code),
      'unit': _unitId == null ? 'Unit is required.' : null,
      'sellingPrice': ProductValidator.validateParentSellingPrice(
        sellingPriceText,
        hasVariants: _hasVariants,
      ),
      'notes': ProductValidator.validateNotes(notes),
      'variantDuplicate': ?duplicateCheck,
      ...variantErrors,
    };

    final hasErrors = errors.values.any((error) => error != null);
    if (hasErrors) {
      setState(() => _errors = errors);
      _focusFirstError(errors);
      return;
    }

    setState(() {
      _saving = true;
      _errors = const {};
    });

    final sellingPrice =
        ProductValidator.parseRupeesToPaise(sellingPriceText) ?? 0;

    try {
      if (_isEditing) {
        await _repository.updateProduct(
          widget.product!.id,
          productName: name,
          categoryId: _categoryId,
          subCategoryId: _subCategoryId,
          brandId: _brandId,
          unitId: _unitId!,
          sellingPrice: sellingPrice,
          taxTypeId: _taxTypeId,
          expiryDate: _expiryDate,
          notes: notes,
        );

        // Sync variants: add new, update existing, remove deleted.
        await _syncVariants();
      } else {
        await _repository.createProduct(
          productName: name,
          productCode: code.isNotEmpty ? code : null,
          categoryId: _categoryId,
          subCategoryId: _subCategoryId,
          brandId: _brandId,
          unitId: _unitId!,
          sellingPrice: sellingPrice,
          taxTypeId: _taxTypeId,
          expiryDate: _expiryDate,
          notes: notes,
          variants: variantInputs,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Product updated successfully.'
                  : 'Product created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on ProductDuplicateException catch (exception) {
      if (!mounted) return;
      final duplicateErrors = {
        ..._errors,
        exception.field.formField: exception.message,
      };
      setState(() {
        _saving = false;
        _errors = duplicateErrors;
      });
      _focusController.focusFirstError(duplicateErrors);
    } on ProductNotFoundException {
      if (!mounted) return;
      _showFailure('This product no longer exists. Please try again.');
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save product. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save product. Please try again.');
    }
  }

  /// Syncs variants when editing: adds new ones, updates existing, removes deleted.
  Future<void> _syncVariants() async {
    final product = widget.product!;
    final existingIds = product.variants.map((v) => v.id).toSet();
    final currentIds = <int>{};

    for (final row in _variantRows) {
      final vName = row.nameController.text.trim();
      final vPrice =
          ProductValidator.parseRupeesToPaise(row.priceController.text.trim()) ??
              0;
      final vNotes = row.notesController.text.trim();

      // Check if this variant has an existing ID (stored via a hidden field approach).
      // Since we don't store variant IDs in the form, we match by name.
      final existing = product.variants.where(
        (v) => v.variantName.toLowerCase() == vName.toLowerCase(),
      );

      if (existing.isNotEmpty) {
        // Update existing variant.
        currentIds.add(existing.first.id);
        if (existing.first.sellingPrice != vPrice ||
            existing.first.expiryDate != row.expiryDate ||
            (existing.first.notes ?? '') != vNotes) {
          await _repository.updateVariant(
            existing.first.id,
            variantName: vName,
            sellingPrice: vPrice,
            expiryDate: row.expiryDate,
            notes: vNotes.isEmpty ? null : vNotes,
          );
        }
      } else {
        // Create new variant.
        final newVariant = await _repository.createVariant(
          product.id,
          variantName: vName,
          sellingPrice: vPrice,
          expiryDate: row.expiryDate,
          notes: vNotes.isEmpty ? null : vNotes,
        );
        currentIds.add(newVariant.id);
      }
    }

    // Delete variants that were removed from the form.
    for (final existingId in existingIds) {
      if (!currentIds.contains(existingId)) {
        await _repository.deleteVariant(existingId);
      }
    }
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
    final title = _isEditing ? 'Edit Product' : 'Create Product';
    final subtitle = _isEditing
        ? 'Update the details of this product.'
        : 'Add a new product to your catalog.';

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumbs(
                    items: ['Master Entry', 'Product Master', title],
                  ),
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
                        // ── Section 1: Product Information ──
                        const PartySectionTitle(title: 'Product Information'),
                        const SizedBox(height: 16),
                        LabelledField(
                          label: 'Product Name',
                          isRequired: true,
                          hintText: 'e.g. Parle-G Biscuits',
                          controller: _nameController,
                          errorText: _errors['name'],
                          focusNode: _focusController.node('name'),
                          containerKey: _focusController.key('name'),
                          fieldKey: const ValueKey('product-name'),
                        ),
                        const SizedBox(height: 20),
                        LabelledField(
                          label: 'Product Code',
                          hintText: 'Auto-generated if left blank',
                          controller: _codeController,
                          errorText: _errors['code'],
                          focusNode: _focusController.node('code'),
                          containerKey: _focusController.key('code'),
                          fieldKey: const ValueKey('product-code'),
                          enabled: !_isEditing,
                        ),
                        const SizedBox(height: 20),
                        _buildFormRow([
                          LabelledDropdown<int>(
                            label: 'Category',
                            keyValue: 'product-category',
                            value: _categoryId,
                            hintText: 'Select category',
                            focusNode: _focusController.node('category'),
                            containerKey: _focusController.key('category'),
                            items: [
                              for (final c in _categories)
                                DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.categoryName),
                                ),
                            ],
                            onChanged: (value) => _onCategoryChanged(value),
                          ),
                          LabelledDropdown<int>(
                            label: 'Sub Category',
                            keyValue: 'product-sub-category',
                            value: _subCategoryId,
                            hintText: 'Select sub category',
                            focusNode: _focusController.node('subCategory'),
                            containerKey: _focusController.key('subCategory'),
                            items: [
                              for (final s in _subCategories)
                                DropdownMenuItem(
                                  value: s.id,
                                  child: Text(s.subCategoryName),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _subCategoryId = value),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _buildFormRow([
                          LabelledDropdown<int>(
                            label: 'Brand',
                            keyValue: 'product-brand',
                            value: _brandId,
                            hintText: 'Select brand',
                            focusNode: _focusController.node('brand'),
                            containerKey: _focusController.key('brand'),
                            items: [
                              for (final b in _brands)
                                DropdownMenuItem(
                                  value: b.id,
                                  child: Text(b.brandName),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _brandId = value),
                          ),
                          LabelledDropdown<int>(
                            label: 'Unit',
                            isRequired: true,
                            keyValue: 'product-unit',
                            value: _unitId,
                            hintText: 'Select unit',
                            errorText: _errors['unit'],
                            focusNode: _focusController.node('unit'),
                            containerKey: _focusController.key('unit'),
                            items: [
                              for (final u in _units)
                                DropdownMenuItem(
                                  value: u.id,
                                  child: Text(
                                    '${u.unitName} (${u.unitSymbol})',
                                  ),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _unitId = value),
                          ),
                        ]),
                        const SizedBox(height: 28),

                        // ── Section 2: Selling Information ──
                        const PartySectionTitle(title: 'Selling Information'),
                        const SizedBox(height: 16),
                        _buildFormRow([
                          LabelledField(
                            label: 'Selling Price',
                            isRequired: true,
                            hintText: 'e.g. 50',
                            controller: _sellingPriceController,
                            errorText: _errors['sellingPrice'],
                            focusNode: _focusController.node('sellingPrice'),
                            containerKey: _focusController.key('sellingPrice'),
                            fieldKey: const ValueKey('product-selling-price'),
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                          ),
                          LabelledDropdown<int>(
                            label: 'Tax',
                            keyValue: 'product-tax',
                            value: _taxTypeId,
                            hintText: 'Select tax',
                            focusNode: _focusController.node('tax'),
                            containerKey: _focusController.key('tax'),
                            items: [
                              for (final t in _taxTypes)
                                DropdownMenuItem(
                                  value: t.id,
                                  child: Text(t.taxTypeName),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _taxTypeId = value),
                          ),
                        ]),
                        const SizedBox(height: 28),

                        // ── Section 3: Additional Information ──
                        const PartySectionTitle(
                          title: 'Additional Information',
                        ),
                        const SizedBox(height: 16),
                        _buildExpiryDateField(),
                        const SizedBox(height: 20),
                        LabelledField(
                          label: 'Notes',
                          hintText: 'Optional notes',
                          maxLines: 3,
                          controller: _notesController,
                          errorText: _errors['notes'],
                          focusNode: _focusController.node('notes'),
                          containerKey: _focusController.key('notes'),
                          fieldKey: const ValueKey('product-notes'),
                        ),

                        // ── Section 4: Variants ──
                        if (_variantRows.isNotEmpty || !_isEditing) ...[
                          const SizedBox(height: 28),
                          const PartySectionTitle(title: 'Variants'),
                          const SizedBox(height: 4),
                          Text(
                            'Add optional product variants (e.g. different sizes or prices).',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Variant rows
                          for (var i = 0; i < _variantRows.length; i++)
                            _buildVariantRow(i),

                          // Add Variant button
                          _buildAddVariantButton(),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Action Buttons ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FormFocusController.applyOrder(
                        _focusController.node('cancel'),
                        OutlinedButton(
                          focusNode: _focusController.node('cancel'),
                          onPressed: _saving ? null : widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FormFocusController.applyOrder(
                        _focusController.node('save'),
                        FilledButton.icon(
                          focusNode: _focusController.node('save'),
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.check_rounded, size: 18),
                          label: Text(
                            _isEditing ? 'Save Changes' : 'Save Product',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpiryDateField() {
    final formatted = _expiryDate == null
        ? ''
        : '${_expiryDate!.day.toString().padLeft(2, '0')}/${_expiryDate!.month.toString().padLeft(2, '0')}/${_expiryDate!.year}';

    return FormFocusController.applyOrder(
      _focusController.node('expiryDate'),
      Column(
        key: _focusController.key('expiryDate'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiry Date',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            focusNode: _focusController.node('expiryDate'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _expiryDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                helpText: 'Select expiry date',
              );
              if (picked != null) {
                setState(() => _expiryDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Optional — e.g. 15/12/2027',
                suffixIcon: _expiryDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          setState(() => _expiryDate = null);
                        },
                        tooltip: 'Clear date',
                      )
                    : const Icon(Icons.calendar_today_rounded, size: 18),
              ),
              child: Text(
                formatted.isEmpty ? 'Optional — e.g. 15/12/2027' : formatted,
                style: TextStyle(
                  fontSize: 14,
                  color: formatted.isEmpty
                      ? Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantRow(int index) {
    final row = _variantRows[index];
    row.initFocusNodes(index);
    final variantNameKey = 'variant_${index}_name';
    final variantPriceKey = 'variant_${index}_price';
    final variantNotesKey = 'variant_${index}_notes';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Variant ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: 'Remove variant',
                onPressed: () => _removeVariant(index),
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LabelledField(
            label: 'Variant Name',
            isRequired: true,
            hintText: 'e.g. Parle-G 5',
            controller: row.nameController,
            errorText: _errors[variantNameKey],
            focusNode: row.nameFocusNode,
            containerKey: row.nameContainerKey,
            fieldKey: ValueKey('variant-$index-name'),
          ),
          const SizedBox(height: 16),
          _buildFormRow([
            LabelledField(
              label: 'Selling Price',
              isRequired: true,
              hintText: 'e.g. 5',
              controller: row.priceController,
              errorText: _errors[variantPriceKey],
              focusNode: row.priceFocusNode,
              containerKey: row.priceContainerKey,
              fieldKey: ValueKey('variant-$index-price'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'),
                ),
              ],
            ),
            _buildVariantExpiryField(index, row),
          ]),
          const SizedBox(height: 16),
          LabelledField(
            label: 'Notes',
            hintText: 'Optional notes',
            controller: row.notesController,
            errorText: _errors[variantNotesKey],
            focusNode: row.notesFocusNode,
            containerKey: row.notesContainerKey,
            fieldKey: ValueKey('variant-$index-notes'),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantExpiryField(int index, _VariantRow row) {
    final formatted = row.expiryDate == null
        ? ''
        : '${row.expiryDate!.day.toString().padLeft(2, '0')}/${row.expiryDate!.month.toString().padLeft(2, '0')}/${row.expiryDate!.year}';

    return FormFocusController.applyOrder(
      row.expiryFocusNode,
      Column(
        key: row.expiryContainerKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiry Date',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            focusNode: row.expiryFocusNode,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: row.expiryDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                helpText: 'Select variant expiry date',
              );
              if (picked != null) {
                setState(() => row.expiryDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Optional',
                suffixIcon: row.expiryDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          setState(() => row.expiryDate = null);
                        },
                        tooltip: 'Clear date',
                      )
                    : const Icon(Icons.calendar_today_rounded, size: 18),
              ),
              child: Text(
                formatted.isEmpty ? 'Optional' : formatted,
                style: TextStyle(
                  fontSize: 14,
                  color: formatted.isEmpty
                      ? Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVariantButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton.icon(
        key: const ValueKey('add-variant-button'),
        onPressed: _addVariant,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Add Variant'),
      ),
    );
  }

  Widget _buildFormRow(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i < children.length - 1) const SizedBox(width: 20),
            ],
          ],
        );
      },
    );
  }
}
