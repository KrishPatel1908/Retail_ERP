import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/product/domain/entities/product.dart';
import 'package:retail_erp/features/master_entry/product/services/product_validator.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/utils/form_focus_controller.dart';
import '../../../../shared/widgets/breadcrumbs.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../domain/entities/purchase.dart';

/// Data model for a product row in the purchase form.
class _ProductRow {
  _ProductRow({
    required this.productController,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.taxController,
  });

  final TextEditingController productController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController taxController;

  // Selected product/variant IDs.
  int? productId;
  int? variantId;
  int? unitId;
  String? unitName;

  // Focus nodes.
  late final FocusNode productFocusNode;
  late final FocusNode quantityFocusNode;
  late final FocusNode priceFocusNode;
  late final FocusNode discountFocusNode;
  late final FocusNode taxFocusNode;
  late final GlobalKey productContainerKey;
  late final GlobalKey quantityContainerKey;
  late final GlobalKey priceContainerKey;
  late final GlobalKey discountContainerKey;
  late final GlobalKey taxContainerKey;

  bool _focusInitialized = false;

  void initFocusNodes(int index) {
    if (_focusInitialized) return;
    _focusInitialized = true;
    productFocusNode = FocusNode(debugLabel: 'purchase-product-$index');
    quantityFocusNode = FocusNode(debugLabel: 'purchase-qty-$index');
    priceFocusNode = FocusNode(debugLabel: 'purchase-price-$index');
    discountFocusNode = FocusNode(debugLabel: 'purchase-discount-$index');
    taxFocusNode = FocusNode(debugLabel: 'purchase-tax-$index');
    productContainerKey = GlobalKey();
    quantityContainerKey = GlobalKey();
    priceContainerKey = GlobalKey();
    discountContainerKey = GlobalKey();
    taxContainerKey = GlobalKey();
  }

  void dispose() {
    productController.dispose();
    quantityController.dispose();
    priceController.dispose();
    discountController.dispose();
    taxController.dispose();
    if (_focusInitialized) {
      productFocusNode.dispose();
      quantityFocusNode.dispose();
      priceFocusNode.dispose();
      discountFocusNode.dispose();
      taxFocusNode.dispose();
    }
  }
}

/// "Create / Edit Purchase" form page.
class CreatePurchasePage extends StatefulWidget {
  const CreatePurchasePage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.purchase,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;

  /// When provided, the form edits this existing purchase.
  final PurchaseEntity? purchase;

  @override
  State<CreatePurchasePage> createState() => _CreatePurchasePageState();
}

class _CreatePurchasePageState extends State<CreatePurchasePage> {
  late final PurchaseRepository _repository;
  late final FormFocusController _focusController;

  static const _fieldOrder = [
    'supplier',
    'date',
    'invoice',
    'notes',
    'paymentAmount',
    'paymentMethod',
    'cancel',
    'save',
  ];

  // Controllers.
  int? _supplierId;
  DateTime _purchaseDate = DateTime.now();
  final _invoiceController = TextEditingController();
  final _notesController = TextEditingController();
  final _paidAmountController = TextEditingController(text: '0');
  String _paymentMethod = 'Cash';

  // Product rows.
  List<_ProductRow> _productRows = [];

  // Dropdown data.
  List<db.Supplier> _suppliers = const [];
  List<ProductEntity> _products = const [];

  Map<String, String?> _errors = const {};
  bool _saving = false;

  bool get _isEditing => widget.purchase != null;

  @override
  void initState() {
    super.initState();
    _repository = PurchaseRepository();
    _focusController = FormFocusController(_fieldOrder);

    // Pre-fill from existing purchase if editing.
    final purchase = widget.purchase;
    if (purchase != null) {
      _supplierId = purchase.supplierId;
      _purchaseDate = purchase.purchaseDate;
      _invoiceController.text = purchase.invoiceNumber ?? '';
      _notesController.text = purchase.notes ?? '';
      _paidAmountController.text =
          ProductValidator.formatPaise(purchase.paidAmount);
      _paymentMethod = purchase.paymentMethod ?? 'Cash';

      // Build product rows from existing items.
      _productRows = purchase.items.map((item) {
        final row = _ProductRow(
          productController: TextEditingController(
            text: _buildProductLabel(item.productName, item.variantName),
          ),
          quantityController: TextEditingController(
            text: '${item.quantity}',
          ),
          priceController: TextEditingController(
            text: ProductValidator.formatPaise(item.purchasePrice),
          ),
          discountController: TextEditingController(
            text: ProductValidator.formatPaise(item.discount),
          ),
          taxController: TextEditingController(
            text: item.taxRate.toStringAsFixed(1),
          ),
        );
        row.productId = item.productId;
        row.variantId = item.variantId;
        row.unitId = item.unitId;
        row.unitName = item.unitName;
        return row;
      }).toList();

      for (var i = 0; i < _productRows.length; i++) {
        _productRows[i].initFocusNodes(i);
      }
    } else {
      _addProductRow();
    }

    _loadDropdowns();
  }

  @override
  void dispose() {
    _focusController.dispose();
    _invoiceController.dispose();
    _notesController.dispose();
    _paidAmountController.dispose();
    for (final row in _productRows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _loadDropdowns() async {
    try {
      final database = DatabaseProvider.instance.database;
      final suppliers = await (database.select(database.suppliers)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.supplierName.lower())]))
          .get();

      final productRepository = ProductRepository();
      final allProducts = await productRepository.fetchAllWithVariants();

      if (!mounted) return;
      setState(() {
        _suppliers = suppliers;
        _products = allProducts;
      });
    } catch (_) {}
  }

  void _addProductRow() {
    final row = _ProductRow(
      productController: TextEditingController(),
      quantityController: TextEditingController(),
      priceController: TextEditingController(),
      discountController: TextEditingController(text: '0'),
      taxController: TextEditingController(text: '0'),
    );
    row.initFocusNodes(_productRows.length);
    setState(() => _productRows.add(row));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_productRows.isNotEmpty && mounted) {
        _productRows.last.productFocusNode.requestFocus();
      }
    });
  }

  void _removeProductRow(int index) {
    if (_productRows.length <= 1) return;
    setState(() {
      final removed = _productRows.removeAt(index);
      removed.dispose();
    });
  }

  void _onProductSelected(int index, ProductEntity? product, int? variantId) {
    if (product == null) return;
    final row = _productRows[index];
    row.productId = product.id;
    row.variantId = variantId;
    row.unitId = product.unitId;
    row.unitName = product.unitName;

    final variant = variantId != null
        ? product.variants.firstWhere(
            (v) => v.id == variantId,
            orElse: () => product.variants.first,
          )
        : null;

    final label = _buildProductLabel(product.productName, variant?.variantName);
    row.productController.text = label;

    setState(() {});
  }

  String _buildProductLabel(String productName, String? variantName) {
    if (variantName != null) return '$productName - $variantName';
    return productName;
  }

  // ─── Calculations ───

  int _calculateLineSubtotal(_ProductRow row) {
    final qty = int.tryParse(row.quantityController.text) ?? 0;
    final price = ProductValidator.parseRupeesToPaise(row.priceController.text) ?? 0;
    return qty * price;
  }

  int _calculateLineDiscount(_ProductRow row) {
    return ProductValidator.parseRupeesToPaise(row.discountController.text) ?? 0;
  }

  double _calculateLineTaxRate(_ProductRow row) {
    return double.tryParse(row.taxController.text) ?? 0;
  }

  int _calculateLineTax(_ProductRow row) {
    final subtotal = _calculateLineSubtotal(row);
    final discount = _calculateLineDiscount(row);
    final taxable = subtotal - discount;
    final rate = _calculateLineTaxRate(row);
    return (taxable * rate / 100).round();
  }

  int _calculateLineTotal(_ProductRow row) {
    final subtotal = _calculateLineSubtotal(row);
    final discount = _calculateLineDiscount(row);
    final tax = _calculateLineTax(row);
    return subtotal - discount + tax;
  }

  int get _subtotal {
    int total = 0;
    for (final row in _productRows) {
      total += _calculateLineSubtotal(row);
    }
    return total;
  }

  int get _totalDiscount {
    int total = 0;
    for (final row in _productRows) {
      total += _calculateLineDiscount(row);
    }
    return total;
  }

  int get _totalTax {
    int total = 0;
    for (final row in _productRows) {
      total += _calculateLineTax(row);
    }
    return total;
  }

  int get _grandTotal => _subtotal - _totalDiscount + _totalTax;

  int get _paidAmount {
    return ProductValidator.parseRupeesToPaise(_paidAmountController.text) ?? 0;
  }

  int get _dueAmount {
    final paid = _paidAmount;
    final total = _grandTotal;
    final due = total - paid;
    return due < 0 ? 0 : due;
  }

  PurchasePaymentStatus get _paymentStatus {
    final paid = _paidAmount;
    final total = _grandTotal;
    if (total <= 0 || paid <= 0) return PurchasePaymentStatus.unpaid;
    if (paid >= total) return PurchasePaymentStatus.paid;
    return PurchasePaymentStatus.partial;
  }

  // ─── Validation ───

  void _focusFirstError(Map<String, String?> errors) {
    for (final field in _fieldOrder) {
      if (errors[field] != null) {
        _focusController.focusFirstError(errors);
        return;
      }
    }
    for (var i = 0; i < _productRows.length; i++) {
      final errKey = 'product_$i';
      if (errors[errKey] != null) {
        _productRows[i].productFocusNode.requestFocus();
        return;
      }
      if (errors['qty_$i'] != null) {
        _productRows[i].quantityFocusNode.requestFocus();
        return;
      }
      if (errors['price_$i'] != null) {
        _productRows[i].priceFocusNode.requestFocus();
        return;
      }
    }
  }

  Future<void> _save() async {
    // Validate supplier.
    final supplierErr = _supplierId == null ? 'Supplier is required.' : null;

    // Validate product rows.
    final rowErrors = <String, String?>{};
    final productIds = <int?>[];

    for (var i = 0; i < _productRows.length; i++) {
      final row = _productRows[i];
      if (row.productId == null) {
        rowErrors['product_$i'] = 'Select a product.';
      }
      productIds.add(row.productId);

      final qty = int.tryParse(row.quantityController.text) ?? 0;
      if (qty <= 0) {
        rowErrors['qty_$i'] = 'Quantity must be greater than 0.';
      }

      final price = row.priceController.text.trim();
      if (price.isEmpty) {
        rowErrors['price_$i'] = 'Purchase price is required.';
      } else {
        final parsed = ProductValidator.parseRupeesToPaise(price);
        if (parsed == null || parsed < 0) {
          rowErrors['price_$i'] = 'Enter a valid price.';
        }
      }
    }

    // Check for duplicate products.
    final validIds = productIds.whereType<int>().toList();
    final seenIds = <int>{};
    for (var i = 0; i < validIds.length; i++) {
      if (!seenIds.add(validIds[i])) {
        rowErrors['product_$i'] =
            'This product is already added. Update the existing quantity instead.';
        break;
      }
    }

    final errors = <String, String?>{
      'supplier': supplierErr,
      ...rowErrors,
    };

    final hasErrors = errors.values.any((e) => e != null);
    if (hasErrors) {
      setState(() => _errors = errors);
      _focusFirstError(errors);
      return;
    }

    setState(() {
      _saving = true;
      _errors = const {};
    });

    try {
      final items = _productRows.map((row) {
        return PurchaseItemInput(
          productId: row.productId!,
          variantId: row.variantId,
          quantity: int.parse(row.quantityController.text),
          unitId: row.unitId!,
          purchasePrice: ProductValidator.parseRupeesToPaise(row.priceController.text)!,
          discount: ProductValidator.parseRupeesToPaise(row.discountController.text) ?? 0,
          taxRate: double.tryParse(row.taxController.text) ?? 0,
        );
      }).toList();

      if (_isEditing) {
        await _repository.updatePurchase(
          widget.purchase!.id,
          supplierId: _supplierId!,
          purchaseDate: _purchaseDate,
          invoiceNumber: _invoiceController.text,
          paymentMethod: _paymentMethod,
          paidAmount: _paidAmount,
          notes: _notesController.text,
          items: items,
        );
      } else {
        await _repository.createPurchase(
          supplierId: _supplierId!,
          purchaseDate: _purchaseDate,
          invoiceNumber: _invoiceController.text,
          paymentMethod: _paymentMethod,
          paidAmount: _paidAmount,
          notes: _notesController.text,
          items: items,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(_isEditing
              ? 'Purchase updated successfully.'
              : 'Purchase created successfully.'),
        ));
      widget.onSave();
    } on PurchaseValidationException catch (e) {
      _showFailure(e.message);
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save purchase. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save purchase. Please try again.');
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
    final title = _isEditing ? 'Edit Purchase' : 'Purchase Entry';
    final subtitle = _isEditing
        ? 'Update the details of this purchase.'
        : 'Record products purchased from a supplier.';

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumbs(
                    items: ['Purchase', _isEditing ? 'Edit Purchase' : 'Purchase Entry'],
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

                  // ── Purchase Information ──
                  ContentPanel(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionTitle(textTheme: textTheme, title: 'Purchase Information'),
                        const SizedBox(height: 16),
                        _buildFormRow([
                          _buildSupplierField(textTheme, colorScheme),
                          _buildDateField(textTheme, colorScheme),
                        ]),
                        const SizedBox(height: 20),
                        _buildFormRow([
                          LabelledField(
                            label: 'Invoice / Bill No.',
                            hintText: 'e.g. INV-45821',
                            controller: _invoiceController,
                            focusNode: _focusController.node('invoice'),
                            containerKey: _focusController.key('invoice'),
                          ),
                          LabelledField(
                            label: 'Notes',
                            hintText: 'Optional notes',
                            controller: _notesController,
                            focusNode: _focusController.node('notes'),
                            containerKey: _focusController.key('notes'),
                            maxLines: 2,
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Products Section ──
                  ContentPanel(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _SectionTitle(textTheme: textTheme, title: 'Products'),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: _addProductRow,
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text('Add Product',
                                  style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        for (var i = 0; i < _productRows.length; i++)
                          _buildProductRow(i, textTheme, colorScheme),
                        if (_productRows.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Click "Add Product" to add items.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        _buildSummary(textTheme, colorScheme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Payment Section ──
                  ContentPanel(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionTitle(textTheme: textTheme, title: 'Payment'),
                        const SizedBox(height: 16),
                        _buildFormRow([
                          LabelledField(
                            label: 'Paid Amount',
                            hintText: '0',
                            controller: _paidAmountController,
                            errorText: _errors['paidAmount'],
                            focusNode: _focusController.node('paymentAmount'),
                            containerKey: _focusController.key('paymentAmount'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                          ),
                          _buildPaymentMethodField(textTheme, colorScheme),
                        ]),
                        const SizedBox(height: 12),
                        _buildPaymentSummary(textTheme, colorScheme),
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
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.check_rounded, size: 18),
                          label: Text(
                            _isEditing ? 'Save Changes' : 'Save Purchase',
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

  Widget _buildSupplierField(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Supplier',
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Text('*',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        FormFocusController.applyOrder(
          _focusController.node('supplier'),
          DropdownButtonFormField<int>(
            key: const ValueKey('supplier-dropdown'),
            initialValue: _supplierId,
            focusNode: _focusController.node('supplier'),
            isExpanded: true,
            isDense: true,
            items: [
              for (final s in _suppliers)
                DropdownMenuItem(value: s.id, child: Text(s.supplierName)),
            ],
            onChanged: (value) => setState(() => _supplierId = value),
            hint: const Text('Select supplier'),
            decoration: InputDecoration(
              errorText: _errors['supplier'],
              errorMaxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(TextTheme textTheme, ColorScheme colorScheme) {
    final formatted =
        '${_purchaseDate.day.toString().padLeft(2, '0')}/${_purchaseDate.month.toString().padLeft(2, '0')}/${_purchaseDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Purchase Date',
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Text('*',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _purchaseDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _purchaseDate = picked);
          },
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: const InputDecoration(),
            child: Text(formatted),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodField(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _paymentMethod,
          isExpanded: true,
          isDense: true,
          items: PaymentMethod.values
              .map((m) => DropdownMenuItem(value: m.label, child: Text(m.label)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _paymentMethod = value);
          },
        ),
      ],
    );
  }

  Widget _buildProductRow(int index, TextTheme textTheme, ColorScheme colorScheme) {
    final row = _productRows[index];
    row.initFocusNodes(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Item ${index + 1}',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              if (_productRows.length > 1)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  tooltip: 'Remove item',
                  onPressed: () => _removeProductRow(index),
                  color: colorScheme.error,
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildProductDropdown(index, row, textTheme, colorScheme),
          const SizedBox(height: 12),
          _buildFormRow([
            LabelledField(
              label: 'Quantity',
              isRequired: true,
              hintText: '0',
              controller: row.quantityController,
              errorText: _errors['qty_$index'],
              focusNode: row.quantityFocusNode,
              containerKey: row.quantityContainerKey,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            LabelledField(
              label: 'Purchase Price',
              isRequired: true,
              hintText: '0.00',
              controller: row.priceController,
              errorText: _errors['price_$index'],
              focusNode: row.priceFocusNode,
              containerKey: row.priceContainerKey,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ]),
          const SizedBox(height: 12),
          _buildFormRow([
            LabelledField(
              label: 'Discount',
              hintText: '0',
              controller: row.discountController,
              focusNode: row.discountFocusNode,
              containerKey: row.discountContainerKey,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            LabelledField(
              label: 'Tax Rate (%)',
              hintText: '0',
              controller: row.taxController,
              focusNode: row.taxFocusNode,
              containerKey: row.taxContainerKey,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ]),
          if (row.unitName != null) ...[
            const SizedBox(height: 8),
            Text('Unit: ${row.unitName}',
                style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary)),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Line Total: ',
                  style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary)),
              Text(
                _formatCurrency(_calculateLineTotal(row)),
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown(
    int index, _ProductRow row, TextTheme textTheme, ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Product',
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Text('*',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey('product-$index-${row.productId}'),
          initialValue: row.productId != null
              ? '${row.productId}-${row.variantId ?? 'base'}'
              : null,
          focusNode: row.productFocusNode,
          isExpanded: true,
          isDense: true,
          hint: const Text('Search product...'),
          items: _buildProductItems(),
          onChanged: (value) {
            if (value == null) return;
            final parts = value.split('-');
            final productId = int.parse(parts[0]);
            final variantId =
                parts.length > 1 && parts[1] != 'base' ? int.parse(parts[1]) : null;
            final product = _products.firstWhere((p) => p.id == productId);
            _onProductSelected(index, product, variantId);
          },
          decoration: InputDecoration(
            errorText: _errors['product_$index'],
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildProductItems() {
    final items = <DropdownMenuItem<String>>[];
    for (final product in _products) {
      items.add(DropdownMenuItem(
        value: '${product.id}-base',
        child: Text(product.productName),
      ));
      for (final variant in product.variants) {
        items.add(DropdownMenuItem(
          value: '${product.id}-${variant.id}',
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('${product.productName} - ${variant.variantName}',
                style: const TextStyle(fontSize: 13)),
          ),
        ));
      }
    }
    return items;
  }

  Widget _buildSummary(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.hover,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(label: 'Subtotal', value: _formatCurrency(_subtotal)),
          _SummaryRow(label: 'Discount', value: '- ${_formatCurrency(_totalDiscount)}'),
          _SummaryRow(label: 'Tax', value: _formatCurrency(_totalTax)),
          Divider(color: colorScheme.outlineVariant),
          _SummaryRow(label: 'Grand Total', value: _formatCurrency(_grandTotal), bold: true),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(TextTheme textTheme, ColorScheme colorScheme) {
    final statusColor = switch (_paymentStatus) {
      PurchasePaymentStatus.paid => AppTheme.success,
      PurchasePaymentStatus.partial => AppTheme.warning,
      PurchasePaymentStatus.unpaid => AppTheme.danger,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.hover,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(label: 'Grand Total', value: _formatCurrency(_grandTotal)),
          _SummaryRow(label: 'Paid Amount', value: _formatCurrency(_paidAmount)),
          _SummaryRow(
            label: 'Due Amount',
            value: _formatCurrency(_dueAmount),
            valueColor: _dueAmount > 0 ? AppTheme.danger : AppTheme.success,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _paymentStatus.label,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
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

  static String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '₹$text';
  }
}

// ─── Helper widgets ───

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.textTheme, required this.title});
  final TextTheme textTheme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(value,
              style: textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  color: valueColor ?? AppTheme.textPrimary)),
        ],
      ),
    );
  }
}
