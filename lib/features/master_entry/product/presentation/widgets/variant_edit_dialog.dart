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
  late final TextEditingController _notesController;
  DateTime? _selectedExpiryDate;
  String? _nameError;
  String? _priceError;
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
    _notesController = TextEditingController(text: widget.variant.notes ?? '');
    _selectedExpiryDate = widget.variant.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final notes = _notesController.text.trim();

    final vNameErr = ProductValidator.validateVariantName(name);
    final vPriceErr = ProductValidator.validateVariantSellingPrice(price);

    if (vNameErr != null || vPriceErr != null) {
      setState(() {
        _nameError = vNameErr;
        _priceError = vPriceErr;
      });
      return;
    }

    setState(() {
      _nameError = null;
      _priceError = null;
      _isSaving = true;
    });

    try {
      final parsedPrice = ProductValidator.parseRupeesToPaise(price) ?? 0;
      await widget.repository.updateVariant(
        widget.variant.id,
        variantName: name,
        sellingPrice: parsedPrice,
        expiryDate: _selectedExpiryDate,
        notes: notes.isEmpty ? null : notes,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ProductDuplicateException catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _nameError = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update variant. Please try again.')),
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
          Icon(
            Icons.edit_note_rounded,
            size: 24,
            color: AppTheme.primary,
          ),
          SizedBox(width: 8),
          Text('Edit Variant'),
        ],
      ),
      content: SizedBox(
        width: 440,
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
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Selling Price (₹) *',
                  hintText: 'e.g. 10',
                  errorText: _priceError,
                  prefixText: '₹ ',
                ),
                textInputAction: TextInputAction.next,
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
                            onPressed: () => setState(() => _selectedExpiryDate = null),
                            tooltip: 'Clear date',
                          )
                        : const Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                  child: Text(
                    formattedExpiry.isEmpty ? 'Optional' : formattedExpiry,
                    style: TextStyle(
                      fontSize: 14,
                      color: formattedExpiry.isEmpty
                          ? Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
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
