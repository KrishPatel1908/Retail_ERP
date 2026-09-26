import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_service.dart';
import 'package:retail_erp/features/master_entry/product/data/repositories/product_repository.dart';
import 'package:retail_erp/features/master_entry/product/domain/entities/product.dart';
import 'package:retail_erp/features/master_entry/product/presentation/pages/create_product_page.dart';
import 'package:retail_erp/features/master_entry/product/services/product_validator.dart';
import 'package:retail_erp/features/master_entry/supplier/data/repositories/supplier_repository.dart';
import 'package:retail_erp/features/master_entry/supplier/domain/entities/supplier.dart';
import 'package:retail_erp/features/master_entry/tax_category/data/repositories/tax_category_repository.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/utils/form_focus_controller.dart';
import '../../../../shared/widgets/breadcrumbs.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../domain/entities/purchase.dart';

/// How a line's discount value should be interpreted.
enum _DiscountType { percentage, amount }

/// A single selectable line in the Product dropdown.
///
/// Every sellable unit is its own option: a product with no variants
/// contributes one option carrying its own name, and a product with variants
/// contributes one option for the main product plus one per variant. Its label
/// is the product/variant name on its own — parent and variant names are never
/// combined.
class _ProductOption {
  const _ProductOption({
    required this.product,
    required this.variant,
    required this.label,
    required this.barcode,
    required this.purchasePrice,
    this.taxRate,
  });

  _ProductOption.base(ProductEntity product, {double? taxRate})
    : this(
        product: product,
        variant: null,
        label: product.productName,
        barcode: product.barcode,
        purchasePrice: product.purchasePrice,
        taxRate: taxRate,
      );

  _ProductOption.forVariant(
    ProductEntity product,
    ProductVariantEntity variant, {
    double? taxRate,
  }) : this(
         product: product,
         variant: variant,
         label: variant.variantName,
         barcode: variant.barcode ?? product.barcode,
         purchasePrice: variant.purchasePrice ?? product.purchasePrice,
         taxRate: taxRate,
       );

  final ProductEntity product;
  final ProductVariantEntity? variant;

  /// The sellable name shown in the dropdown.
  final String label;
  final String? barcode;
  final int? purchasePrice;

  /// Default purchase tax rate (%) for this option, resolved from Product
  /// Master's tax configuration when unambiguous. Null means the user enters
  /// the rate manually.
  final double? taxRate;

  int get productId => product.id;
  int? get variantId => variant?.id;
  String get key => keyFor(product.id, variant?.id);

  /// Stable dropdown value. Uses ':' as the separator and is always resolved by
  /// map lookup rather than string parsing, so product names containing '-' can
  /// never be mis-read.
  static String keyFor(int productId, int? variantId) =>
      '$productId:${variantId ?? 'base'}';
}

/// Data model for a product row in the purchase form.
class _ProductRow {
  _ProductRow({
    required this.productController,
    required this.barcodeController,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.taxController,
    this.locked = false,
  });

  final TextEditingController productController;
  final TextEditingController barcodeController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController taxController;

  // Selected product/variant IDs.
  int? productId;
  int? variantId;
  int? unitId;
  String? unitName;

  /// Whether [discountController] holds a percentage or a currency amount.
  _DiscountType discountType = _DiscountType.amount;

  /// When true, product identity fields (product dropdown, barcode) are
  /// read-only. Set for rows that already existed in an edited purchase.
  bool locked;

  /// Set when a scanned barcode matched nothing. Cleared on the next keystroke.
  String? barcodeError;

  /// Bumped to force the product dropdown's form-field state to be rebuilt from
  /// [optionKey] — needed after the "Add New Product" dialog, whose sentinel
  /// value would otherwise stay shown as the selection.
  int dropdownEpoch = 0;

  /// Dropdown key of the current selection, or null when nothing is selected.
  String? get optionKey =>
      productId == null ? null : _ProductOption.keyFor(productId!, variantId);

  // Focus nodes.
  late final FocusNode productFocusNode;
  late final FocusNode barcodeFocusNode;
  late final FocusNode quantityFocusNode;
  late final FocusNode priceFocusNode;
  late final FocusNode discountFocusNode;
  late final FocusNode discountTypeFocusNode;
  late final FocusNode taxFocusNode;
  late final GlobalKey productContainerKey;
  late final GlobalKey barcodeContainerKey;
  late final GlobalKey quantityContainerKey;
  late final GlobalKey priceContainerKey;
  late final GlobalKey discountContainerKey;
  late final GlobalKey taxContainerKey;

  bool _focusInitialized = false;

  void initFocusNodes(int index) {
    if (_focusInitialized) return;
    _focusInitialized = true;
    productFocusNode = FocusNode(debugLabel: 'purchase-product-$index');
    barcodeFocusNode = FocusNode(debugLabel: 'purchase-barcode-$index');
    quantityFocusNode = FocusNode(debugLabel: 'purchase-qty-$index');
    priceFocusNode = FocusNode(debugLabel: 'purchase-price-$index');
    discountFocusNode = FocusNode(debugLabel: 'purchase-discount-$index');
    discountTypeFocusNode = FocusNode(
      debugLabel: 'purchase-discount-type-$index',
    );
    taxFocusNode = FocusNode(debugLabel: 'purchase-tax-$index');
    productContainerKey = GlobalKey();
    barcodeContainerKey = GlobalKey();
    quantityContainerKey = GlobalKey();
    priceContainerKey = GlobalKey();
    discountContainerKey = GlobalKey();
    taxContainerKey = GlobalKey();
  }

  void dispose() {
    productController.dispose();
    barcodeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    discountController.dispose();
    taxController.dispose();
    if (_focusInitialized) {
      productFocusNode.dispose();
      barcodeFocusNode.dispose();
      quantityFocusNode.dispose();
      priceFocusNode.dispose();
      discountFocusNode.dispose();
      discountTypeFocusNode.dispose();
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
  List<Supplier> _suppliers = const [];
  List<ProductEntity> _products = const [];

  /// Flattened, variant-level product options in dropdown order.
  List<_ProductOption> _productOptions = const [];

  /// Same options keyed by [_ProductOption.key], for O(1) selection lookups.
  Map<String, _ProductOption> _optionsByKey = const {};

  /// Currency symbol from Company Settings, used for every amount on this page.
  String _currencySymbol = '';

  /// Default purchase tax rate (in %) per Tax Category, resolved from Product
  /// Master's `tax_category_rate` rows. It is the category's configured total
  /// (the sum of its component percentages), e.g. GST 18% = 9 + 9.
  Map<int, double> _taxRateByCategory = const {};

  /// Sentinel dropdown value for the "+ Add New Product" entry. The ':' prefix
  /// can never collide with a real option key.
  static const _addNewProductValue = ':add-new-product';

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
      _paidAmountController.text = ProductValidator.formatPaise(
        purchase.paidAmount,
      );
      _paymentMethod = purchase.paymentMethod ?? 'Cash';

      // Build product rows from existing items.
      _productRows = purchase.items.map((item) {
        final row = _ProductRow(
          productController: TextEditingController(
            text: _sellableName(item.productName, item.variantName),
          ),
          barcodeController: TextEditingController(text: item.barcode ?? ''),
          quantityController: TextEditingController(text: '${item.quantity}'),
          priceController: TextEditingController(
            text: ProductValidator.formatPaise(item.purchasePrice),
          ),
          // Stored discounts are always absolute amounts in paise.
          discountController: TextEditingController(
            text: ProductValidator.formatPaise(item.discount),
          ),
          taxController: TextEditingController(
            text: item.taxRate.toStringAsFixed(1),
          ),
          // Product identity is locked for pre-existing lines in edit mode.
          locked: true,
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
      final suppliers = await SupplierRepository().fetchAllActive();
      final productRepository = ProductRepository();
      final allProducts = await productRepository.fetchAllWithVariants();
      final taxRates = await _loadTaxRates();

      String symbol = '';
      try {
        final settings = await CompanySettingsService().getSettings();
        symbol = settings.currencySymbol.trim().isNotEmpty
            ? settings.currencySymbol.trim()
            : settings.currencyCode.trim();
      } catch (e) {
        debugPrint('Settings error: $e');
      }

      if (!mounted) return;
      setState(() {
        _suppliers = suppliers;
        _products = allProducts;
        _taxRateByCategory = taxRates;
        _currencySymbol = symbol.isEmpty ? '₹' : symbol;
        _rebuildProductOptions();
      });
    } catch (e) {
      debugPrint('Failed to load purchase dropdowns: $e');
    }
  }

  /// Reloads products only, so newly created records show up immediately.
  Future<void> _reloadProducts() async {
    try {
      final allProducts = await ProductRepository().fetchAllWithVariants();
      final taxRates = await _loadTaxRates();
      if (!mounted) return;
      setState(() {
        _products = allProducts;
        _taxRateByCategory = taxRates;
        _rebuildProductOptions();
      });
    } catch (e) {
      debugPrint('Failed to reload products: $e');
    }
  }

  /// Resolves the configured total tax rate (%) for each Tax Category from
  /// Product Master's `TaxCategoryRepository`.
  Future<Map<int, double>> _loadTaxRates() async {
    try {
      final categories = await TaxCategoryRepository().getAllTaxCategories();
      final result = <int, double>{};
      for (final cat in categories) {
        result[cat.id] = cat.totalTaxPercentage;
      }
      return result;
    } catch (e) {
      debugPrint('Failed to load tax categories: $e');
      return const {};
    }
  }

  /// Flattens [_products] into the options shown in the dropdown.
  ///
  /// Every sellable unit appears as its own option: a product with no variants
  /// contributes a single option carrying its own name, while a product with
  /// variants contributes **both** the main product *and* every variant. Each
  /// is an independent, selectable item. Variants inherit the parent's Tax
  /// Category, so a parent and its variants resolve to the same default tax
  /// rate. Any option key already referenced by a row is preserved even if the
  /// underlying record is no longer listed, so editing an older purchase never
  /// trips the dropdown's "value must match one item" assertion.
  ///
  /// Must be called from within [setState].
  void _rebuildProductOptions() {
    final options = <_ProductOption>[];
    final byKey = <String, _ProductOption>{};

    void add(_ProductOption option) {
      if (byKey.containsKey(option.key)) return;
      byKey[option.key] = option;
      options.add(option);
    }

    for (final product in _products) {
      final rate = _taxRateFor(product);
      add(_ProductOption.base(product, taxRate: rate));
      for (final variant in product.variants) {
        add(_ProductOption.forVariant(product, variant, taxRate: rate));
      }
    }

    // Keep selections made before the catalogue changed selectable.
    final productsById = {for (final product in _products) product.id: product};
    for (final row in _productRows) {
      final key = row.optionKey;
      if (key == null || byKey.containsKey(key)) continue;
      final product = productsById[row.productId];
      if (product == null) continue;

      ProductVariantEntity? variant;
      for (final candidate in product.variants) {
        if (candidate.id == row.variantId) {
          variant = candidate;
          break;
        }
      }
      // A variant that no longer exists cannot be represented; the dropdown
      // falls back to its hint for that row while the row keeps its IDs.
      if (row.variantId != null && variant == null) continue;

      final rate = _taxRateFor(product);
      add(
        variant == null
            ? _ProductOption.base(product, taxRate: rate)
            : _ProductOption.forVariant(product, variant, taxRate: rate),
      );
    }

    _productOptions = options;
    _optionsByKey = byKey;

    for (final row in _productRows) {
      if (row.barcodeController.text.trim().isEmpty && row.optionKey != null) {
        final opt = byKey[row.optionKey];
        if (opt?.barcode != null && opt!.barcode!.trim().isNotEmpty) {
          row.barcodeController.text = opt.barcode!.trim();
        }
      }
    }
  }

  /// The configured total purchase tax rate (%) for [product]'s Tax Category,
  /// or null when the product has no Tax Category configured.
  double? _taxRateFor(ProductEntity product) {
    final categoryId = product.taxCategoryId;
    if (categoryId == null) return null;
    return _taxRateByCategory[categoryId];
  }

  void _addProductRow() {
    final row = _ProductRow(
      productController: TextEditingController(),
      barcodeController: TextEditingController(),
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

  /// Applies [option] to the row at [index], replacing all product details:
  /// unit, barcode, purchase price, tax rate, and resetting quantity to 1 and discount to 0.
  void _selectOption(int index, _ProductOption option) {
    final row = _productRows[index];
    row.productId = option.productId;
    row.variantId = option.variantId;
    row.unitId = option.product.unitId;
    row.unitName = option.product.unitName;
    row.productController.text = option.label;
    row.barcodeError = null;

    // Keep the barcode field in sync with the selected variant, so the value
    // shown always belongs to the product on the line.
    if (option.barcode != null && option.barcode!.trim().isNotEmpty) {
      row.barcodeController.text = option.barcode!.trim();
    } else {
      row.barcodeController.clear();
    }

    final price = option.purchasePrice;
    if (price != null) {
      row.priceController.text = ProductValidator.formatPaise(price);
    } else {
      row.priceController.text = '';
    }

    final taxRate = option.taxRate;
    if (taxRate != null) {
      row.taxController.text = taxRate == taxRate.roundToDouble()
          ? taxRate.round().toString()
          : taxRate.toStringAsFixed(1);
    } else {
      row.taxController.text = '0';
    }

    row.quantityController.text = '1';
    row.discountController.text = '0';
    row.discountType = _DiscountType.amount;

    setState(() {
      row.dropdownEpoch++;
      final errors = Map<String, String?>.from(_errors);
      errors.remove('product_$index');
      errors.remove('qty_$index');
      errors.remove('price_$index');
      errors.remove('discount_$index');
      _errors = errors;
    });
  }

  /// Resolves a scanned/typed barcode to a selectable option.
  ///
  /// Only barcodes already registered in Product Master are accepted. Nothing is
  /// created, and an unknown code leaves the row's product untouched.
  Future<void> _onBarcodeSubmitted(int index, String rawValue) async {
    final code = rawValue.trim();
    if (code.isEmpty) return;

    _ProductOption? match = _findOptionByBarcode(code);

    // A product added elsewhere may not be in memory yet — refresh once.
    if (match == null) {
      await _reloadProducts();
      if (!mounted) return;
      match = _findOptionByBarcode(code);
    }

    // A refresh may have happened across an await; make sure the row is still
    // there before touching it.
    if (index >= _productRows.length) return;
    final row = _productRows[index];

    if (match == null) {
      setState(() {
        row.barcodeError = 'Barcode not found. Please add this product first.';
      });
      // Keep focus here so the next scan replaces the rejected code.
      row.barcodeFocusNode.requestFocus();
      row.barcodeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: row.barcodeController.text.length,
      );
      return;
    }

    _selectOption(index, match);

    // Keep the scanned barcode visible in the field so the user can confirm
    // which product was matched, then move focus to quantity for the next input.
    if (match.barcode != null && match.barcode!.trim().isNotEmpty) {
      row.barcodeController.text = match.barcode!.trim();
    } else {
      row.barcodeController.text = code;
    }

    row.quantityFocusNode.requestFocus();
    row.quantityController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: row.quantityController.text.length,
    );
  }

  /// Case-insensitive exact barcode match across the selectable options.
  ///
  /// Searching the options (rather than raw products) guarantees the result can
  /// actually be selected, and makes a variant barcode resolve that exact
  /// variant instead of only its parent product.
  _ProductOption? _findOptionByBarcode(String code) {
    final needle = code.toLowerCase();
    for (final option in _productOptions) {
      final barcode = option.barcode?.trim();
      if (barcode != null && barcode.toLowerCase() == needle) return option;
    }
    return null;
  }

  /// Opens Product Master's create form in a dialog.
  ///
  /// A dialog — rather than a pushed route — keeps this page mounted, so the
  /// purchase in progress survives and the new product can be auto-selected on
  /// return.
  Future<void> _openAddProductDialog(int index) async {
    ProductEntity? created;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 32,
          ),
          child: SizedBox(
            width: 860,
            height: 760,
            child: CreateProductPage(
              showBreadcrumbs: false,
              onSaved: (product) => created = product,
              onSave: () => Navigator.of(dialogContext).pop(),
              onCancel: () => Navigator.of(dialogContext).pop(),
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    // Discard the sentinel selection the dropdown is currently showing.
    setState(() => _productRows[index].dropdownEpoch++);

    await _reloadProducts();
    if (!mounted) return;

    final product = created;
    if (product == null) return;

    // Auto-select the new product so entry can continue without searching. The
    // main product is always a selectable option, so select it directly.
    final key = _ProductOption.keyFor(product.id, null);
    final option = _optionsByKey[key];
    if (option != null) _selectOption(index, option);
  }

  /// The name a product/variant is sold under. Variant names stand alone — they
  /// are never combined with the parent product name.
  String _sellableName(String productName, String? variantName) {
    if (variantName != null && variantName.trim().isNotEmpty) {
      return variantName;
    }
    return productName;
  }

  // ─── Calculations ───

  int _calculateLineSubtotal(_ProductRow row) {
    final qty = int.tryParse(row.quantityController.text) ?? 0;
    final price =
        ProductValidator.parseRupeesToPaise(row.priceController.text) ?? 0;
    return qty * price;
  }

  /// The effective discount for a line, in paise.
  ///
  /// Percentage mode multiplies the line subtotal; currency mode uses the entered
  /// amount directly. Both are clamped to the line subtotal, which is what stops
  /// a discount from driving the payable amount negative.
  int _calculateLineDiscount(_ProductRow row) {
    final subtotal = _calculateLineSubtotal(row);
    if (subtotal <= 0) return 0;

    if (row.discountType == _DiscountType.percentage) {
      final percent = double.tryParse(row.discountController.text.trim()) ?? 0;
      if (percent <= 0) return 0;
      final clamped = percent > 100 ? 100.0 : percent;
      return (subtotal * clamped / 100).round();
    }

    final amount =
        ProductValidator.parseRupeesToPaise(row.discountController.text) ?? 0;
    if (amount <= 0) return 0;
    return amount > subtotal ? subtotal : amount;
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

  /// Rejects a discount that would exceed the line amount, since that would make
  /// the payable amount negative.
  String? _validateDiscount(_ProductRow row) {
    final text = row.discountController.text.trim();
    if (text.isEmpty || text == '0') return null;

    if (row.discountType == _DiscountType.percentage) {
      final percent = double.tryParse(text);
      if (percent == null) return 'Enter a valid discount.';
      if (percent > 100) return 'Discount cannot exceed 100%.';
      return null;
    }

    final amount = ProductValidator.parseRupeesToPaise(text);
    if (amount == null) return 'Enter a valid discount.';
    final subtotal = _calculateLineSubtotal(row);
    if (subtotal > 0 && amount > subtotal) {
      return 'Discount cannot exceed the line amount.';
    }
    return null;
  }

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
      if (errors['discount_$i'] != null) {
        _productRows[i].discountFocusNode.requestFocus();
        return;
      }
    }
  }

  Future<void> _save() async {
    if (_saving) return;

    // Validate supplier.
    final supplierErr = _supplierId == null ? 'Supplier is required.' : null;

    // Validate product rows.
    final rowErrors = <String, String?>{};
    final seenKeys = <String>{};

    for (var i = 0; i < _productRows.length; i++) {
      final row = _productRows[i];

      final key = row.optionKey;
      if (key == null) {
        rowErrors['product_$i'] = 'Select a product.';
      } else if (!seenKeys.add(key)) {
        // Keyed by product *and* variant, so two variants of the same parent
        // product are still two legitimate lines.
        rowErrors['product_$i'] =
            'This product is already added. Update the existing quantity instead.';
      }

      final qtyText = row.quantityController.text.trim();
      final qty = int.tryParse(qtyText) ?? 0;
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

      final discountErr = _validateDiscount(row);
      if (discountErr != null) {
        rowErrors['discount_$i'] = discountErr;
      }
    }

    final errors = <String, String?>{'supplier': supplierErr, ...rowErrors};

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
        final parsedPrice = ProductValidator.parseRupeesToPaise(
          row.priceController.text.trim(),
        ) ?? 0;
        final parsedQty = int.tryParse(row.quantityController.text.trim()) ?? 1;

        return PurchaseItemInput(
          productId: row.productId!,
          variantId: row.variantId,
          quantity: parsedQty,
          unitId: row.unitId!,
          purchasePrice: parsedPrice,
          // Percentage discounts are resolved to paise here, so the stored value
          // always matches the amount shown in the summary.
          discount: _calculateLineDiscount(row),
          taxRate: double.tryParse(row.taxController.text.trim()) ?? 0,
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
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Purchase updated successfully.'
                  : 'Purchase created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save purchase. ${error.message}');
    } catch (error, st) {
      debugPrint('Error saving purchase: $error\n$st');
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
                    items: [
                      'Purchase',
                      _isEditing ? 'Edit Purchase' : 'Purchase Entry',
                    ],
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
                        _SectionTitle(
                          textTheme: textTheme,
                          title: 'Purchase Information',
                        ),
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
                            _SectionTitle(
                              textTheme: textTheme,
                              title: 'Products',
                            ),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: _addProductRow,
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text(
                                'Add Product',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
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
                            label: 'Debit Amount',
                            hintText: '0',
                            controller: _paidAmountController,
                            errorText: _errors['paidAmount'],
                            focusNode: _focusController.node('paymentAmount'),
                            containerKey: _focusController.key('paymentAmount'),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
            Text(
              'Supplier',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
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
            Text(
              'Purchase Date',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
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

  Widget _buildPaymentMethodField(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _paymentMethod,
          isExpanded: true,
          isDense: true,
          items: PaymentMethod.values
              .map(
                (m) => DropdownMenuItem(value: m.label, child: Text(m.label)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _paymentMethod = value);
          },
        ),
      ],
    );
  }

  Widget _buildProductRow(
    int index,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
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
              Text(
                'Item ${index + 1}',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (_productRows.length > 1 && !row.locked)
                _rowFocusOrder(
                  index,
                  7,
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    tooltip: 'Remove item',
                    onPressed: () => _removeProductRow(index),
                    color: colorScheme.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFormRow([
            _rowFocusOrder(
              index,
              0,
              _buildProductDropdown(index, row, textTheme, colorScheme),
            ),
            _rowFocusOrder(
              index,
              1,
              _buildBarcodeField(index, row, textTheme, colorScheme),
            ),
          ]),
          const SizedBox(height: 12),
          _buildFormRow([
            _rowFocusOrder(
              index,
              2,
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
                onChanged: (_) => setState(() {}),
              ),
            ),
            _rowFocusOrder(
              index,
              3,
              LabelledField(
                label: 'Purchase Price',
                isRequired: true,
                hintText: '0.00',
                controller: row.priceController,
                errorText: _errors['price_$index'],
                focusNode: row.priceFocusNode,
                containerKey: row.priceContainerKey,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          _buildFormRow([
            _buildDiscountField(index, row, textTheme),
            _rowFocusOrder(
              index,
              6,
              LabelledField(
                label: 'Tax Rate (%)',
                hintText: '0',
                controller: row.taxController,
                focusNode: row.taxFocusNode,
                containerKey: row.taxContainerKey,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ]),
          if (row.unitName != null) ...[
            const SizedBox(height: 8),
            Text(
              'Unit: ${row.unitName}',
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Line Total: ',
                style: textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                _formatCurrency(_calculateLineTotal(row)),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown(
    int index,
    _ProductRow row,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    // Only offer a selected value the dropdown can actually match, otherwise it
    // asserts. The row keeps its IDs either way.
    final selectedKey = row.optionKey;
    final initialValue =
        selectedKey != null && _optionsByKey.containsKey(selectedKey)
        ? selectedKey
        : null;

    // A pre-existing line's product identity is locked: it is shown read-only
    // instead of as an editable dropdown. This prevents replacing the product,
    // but does not affect the "+ Add New Product" flow.
    if (row.locked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Product',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              isDense: true,
              errorText: _errors['product_$index'],
              errorMaxLines: 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.productController.text.trim().isEmpty
                        ? 'No product selected'
                        : row.productController.text.trim(),
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Product',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey('product-$index-$initialValue-${row.dropdownEpoch}'),
          initialValue: initialValue,
          focusNode: row.productFocusNode,
          isExpanded: true,
          isDense: true,
          hint: const Text('Search product...'),
          items: _buildProductItems(colorScheme),
          onChanged: (value) {
            if (value == null) return;
            if (value == _addNewProductValue) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _openAddProductDialog(index);
              });
              return;
            }
            final option = _optionsByKey[value];
            if (option != null) _selectOption(index, option);
          },
          decoration: InputDecoration(
            errorText: _errors['product_$index'],
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  /// One entry per sellable unit, plus the "+ Add New Product" shortcut.
  ///
  /// Variants are listed under their own name — never "Parent - Variant" — so the
  /// list reads as a flat list of things that can actually be purchased.
  List<DropdownMenuItem<String>> _buildProductItems(ColorScheme colorScheme) {
    return [
      DropdownMenuItem(
        value: _addNewProductValue,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'Add New Product',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      for (final option in _productOptions)
        DropdownMenuItem(
          value: option.key,
          child: Text(option.label, overflow: TextOverflow.ellipsis),
        ),
    ];
  }

  /// Scanner-friendly barcode entry for a line.
  ///
  /// Scanners send the code followed by Enter, which lands on [onSubmitted].
  Widget _buildBarcodeField(
    int index,
    _ProductRow row,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    if (row.locked) {
      final barcode = row.barcodeController.text.trim();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Barcode',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              isDense: true,
              errorText: row.barcodeError,
              errorMaxLines: 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    barcode.isEmpty ? '—' : barcode,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge?.copyWith(
                      color: barcode.isEmpty
                          ? colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return LabelledField(
      label: 'Barcode',
      hintText: 'Scan or enter barcode',
      controller: row.barcodeController,
      errorText: row.barcodeError,
      focusNode: row.barcodeFocusNode,
      containerKey: row.barcodeContainerKey,
      // Product identity on a pre-existing line is locked in edit mode.
      readOnly: row.locked,
      textInputAction: TextInputAction.done,
      onChanged: (_) {
        // Clear the rejection as soon as a new code starts arriving.
        if (row.barcodeError != null) {
          setState(() => row.barcodeError = null);
        }
      },
      onSubmitted: (value) => _onBarcodeSubmitted(index, value),
    );
  }

  /// Discount value plus a "% / currency" mode selector.
  Widget _buildDiscountField(int index, _ProductRow row, TextTheme textTheme) {
    return _rowFocusOrder(
      index,
      4,
      LabelledField(
        label: 'Discount',
        hintText: '0',
        controller: row.discountController,
        errorText: _errors['discount_$index'],
        focusNode: row.discountFocusNode,
        containerKey: row.discountContainerKey,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: (_) {
          // Keep the live line total and summary in step with typing.
          setState(() {});
        },
        // Sits immediately after the value field in the Tab order.
        trailing: _rowFocusOrder(
          index,
          5,
          SizedBox(
            width: 92,
            child: DropdownButtonFormField<_DiscountType>(
              key: ValueKey('discount-type-$index'),
              initialValue: row.discountType,
              focusNode: row.discountTypeFocusNode,
              isDense: true,
              isExpanded: true,
              style: textTheme.bodyMedium,
              items: [
                const DropdownMenuItem(
                  value: _DiscountType.percentage,
                  child: Text('%'),
                ),
                DropdownMenuItem(
                  value: _DiscountType.amount,
                  child: Text(
                    _currencySymbolOrDefault,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  row.discountType = value;
                  // Switching modes reinterprets the same number, so a stale
                  // "exceeds the line amount" message must not linger.
                  final errors = Map<String, String?>.from(_errors);
                  errors.remove('discount_$index');
                  _errors = errors;
                });
              },
            ),
          ),
        ),
      ),
    );
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
          _SummaryRow(
            label: 'Discount',
            value: '- ${_formatCurrency(_totalDiscount)}',
          ),
          _SummaryRow(label: 'Tax', value: _formatCurrency(_totalTax)),
          Divider(color: colorScheme.outlineVariant),
          _SummaryRow(
            label: 'Grand Total',
            value: _formatCurrency(_grandTotal),
            bold: true,
          ),
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
          _SummaryRow(
            label: 'Grand Total',
            value: _formatCurrency(_grandTotal),
          ),
          _SummaryRow(
            label: 'Debit Amount',
            value: _formatCurrency(_paidAmount),
            valueColor: _paidAmount > 0
                ? AppTheme.success
                : AppTheme.textPrimary,
          ),
          _SummaryRow(
            label: 'Credit Amount',
            value: _formatCurrency(_dueAmount),
            valueColor: _dueAmount > 0 ? AppTheme.danger : AppTheme.success,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _paymentStatus.label,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
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

  /// Formats paise using the currency symbol from Company Settings.
  String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '$_currencySymbolOrDefault$text';
  }

  /// Falls back to '₹' only until Company Settings have loaded.
  String get _currencySymbolOrDefault =>
      _currencySymbol.isEmpty ? '₹' : _currencySymbol;

  /// Slots a product-row control into the form's traversal order.
  ///
  /// Item-row controls own their focus nodes instead of borrowing
  /// [FormFocusController]'s, so they carry no [NumericFocusOrder] — and
  /// [OrderedTraversalPolicy] sorts every unordered node *after* the ordered
  /// ones, which would push the whole Products section past the Save button.
  /// These fractional orders sit between 'notes' and 'paymentAmount', keeping
  /// Tab flowing product → barcode → quantity → price → discount → % / currency
  /// → tax, row after row.
  Widget _rowFocusOrder(int rowIndex, int fieldIndex, Widget child) {
    const notesOrder = 4.0; // _fieldOrder.indexOf('notes') + 1
    return FocusTraversalOrder(
      order: NumericFocusOrder(
        notesOrder + (rowIndex * 10 + fieldIndex + 1) / 10000,
      ),
      child: child,
    );
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
        Icon(
          Icons.circle,
          size: 6,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
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
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
