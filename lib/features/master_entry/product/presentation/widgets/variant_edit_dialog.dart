import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/exceptions/product_exceptions.dart';
import '../../services/product_validator.dart';

/// Modal dialog for editing an existing product variant.
class VariantEditDialog extends StatefulWidget {
  const VariantEditDialog({
    super.key,
    required this.variant,
    required this.repository,
  });

  final ProductVariantEntity variant;
  final ProductRepository repository;

  @override
  State<VariantEditDialog> createState() => _VariantEditDialogState();
}

class _VariantEditDialogState extends State<VariantEditDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _mrpController;
  late final TextEditingController _wholesalePriceController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _hsnCodeController;
  late final TextEditingController _notesController;
  DateTime? _selectedExpiryDate;

  String? _nameError;
  String? _priceError;
  String? _purchasePriceError;
  String? _mrpError;
  String? _wholesalePriceError;
  String? _barcodeError;
  String? _hsnCodeError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.variant.variantName);
    _priceController = TextEditingController(
      text: widget.variant.sellingPrice == 0
          ? ''
          : ProductValidator.formatPaise(widget.variant.sellingPrice),
    );
    _purchasePriceController = TextEditingController(
      text: widget.variant.purchasePrice == null
          ? ''
          : ProductValidator.formatPaise(widget.variant.purchasePrice!),
    );
    _mrpController = TextEditingController(
      text: widget.variant.mrp == null
          ? ''
          : ProductValidator.formatPaise(widget.variant.mrp!),
    );
    _wholesalePriceController = TextEditingController(
      text: widget.variant.wholesalePrice == null
          ? ''
          : ProductValidator.formatPaise(widget.variant.wholesalePrice!),
    );
    _barcodeController = TextEditingController(
      text: widget.variant.barcode ?? '',
    );
    _hsnCodeController = TextEditingController(
      text: widget.variant.hsnCode ?? '',
    );
    _notesController = TextEditingController(text: widget.variant.notes ?? '');
    _selectedExpiryDate = widget.variant.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _mrpController.dispose();
    _wholesalePriceController.dispose();
    _barcodeController.dispose();
    _hsnCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final purchasePrice = _purchasePriceController.text.trim();
    final mrp = _mrpController.text.trim();
    final wholesalePrice = _wholesalePriceController.text.trim();
    final barcode = _barcodeController.text.trim();
    final hsnCode = _hsnCodeController.text.trim();
    final notes = _notesController.text.trim();

    final vNameErr = ProductValidator.validateVariantName(name);
    final vPriceErr = ProductValidator.validateVariantSellingPrice(price);
    final vPurchaseErr = ProductValidator.validatePurchasePrice(purchasePrice);
    final vMrpErr = ProductValidator.validateMrp(mrp);
    final vWholesaleErr = ProductValidator.validateWholesalePrice(
      wholesalePrice,
    );
    final vBarcodeErr = ProductValidator.validateBarcode(barcode);
    final vHsnErr = ProductValidator.validateHsnCode(hsnCode);

    if (vNameErr != null ||
        vPriceErr != null ||
        vPurchaseErr != null ||
        vMrpErr != null ||
        vWholesaleErr != null ||
        vBarcodeErr != null ||
        vHsnErr != null) {
      setState(() {
        _nameError = vNameErr;
        _priceError = vPriceErr;
        _purchasePriceError = vPurchaseErr;
        _mrpError = vMrpErr;
        _wholesalePriceError = vWholesaleErr;
        _barcodeError = vBarcodeErr;
        _hsnCodeError = vHsnErr;
      });
      return;
    }

    setState(() {
      _nameError = null;
      _priceError = null;
      _purchasePriceError = null;
      _mrpError = null;
      _wholesalePriceError = null;
      _barcodeError = null;
      _hsnCodeError = null;
      _isSaving = true;
    });

    try {
      final parsedPrice = ProductValidator.parseRupeesToPaise(price) ?? 0;
      final parsedPurchasePrice = ProductValidator.parseRupeesToPaise(
        purchasePrice,
      );
      final parsedMrp = ProductValidator.parseRupeesToPaise(mrp);
      final parsedWholesalePrice = ProductValidator.parseRupeesToPaise(
        wholesalePrice,
      );

      await widget.repository.updateVariant(
        widget.variant.id,
        variantName: name,
        sellingPrice: parsedPrice,
        purchasePrice: parsedPurchasePrice,
        mrp: parsedMrp,
        wholesalePrice: parsedWholesalePrice,
        barcode: barcode.isEmpty ? null : barcode,
        hsnCode: hsnCode.isEmpty ? null : hsnCode,
        expiryDate: _selectedExpiryDate,
        notes: notes.isEmpty ? null : notes,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ProductDuplicateException catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        if (error.field == ProductDuplicateField.barcode) {
          _barcodeError = error.message;
        } else {
          _nameError = error.message;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update variant. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedExpiry = _selectedExpiryDate == null
        ? ''
        : '${_selectedExpiryDate!.day.toString().padLeft(2, '0')}/${_selectedExpiryDate!.month.toString().padLeft(2, '0')}/${_selectedExpiryDate!.year}';

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit_note_rounded, size: 24, color: AppTheme.primary),
          SizedBox(width: 8),
          Text('Edit Variant'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Variant Name *',
                  hintText: 'e.g. Parle-G 10',
                  errorText: _nameError,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Selling Price (₹) *',
                        hintText: 'e.g. 10',
                        errorText: _priceError,
                        prefixText: '₹ ',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _purchasePriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Purchase Price (₹)',
                        hintText: 'Optional',
                        errorText: _purchasePriceError,
                        prefixText: '₹ ',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mrpController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'MRP (₹)',
                        hintText: 'Optional',
                        errorText: _mrpError,
                        prefixText: '₹ ',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _wholesalePriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Wholesale Price (₹)',
                        hintText: 'Optional',
                        errorText: _wholesalePriceError,
                        prefixText: '₹ ',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        labelText: 'Barcode / SKU',
                        hintText: 'Optional',
                        errorText: _barcodeError,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _hsnCodeController,
                      decoration: InputDecoration(
                        labelText: 'HSN/SAC Code',
                        hintText: 'Optional',
                        errorText: _hsnCodeError,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedExpiryDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: 'Select variant expiry date',
                  );
                  if (picked != null) {
                    setState(() => _selectedExpiryDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'Optional',
                    suffixIcon: _selectedExpiryDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () =>
                                setState(() => _selectedExpiryDate = null),
                            tooltip: 'Clear date',
                          )
                        : const Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                  child: Text(
                    formattedExpiry.isEmpty ? 'Optional' : formattedExpiry,
                    style: TextStyle(
                      fontSize: 14,
                      color: formattedExpiry.isEmpty
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Optional notes',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _handleSave,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: const Text('Save Changes'),
        ),
      ],
    );
  }
}
