import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../../../../shared/widgets/switch_field.dart';
import '../../../../master_entry/unit/data/repositories/unit_repository.dart';
import '../../../../master_entry/unit/domain/entities/unit.dart';
import '../../../../master_entry/uom_conversion/presentation/widgets/unit_picker_field.dart';
import '../../data/repositories/product_uom_repository.dart';
import '../../domain/entities/product_lookup_item.dart';
import '../../domain/entities/product_uom_display.dart';
import '../../domain/exceptions/product_uom_exceptions.dart';
import '../../services/product_uom_validator.dart';
import '../widgets/product_picker_field.dart';

/// "Create / Edit Product Conversion" form page.
class CreateProductUomPage extends StatefulWidget {
  const CreateProductUomPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.onNavigateToProducts,
    this.conversion,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onNavigateToProducts;
  final ProductUomDisplay? conversion;

  @override
  State<CreateProductUomPage> createState() => _CreateProductUomPageState();
}

class _CreateProductUomPageState extends State<CreateProductUomPage> {
  late final ProductUomRepository _repository;
  late final UnitRepository _unitRepository;
  late final TextEditingController _factorController;
  late final TextEditingController _descriptionController;

  List<ProductLookupItem> _products = const [];
  List<Unit> _units = const [];
  int? _productId;
  int? _fromUnitId;
  int? _toUnitId;
  late bool _isDefault;

  String? _productError;
  String? _fromError;
  String? _toError;
  String? _factorError;
  String? _descriptionError;
  String? _duplicateError;
  bool _saving = false;
  bool _loadingData = true;

  bool get _isEditing => widget.conversion != null;

  @override
  void initState() {
    super.initState();
    _repository = ProductUomRepository();
    _unitRepository = UnitRepository();

    final conversion = widget.conversion;
    _productId = conversion?.productId;
    _fromUnitId = conversion?.fromUnitId;
    _toUnitId = conversion?.toUnitId;
    _isDefault = conversion?.isDefault ?? false;

    _factorController = TextEditingController(
      text: conversion == null ? '' : conversion.factorText,
    );
    _descriptionController = TextEditingController(
      text: conversion?.description,
    );

    _loadData();
  }

  @override
  void dispose() {
    _factorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final products = await _repository.getAllProducts();
      final units = await _unitRepository.getAllUnits();
      if (!mounted) return;
      setState(() {
        _products = products;
        _units = units;
        _loadingData = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingData = false);
    }
  }

  void _onProductChanged(int? id) {
    setState(() {
      _productId = id;
      _productError = null;
      _duplicateError = null;
    });
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

  Future<void> _save() async {
    final productError = ProductUomValidator.validateProduct(_productId);
    final fromError = ProductUomValidator.validateFromUnit(_fromUnitId);
    final toError = ProductUomValidator.validateToUnit(_toUnitId);
    final differentError = ProductUomValidator.validateDifferentUnits(
      _fromUnitId,
      _toUnitId,
    );
    final factorError = ProductUomValidator.validateFactor(
      _factorController.text,
    );
    final descriptionError = ProductUomValidator.validateDescription(
      _descriptionController.text,
    );

    if (productError != null ||
        fromError != null ||
        toError != null ||
        differentError != null ||
        factorError != null ||
        descriptionError != null) {
      setState(() {
        _productError = productError;
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

      final duplicate = await _repository.existsConversion(
        _productId!,
        _fromUnitId!,
        _toUnitId!,
        factor,
        excludeId: widget.conversion?.id,
      );
      if (duplicate) {
        _showDuplicateError();
        return;
      }

      if (_isEditing) {
        await _repository.updateConversion(
          widget.conversion!.id,
          productId: _productId!,
          fromUnitId: _fromUnitId!,
          toUnitId: _toUnitId!,
          conversionFactor: factor,
          description: description,
          isDefault: _isDefault,
        );
      } else {
        await _repository.createConversion(
          productId: _productId!,
          fromUnitId: _fromUnitId!,
          toUnitId: _toUnitId!,
          conversionFactor: factor,
          description: description,
          isDefault: _isDefault,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Product conversion updated successfully.'
                  : 'Product conversion created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on ProductUomAlreadyExistsException {
      _showDuplicateError();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save product conversion. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save product conversion. Please try again.');
    }
  }

  void _showDuplicateError() {
    if (!mounted) return;
    setState(() {
      _saving = false;
      _duplicateError =
          'An identical conversion already exists for this product.';
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
    final title =
        _isEditing ? 'Edit Product Conversion' : 'Create Product Conversion';
    final subtitle = _isEditing
        ? 'Update this product-specific unit conversion.'
        : 'Define a conversion rule specific to a single product.';

    if (_loadingData) {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
                Breadcrumbs(
                  items: ['Master Entry', 'Product UOM Conversion', title],
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
                      ProductPickerField(
                        products: _products,
                        selectedId: _productId,
                        onChanged: _onProductChanged,
                        onNavigateToProducts: widget.onNavigateToProducts,
                        errorText: _productError,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: UnitPickerField(
                              key: const ValueKey('product-from-unit-picker'),
                              label: 'From Unit',
                              isRequired: true,
                              units: _units,
                              selectedId: _fromUnitId,
                              excludeIds: _toUnitId == null
                                  ? const {}
                                  : {_toUnitId!},
                              onChanged: _onFromChanged,
                              onAddNewUnit: () async => null,
                              errorText: _fromError,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UnitPickerField(
                              key: const ValueKey('product-to-unit-picker'),
                              label: 'To Unit',
                              isRequired: true,
                              units: _units,
                              selectedId: _toUnitId,
                              excludeIds: _fromUnitId == null
                                  ? const {}
                                  : {_fromUnitId!},
                              onChanged: _onToChanged,
                              onAddNewUnit: () async => null,
                              errorText: _toError,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LabelledField(
                        label: 'Conversion Factor',
                        isRequired: true,
                        hintText: 'e.g. 20',
                        controller: _factorController,
                        errorText: _factorError,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1 From Unit = Factor × To Unit for this product. E.g., 1 Box = 20 Piece.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SwitchField(
                        title: 'Set as Default Conversion',
                        description:
                            'Automatically removes default flag from other conversions of this product.',
                        value: _isDefault,
                        onChanged: (val) => setState(() => _isDefault = val),
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
