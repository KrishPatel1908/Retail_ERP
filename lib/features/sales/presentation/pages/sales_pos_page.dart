import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../company_settings/data/repositories/company_settings_repository.dart';
import '../../../company_settings/domain/entities/company_settings.dart';
import '../../../master_entry/category/data/repositories/category_repository.dart';
import '../../../master_entry/category/domain/entities/category.dart';
import '../../../master_entry/customer/domain/entities/customer.dart';
import '../../data/repositories/bill_format_repository.dart';
import '../../data/repositories/sales_repository.dart';
import '../../data/services/sales_demo_data_seeder.dart';
import '../../domain/entities/pos_cart_item.dart';
import '../../domain/entities/sellable_item.dart';
import '../../domain/exceptions/sales_exceptions.dart';
import '../dialogs/bill_preview_dialog.dart';
import '../dialogs/clear_cart_dialog.dart';
import '../dialogs/customer_picker_dialog.dart';
import '../dialogs/payment_dialog.dart';

/// Desktop-first Sales Point of Sale (POS) interface.
///
/// Layout hierarchy:
/// - Compact module header at top of right area (Bill #, Date/Time, Customer Selector).
/// - Main Product Area on Left (Search/Barcode, Categories, multi-column Product Cards).
/// - Cart & Sale Summary on Right (Scrollable Cart Item list, Subtotal, Discount, Tax, Grand Total, Pay F12).
class SalesPosPage extends StatefulWidget {
  const SalesPosPage({super.key});

  @override
  State<SalesPosPage> createState() => _SalesPosPageState();
}

class _SalesPosPageState extends State<SalesPosPage> {
  late final SalesRepository _repository;
  late final CompanySettingsRepository _settingsRepo;
  late final CategoryRepository _categoryRepo;
  late final BillFormatRepository _billFormatRepo;
  late final SalesDemoDataSeeder _demoSeeder;

  // Active Sale State
  Customer? _selectedCustomer;
  final List<PosCartItem> _cartItems = [];
  final TextEditingController _billDiscountController = TextEditingController(text: '0');
  final TextEditingController _notesController = TextEditingController();

  // Search & Barcode
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<SellableItem> _searchResults = [];
  bool _searching = false;
  Timer? _searchDebounce;

  // Categories & Quick Access Product Catalog
  List<Category> _categories = [];
  int? _selectedCategoryId; // null = 'All'
  List<SellableItem> _catalogProducts = [];
  bool _catalogLoading = false;

  // POS Metadata
  String _currencySymbol = '₹';
  String _nextSaleNumber = '';
  DateTime _saleDate = DateTime.now();
  Timer? _clockTimer;
  CompanySettings? _companySettings;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _repository = SalesRepository();
    _settingsRepo = CompanySettingsRepository();
    _categoryRepo = CategoryRepository();
    _billFormatRepo = BillFormatRepository.instance;
    _demoSeeder = SalesDemoDataSeeder();

    _loadSettingsAndNextNumber();
    _loadCategoriesAndCatalog();

    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _saleDate = DateTime.now());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _billDiscountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadSettingsAndNextNumber() async {
    try {
      final settings = await _settingsRepo.getOrCreate();
      final symbol = settings.currencySymbol.trim().isNotEmpty
          ? settings.currencySymbol.trim()
          : settings.currencyCode.trim();
      final nextNum = await _repository.nextSaleNumber();
      await _billFormatRepo.loadSettings();

      if (!mounted) return;
      setState(() {
        _companySettings = settings;
        _currencySymbol = symbol.isEmpty ? '₹' : symbol;
        _nextSaleNumber = nextNum;
      });
    } catch (_) {}
  }

  Future<void> _loadCategoriesAndCatalog() async {
    try {
      final cats = await _categoryRepo.getAllCategories();
      if (!mounted) return;
      setState(() {
        _categories = cats.where((c) => c.isActive).toList();
      });

      await _fetchCatalogProducts();

      // If catalogue is completely empty on fresh install, auto-seed demo data once
      if (_catalogProducts.isEmpty && !await _demoSeeder.isSeeded()) {
        await _demoSeeder.seedDemoData();
        final reCats = await _categoryRepo.getAllCategories();
        if (mounted) {
          setState(() {
            _categories = reCats.where((c) => c.isActive).toList();
          });
          await _fetchCatalogProducts();
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchCatalogProducts() async {
    setState(() => _catalogLoading = true);
    try {
      final items = await _repository.searchSellableItems(
        categoryId: _selectedCategoryId,
        limit: 100,
      );
      if (!mounted) return;
      setState(() {
        _catalogProducts = items;
        _catalogLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _catalogLoading = false);
    }
  }

  void _onCategorySelected(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    setState(() => _selectedCategoryId = categoryId);
    _fetchCatalogProducts();
  }

  // ──────────────────── SEARCH & BARCODE ────────────────────

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 200), () async {
      setState(() => _searching = true);
      try {
        final results = await _repository.searchSellableItems(
          query: trimmed,
          categoryId: _selectedCategoryId,
        );
        if (!mounted) return;
        setState(() {
          _searchResults = results;
          _searching = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _searching = false);
      }
    });
  }

  Future<void> _onBarcodeSubmitted(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return;

    _searchDebounce?.cancel();
    setState(() => _searchResults = []);

    try {
      final item = await _repository.findSellableItemByBarcode(code);
      if (!mounted) return;

      if (item == null) {
        _showErrorMessage('Product not found. Please add this product first.');
        _searchController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _searchController.text.length,
        );
        _searchFocusNode.requestFocus();
        return;
      }

      if (item.availableStock <= 0) {
        _showErrorMessage('Product "${item.displayName}" is out of stock.');
        _searchController.clear();
        setState(() => _searchResults = []);
        _searchFocusNode.requestFocus();
        return;
      }

      _addItemToCart(item);
      _searchController.clear();
      setState(() => _searchResults = []);
      _searchFocusNode.requestFocus();
    } on AmbiguousBarcodeException {
      _showErrorMessage('Multiple products match this barcode. Please select manually.');
    } on SalesValidationException catch (e) {
      _showErrorMessage(e.message);
    } catch (e) {
      _showErrorMessage('Failed to look up barcode: $e');
    }
  }

  void _addItemToCart(SellableItem item) {
    final existingIndex = _cartItems.indexWhere(
      (c) => c.sellableItem.itemKey == item.itemKey,
    );

    if (existingIndex >= 0) {
      final current = _cartItems[existingIndex];
      if (current.quantity + 1 > item.availableStock) {
        _showErrorMessage(
          'Insufficient stock for "${item.displayName}". Available stock: ${item.availableStock}.',
        );
        return;
      }
      setState(() {
        current.quantity += 1;
      });
    } else {
      if (item.availableStock < 1) {
        _showErrorMessage('Product "${item.displayName}" is out of stock.');
        return;
      }
      setState(() {
        _cartItems.add(PosCartItem(sellableItem: item, quantity: 1.0));
      });
    }
  }

  void _updateQuantity(int index, double newQty) {
    final item = _cartItems[index];
    if (newQty <= 0) {
      _removeItem(index);
      return;
    }

    if (newQty > item.sellableItem.availableStock) {
      _showErrorMessage(
        'Insufficient stock. Available stock: ${item.sellableItem.availableStock}.',
      );
      return;
    }

    setState(() {
      item.quantity = newQty;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  Future<void> _clearCart() async {
    if (_cartItems.isEmpty) return;
    final confirmed = await showClearCartDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _cartItems.clear();
        _billDiscountController.text = '0';
        _notesController.clear();
      });
      _searchFocusNode.requestFocus();
    }
  }

  // ──────────────────── TOTALS CALCULATION ────────────────────

  int get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.lineSubtotal);
  }

  int get _itemDiscounts {
    return _cartItems.fold(0, (sum, item) => sum + item.lineDiscount);
  }

  int get _billDiscount {
    final entered = double.tryParse(_billDiscountController.text.trim()) ?? 0.0;
    final paise = (entered * 100).round();
    final maxAllowed = max(0, _subtotal - _itemDiscounts);
    return min(maxAllowed, max(0, paise));
  }

  int get _totalDiscount => _itemDiscounts + _billDiscount;

  int get _totalTax {
    return _cartItems.fold(0, (sum, item) => sum + item.lineTaxAmount);
  }

  int get _grandTotal => max(0, _subtotal - _totalDiscount + _totalTax);

  int get _totalItemCount {
    return _cartItems.fold<int>(0, (sum, item) => sum + item.quantity.toInt());
  }

  // ──────────────────── CUSTOMER SELECTION ────────────────────

  Future<void> _pickCustomer() async {
    final customer = await showCustomerPickerDialog(
      context,
      currentCustomer: _selectedCustomer,
    );
    if (!mounted) return;
    setState(() => _selectedCustomer = customer);
  }

  // ──────────────────── PAYMENT & CHECKOUT FLOW ────────────────────

  Future<void> _startCheckout() async {
    if (_saving) return;

    if (_cartItems.isEmpty) {
      _showErrorMessage('Cannot complete sale with an empty cart.');
      return;
    }

    // Step 1: Open Payment Dialog with Cancel support
    final paymentResult = await showPaymentDialog(
      context,
      grandTotalPaise: _grandTotal,
      selectedCustomer: _selectedCustomer,
      currencySymbol: _currencySymbol,
      initialPaymentMethod: 'Cash',
      initialReceivedPaise: _grandTotal,
    );

    // If cancelled: zero database modifications, cart & customer preserved
    if (paymentResult == null) return;

    // Step 2: Confirm Payment -> Execute atomic sale transaction
    await _executeSale(paymentResult);
  }

  Future<void> _executeSale(PaymentDialogResult paymentResult) async {
    setState(() => _saving = true);

    try {
      final itemsInput = _cartItems.map((c) {
        return CreateSaleItemInput(
          productId: c.sellableItem.productId,
          variantId: c.sellableItem.variantId,
          productName: c.sellableItem.productName,
          variantName: c.sellableItem.variantName,
          barcode: c.sellableItem.barcode,
          unitId: c.sellableItem.unitId,
          unitName: c.sellableItem.unitName,
          quantity: c.quantity,
          unitPrice: c.effectiveUnitPrice,
          discount: c.lineDiscount,
          taxRate: c.sellableItem.taxRate,
        );
      }).toList();

      final createdSale = await _repository.createSale(
        customerId: _selectedCustomer?.id,
        saleDate: DateTime.now(),
        items: itemsInput,
        billDiscount: _billDiscount,
        paymentMethod: paymentResult.paymentMethod,
        amountReceived: paymentResult.amountReceived,
        notes: paymentResult.notes ??
            (_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _cartItems.clear();
        _selectedCustomer = null;
        _billDiscountController.text = '0';
        _notesController.clear();
        _searchController.clear();
        _searchResults = [];
      });

      _loadSettingsAndNextNumber();
      _fetchCatalogProducts(); // Re-sync quick-selection stock counts

      // Step 3: Open Bill Preview (Thermal 80mm/58mm receipt)
      await showBillPreviewDialog(
        context,
        sale: createdSale,
        currencySymbol: _currencySymbol,
        companySettings: _companySettings,
        onNewSale: () {
          _searchFocusNode.requestFocus();
        },
      );
    } on InsufficientStockException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showErrorMessage(e.message);
    } on SalesValidationException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showErrorMessage(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showErrorMessage('Unable to complete sale. No changes were saved. ($e)');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatAmount(int paise) {
    return '$_currencySymbol${(paise / 100).toStringAsFixed(2)}';
  }

  // ──────────────────── UI BUILD ────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f12) {
          _startCheckout();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Column(
          children: [
            // Compact Module Header at top of right area
            _buildHeader(textTheme),

            // Main Body: Left = Product/Category Area, Right = Cart & Sale Summary
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 850;

                  if (isDesktop) {
                    // Right panel takes ~32% or clamped between 340 and 420px
                    final rightWidth = (constraints.maxWidth * 0.32).clamp(340.0, 420.0);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Area: 100% Product Selection (Search + Categories + Product Cards Grid)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
                            child: _buildProductArea(textTheme),
                          ),
                        ),

                        // Right Area: Cart + Sale Summary + Pay F12
                        SizedBox(
                          width: rightWidth,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
                            child: _buildRightCartSummaryPanel(textTheme),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Narrow / Mobile View: Tabs or scrollable stack
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildProductArea(textTheme),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 5,
                            child: _buildRightCartSummaryPanel(textTheme),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────── COMPACT MODULE HEADER ────────────────────

  Widget _buildHeader(TextTheme textTheme) {
    final formattedDate =
        '${_saleDate.day.toString().padLeft(2, '0')}/${_saleDate.month.toString().padLeft(2, '0')}/${_saleDate.year} '
        '${_saleDate.hour.toString().padLeft(2, '0')}:${_saleDate.minute.toString().padLeft(2, '0')}';

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // Left: Sales POS title & Sale number
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.point_of_sale_rounded,
                  color: AppTheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sales POS',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.hover,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  _nextSaleNumber.isNotEmpty ? 'Bill: $_nextSaleNumber' : 'New Sale',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Center: Date & Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.hover,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Right: Customer Selector
          Flexible(
            child: InkWell(
              onTap: _pickCustomer,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedCustomer != null ? AppTheme.selected : AppTheme.hover,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _selectedCustomer != null ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _selectedCustomer != null ? Icons.person_rounded : Icons.directions_walk_rounded,
                      size: 15,
                      color: _selectedCustomer != null ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _selectedCustomer?.customerName ?? 'Walk-in Customer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                          color: _selectedCustomer != null ? AppTheme.primary : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ),
          if (_selectedCustomer != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => setState(() => _selectedCustomer = null),
              icon: const Icon(Icons.clear_rounded, size: 16),
              tooltip: 'Reset to Walk-in Customer',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────── LEFT PRODUCT AREA ────────────────────

  Widget _buildProductArea(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Search / Barcode Bar
        _buildSearchSection(textTheme),
        const SizedBox(height: 10),

        // 2. Category Chips Bar
        _buildCategoryBar(),
        const SizedBox(height: 10),

        // 3. Multi-Column Product Cards Grid (Dedicates the rest of space to products)
        Expanded(
          child: _buildProductCatalogGrid(textTheme),
        ),
      ],
    );
  }

  Widget _buildSearchSection(TextTheme textTheme) {
    return ContentPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Scan barcode or search by product / variant name...',
                    prefixIcon: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primary, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchResults = []);
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: _onBarcodeSubmitted,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _onBarcodeSubmitted(_searchController.text),
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                label: const Text('Add / Scan'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),

          // Search Dropdown Overlay
          if (_searching) ...[
            const SizedBox(height: 4),
            const LinearProgressIndicator(),
          ] else if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 4),
            Material(
              color: AppTheme.surface,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.border),
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    final isOos = item.isOutOfStock;

                    return ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.displayName,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            _formatAmount(item.sellingPrice),
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          if (item.barcode != null && item.barcode!.isNotEmpty)
                            Text(
                              'Barcode: ${item.barcode} • ',
                              style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                            ),
                          Text(
                            isOos ? 'Out of Stock' : 'Stock: ${item.availableStock} ${item.unitSymbol}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOos ? AppTheme.danger : AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.add_circle_outline_rounded, size: 20),
                      onTap: () {
                        _addItemToCart(item);
                        _searchController.clear();
                        setState(() => _searchResults = []);
                        _searchFocusNode.requestFocus();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(
            label: 'All Products',
            isSelected: _selectedCategoryId == null,
            onTap: () => _onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          ..._categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryChip(
                label: cat.categoryName,
                isSelected: _selectedCategoryId == cat.id,
                onTap: () => _onCategorySelected(cat.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppTheme.textPrimary,
      ),
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.border,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    );
  }

  Widget _buildProductCatalogGrid(TextTheme textTheme) {
    if (_catalogLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_catalogProducts.isEmpty) {
      return ContentPanel(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 40, color: AppTheme.textSecondary),
              const SizedBox(height: 12),
              Text(
                'No products available in this category.',
                style: textTheme.titleSmall?.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await _demoSeeder.seedDemoData(force: true);
                  _loadCategoriesAndCatalog();
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                label: const Text('Load Demo Products'),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive column count based on available width
        final int crossAxisCount = (constraints.maxWidth / 165).floor().clamp(2, 6);

        return GridView.builder(
          itemCount: _catalogProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final item = _catalogProducts[index];
            return _buildProductCard(item);
          },
        );
      },
    );
  }

  Widget _buildProductCard(SellableItem item) {
    final isOos = item.isOutOfStock;
    final isLowStock = !isOos && item.availableStock <= 5;

    return Material(
      color: isOos ? AppTheme.hover : AppTheme.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isOos ? null : () => _addItemToCart(item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isOos
                  ? AppTheme.border
                  : isLowStock
                      ? AppTheme.warning.withValues(alpha: 0.5)
                      : AppTheme.border,
            ),
            boxShadow: isOos
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row: Product Icon + Stock Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isOos ? AppTheme.border : AppTheme.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 14,
                      color: isOos ? AppTheme.textSecondary : AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isOos
                            ? AppTheme.danger.withValues(alpha: 0.12)
                            : isLowStock
                                ? AppTheme.warning.withValues(alpha: 0.15)
                                : AppTheme.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isOos
                            ? 'Out of Stock'
                            : isLowStock
                                ? 'Low (${item.availableStock})'
                                : 'Stock: ${item.availableStock}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isOos
                              ? AppTheme.danger
                              : isLowStock
                                  ? AppTheme.warning
                                  : AppTheme.success,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Middle: Product & Variant Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isOos ? AppTheme.textSecondary : AppTheme.textPrimary,
                    ),
                  ),
                  if (item.variantName != null && item.variantName!.isNotEmpty)
                    Text(
                      item.variantName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                ],
              ),

              // Bottom row: Selling Price & Add Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _formatAmount(item.sellingPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isOos ? AppTheme.textSecondary : AppTheme.primary,
                      ),
                    ),
                  ),
                  Icon(
                    isOos ? Icons.block_rounded : Icons.add_circle_rounded,
                    size: 18,
                    color: isOos ? AppTheme.textSecondary : AppTheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── RIGHT CART & SALE SUMMARY PANEL ────────────────────

  Widget _buildRightCartSummaryPanel(TextTheme textTheme) {
    return ContentPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Current Sale / Cart with item count & Clear button
          Row(
            children: [
              const Icon(Icons.shopping_cart_rounded, size: 18, color: AppTheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _cartItems.isEmpty
                      ? 'Current Sale'
                      : 'Current Sale ($_totalItemCount items)',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              if (_cartItems.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearCart,
                  icon: const Icon(Icons.clear_all_rounded, size: 14),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.danger,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
          const Divider(height: 16, color: AppTheme.border),

          // Scrollable Cart Items Section (Scrolls internally)
          Expanded(
            child: _cartItems.isEmpty
                ? _buildEmptyCartPlaceholder(textTheme)
                : _buildCartItemList(textTheme),
          ),

          const Divider(height: 16, color: AppTheme.border),

          // Financial Summary (Fixed at bottom)
          _buildSummaryRow('Subtotal', _formatAmount(_subtotal), textTheme),
          const SizedBox(height: 6),

          // Bill Discount Input
          Row(
            children: [
              Expanded(
                child: Text('Bill Discount (₹)', style: textTheme.bodySmall),
              ),
              SizedBox(
                width: 90,
                height: 32,
                child: TextField(
                  controller: _billDiscountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),

          if (_totalDiscount > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Total Discount',
              '-${_formatAmount(_totalDiscount)}',
              textTheme,
              color: AppTheme.success,
            ),
          ],
          const SizedBox(height: 6),

          // Tax
          _buildSummaryRow('Tax', _formatAmount(_totalTax), textTheme),
          const SizedBox(height: 10),

          // Grand Total Hero Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Grand Total',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatAmount(_grandTotal),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pay / Complete Sale Button (F12)
          FilledButton.icon(
            onPressed: _saving ? null : _startCheckout,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.payment_rounded, size: 20),
            label: Text(
              _saving ? 'Saving Sale...' : 'Pay / Complete Sale (F12)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartPlaceholder(TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.hover,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 24,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cart is empty',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan/search or click a\nproduct to add it.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemList(TextTheme textTheme) {
    return ListView.separated(
      itemCount: _cartItems.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.border),
      itemBuilder: (context, index) {
        final item = _cartItems[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Line 1: Product Name & Line Total
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.sellableItem.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (item.sellableItem.variantName != null &&
                            item.sellableItem.variantName!.isNotEmpty)
                          Text(
                            item.sellableItem.variantName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatAmount(item.lineTotal),
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Line 2: Unit Price × Qty Controls [-] [Qty] [+] and Remove Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.quantity == item.quantity.roundToDouble() ? item.quantity.toInt() : item.quantity} × ${_formatAmount(item.effectiveUnitPrice)}',
                    style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary, fontSize: 11),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minus button
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        onPressed: () => _updateQuantity(index, item.quantity - 1),
                      ),
                      // Qty text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          item.quantity == item.quantity.roundToDouble()
                              ? item.quantity.toInt().toString()
                              : item.quantity.toString(),
                          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      // Plus button
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        onPressed: () => _updateQuantity(index, item.quantity + 1),
                      ),
                      const SizedBox(width: 4),
                      // Delete item button
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.danger, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        tooltip: 'Remove',
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    TextTheme textTheme, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
