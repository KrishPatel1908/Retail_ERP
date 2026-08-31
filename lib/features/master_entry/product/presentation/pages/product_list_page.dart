import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/page_header.dart';
import '../../../../../shared/widgets/search_field.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/exceptions/product_exceptions.dart';
import '../../services/product_validator.dart';
import '../widgets/product_detail_dialog.dart';
import '../widgets/product_delete_dialog.dart';
import '../widgets/variant_edit_dialog.dart';

/// Product Master list page with server-side search, filtering, pagination,
/// and expandable rows to show product variants inline.
class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.onAddProduct,
    required this.onEditProduct,
  });

  final VoidCallback onAddProduct;
  final ValueChanged<ProductEntity> onEditProduct;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final ProductRepository _repository;

  List<ProductEntity> _products = const [];
  int _totalCount = 0;
  bool _loading = true;
  Object? _error;

  String _query = '';
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  // Expanded product IDs (for variant display).
  final Set<int> _expandedProductIds = {};

  // Server-side filter state.
  int? _categoryId;
  int? _subCategoryId;
  int? _brandId;
  int? _minPrice;
  int? _maxPrice;
  DateTime? _createdFrom;
  DateTime? _createdTo;
  int _page = 1;
  int _pageSize = 25;
  ProductSortColumn _sortColumn = ProductSortColumn.name;
  bool _sortAscending = true;

  // Filter dropdown data.
  List<({int id, String name})> _categories = const [];
  List<({int id, String name})> _subCategories = const [];
  List<({int id, String name})> _brands = const [];

  // Filter bar expansion.
  bool _filtersExpanded = false;

  // Inline variant creation state.
  int? _addingVariantForProductId;
  final _variantNameController = TextEditingController();
  final _variantPriceController = TextEditingController();
  final _variantPurchasePriceController = TextEditingController();
  final _variantMrpController = TextEditingController();
  final _variantWholesalePriceController = TextEditingController();
  final _variantBarcodeController = TextEditingController();
  final _variantHsnCodeController = TextEditingController();
  DateTime? _variantExpiryDate;
  final _variantNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = ProductRepository();
    _load();
    _loadFilterOptions();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _variantNameController.dispose();
    _variantPriceController.dispose();
    _variantPurchasePriceController.dispose();
    _variantMrpController.dispose();
    _variantWholesalePriceController.dispose();
    _variantBarcodeController.dispose();
    _variantHsnCodeController.dispose();
    _variantNotesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final requestId = ++_searchRequestId;
    setState(() {
      _loading = _products.isEmpty;
      _error = null;
    });
    try {
      final result = await _repository.fetchPage(
        query: _query,
        filters: ProductFilters(
          categoryId: _categoryId,
          subCategoryId: _subCategoryId,
          brandId: _brandId,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          createdFrom: _createdFrom,
          createdTo: _createdTo,
        ),
        sort: _sortColumn,
        sortAscending: _sortAscending,
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _products = result.items;
        _totalCount = result.totalCount;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final results = await Future.wait([
        _repository.distinctCategories(),
        _repository.distinctSubCategories(categoryId: _categoryId),
        _repository.distinctBrands(),
      ]);
      if (!mounted) return;
      setState(() {
        _categories = results[0];
        _subCategories = results[1];
        _brands = results[2];
      });
    } catch (_) {
      // Filter dropdowns stay empty; list still loads.
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim();
      _page = 1;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), _load);
  }

  void _applyFilters() {
    setState(() => _page = 1);
    _load();
    _loadFilterOptions();
  }

  void _clearFilters() {
    setState(() {
      _categoryId = null;
      _subCategoryId = null;
      _brandId = null;
      _minPrice = null;
      _maxPrice = null;
      _createdFrom = null;
      _createdTo = null;
      _page = 1;
    });
    _load();
    _loadFilterOptions();
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumn = _sortForIndex(columnIndex);
      _sortAscending = ascending;
      _page = 1;
    });
    _load();
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  void _onPageSizeChanged(int pageSize) {
    setState(() {
      _pageSize = pageSize;
      _page = 1;
    });
    _load();
  }

  void _toggleExpand(int productId) {
    setState(() {
      if (_expandedProductIds.contains(productId)) {
        _expandedProductIds.remove(productId);
        // Cancel inline variant creation if expanding is toggled off.
        if (_addingVariantForProductId == productId) {
          _addingVariantForProductId = null;
          _clearVariantFields();
        }
      } else {
        _expandedProductIds.add(productId);
      }
    });
  }

  void _startInlineVariantCreation(int productId) {
    setState(() {
      _addingVariantForProductId = productId;
      _clearVariantFields();
    });
  }

  void _cancelInlineVariantCreation() {
    setState(() {
      _addingVariantForProductId = null;
      _clearVariantFields();
    });
  }

  void _clearVariantFields() {
    _variantNameController.clear();
    _variantPriceController.clear();
    _variantPurchasePriceController.clear();
    _variantMrpController.clear();
    _variantWholesalePriceController.clear();
    _variantBarcodeController.clear();
    _variantHsnCodeController.clear();
    _variantExpiryDate = null;
    _variantNotesController.clear();
  }

  Future<void> _saveInlineVariant(int productId) async {
    final name = _variantNameController.text.trim();
    final price = _variantPriceController.text.trim();
    final purchasePrice = _variantPurchasePriceController.text.trim();
    final mrp = _variantMrpController.text.trim();
    final wholesalePrice = _variantWholesalePriceController.text.trim();
    final barcode = _variantBarcodeController.text.trim();
    final hsnCode = _variantHsnCodeController.text.trim();
    final notes = _variantNotesController.text.trim();

    final nameErr = ProductValidator.validateVariantName(name);
    final priceErr = ProductValidator.validateVariantSellingPrice(price);
    final purchaseErr =
        ProductValidator.validatePurchasePrice(purchasePrice);
    final mrpErr = ProductValidator.validateMrp(mrp);
    final wholesaleErr =
        ProductValidator.validateWholesalePrice(wholesalePrice);
    final barcodeErr = ProductValidator.validateBarcode(barcode);
    final hsnErr = ProductValidator.validateHsnCode(hsnCode);

    final firstError = nameErr ??
        priceErr ??
        purchaseErr ??
        mrpErr ??
        wholesaleErr ??
        barcodeErr ??
        hsnErr;

    if (firstError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(firstError),
        ));
      return;
    }

    try {
      await _repository.createVariant(
        productId,
        variantName: name,
        sellingPrice: ProductValidator.parseRupeesToPaise(price) ?? 0,
        purchasePrice: ProductValidator.parseRupeesToPaise(purchasePrice),
        mrp: ProductValidator.parseRupeesToPaise(mrp),
        wholesalePrice: ProductValidator.parseRupeesToPaise(wholesalePrice),
        barcode: barcode.isEmpty ? null : barcode,
        hsnCode: hsnCode.isEmpty ? null : hsnCode,
        expiryDate: _variantExpiryDate,
        notes: notes.isEmpty ? null : notes,
      );

      if (!mounted) return;
      _showSnackBar('Variant added successfully.');
      _cancelInlineVariantCreation();
      await _load();
    } on ProductDuplicateException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to add variant. Please try again.');
    }
  }

  Future<void> _confirmDelete(ProductEntity product) async {
    final confirmed = await showProductDeleteConfirmDialog(
      context,
      productName: product.productName,
      hasVariants: product.hasVariants,
      variantCount: product.variants.length,
    );
    if (!confirmed || !mounted) return;

    try {
      await _repository.deleteProduct(product.id);
      if (!mounted) return;
      _expandedProductIds.remove(product.id);
      _showSnackBar('Product deleted successfully.');
      if (_products.length == 1 && _page > 1) {
        setState(() => _page -= 1);
      }
      await _load();
      await _loadFilterOptions();
    } on ProductInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } on AppDatabaseException catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to delete product. ${error.message}');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete product. Please try again.');
    }
  }

  Future<void> _deleteVariant(int variantId) async {
    final confirmed = await showVariantDeleteConfirmDialog(context);
    if (!confirmed || !mounted) return;

    try {
      await _repository.deleteVariant(variantId);
      if (!mounted) return;
      _showSnackBar('Variant deleted successfully.');
      await _load();
    } on ProductInUseException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to delete variant. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showProductDetails(ProductEntity product) {
    showProductDetailDialog(
      context,
      product: product,
      onEdit: () {
        Navigator.pop(context);
        widget.onEditProduct(product);
      },
    );
  }

  bool get _hasActiveFilters =>
      _categoryId != null ||
      _subCategoryId != null ||
      _brandId != null ||
      _minPrice != null ||
      _maxPrice != null ||
      _createdFrom != null ||
      _createdTo != null;

  int get _sortColumnIndex => switch (_sortColumn) {
    ProductSortColumn.code => 1,
    ProductSortColumn.name => 3,
    ProductSortColumn.sellingPrice => 4,
    ProductSortColumn.expiryDate => 5,
    ProductSortColumn.category => 6,
    ProductSortColumn.brand => 7,
    ProductSortColumn.createdAt => 10,
  };

  static ProductSortColumn _sortForIndex(int index) => switch (index) {
    1 => ProductSortColumn.code,
    3 => ProductSortColumn.name,
    4 => ProductSortColumn.sellingPrice,
    5 => ProductSortColumn.expiryDate,
    6 => ProductSortColumn.category,
    7 => ProductSortColumn.brand,
    10 => ProductSortColumn.createdAt,
    _ => ProductSortColumn.name,
  };

  Future<void> _openEditVariantDialog(ProductVariantEntity variant) async {
    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => VariantEditDialog(
        variant: variant,
        repository: _repository,
      ),
    );

    if (updated == true && mounted) {
      _showSnackBar('Variant updated successfully.');
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Product Master',
              description: 'Manage the products your business sells.',
              breadcrumbs: const ['Master Entry', 'Product Master'],
              actions: [
                FilledButton.icon(
                  onPressed: widget.onAddProduct,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search + Filters bar.
            ContentPanel(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          hintText:
                              'Search product name, code, category, brand, or variant...',
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            setState(() => _filtersExpanded = !_filtersExpanded),
                        icon: Icon(
                          _filtersExpanded
                              ? Icons.filter_list_off_rounded
                              : Icons.filter_list_rounded,
                          size: 18,
                        ),
                        label: Text(_hasActiveFilters ? 'Filters ●' : 'Filters'),
                      ),
                      if (_hasActiveFilters) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear'),
                        ),
                      ],
                    ],
                  ),
                  if (_filtersExpanded) ...[
                    const SizedBox(height: 16),
                    _buildFiltersRow(colorScheme, textTheme),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Data table with expandable rows.
            Expanded(
              child: _error != null
                  ? EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load products',
                      message:
                          'Something went wrong while reading the database. Please try again.',
                      action: OutlinedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                      ),
                    )
                  : _buildExpandableTable(colorScheme, textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTable(ColorScheme colorScheme, TextTheme textTheme) {
    // Build a flat list of items: product rows + expanded variant rows.
    final List<Widget> rows = [];

    for (final product in _products) {
      final isExpanded = _expandedProductIds.contains(product.id);

      // Parent product row.
      rows.add(_buildParentRow(product, isExpanded, colorScheme, textTheme));

      // Expanded variant rows.
      if (isExpanded) {
        rows.add(_buildExpandedVariantSection(
          product,
          colorScheme,
          textTheme,
        ));
      }
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Content.
          Expanded(
            child: _loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Loading data...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _products.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: _query.isEmpty && !_hasActiveFilters
                            ? 'No products yet'
                            : 'No products found',
                        message: _query.isEmpty && !_hasActiveFilters
                            ? 'Click "Add Product" to create your first product.'
                            : 'Try a different search term or clear the filters.',
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1380,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeaderRow(colorScheme, textTheme),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: rows.length,
                                itemBuilder: (context, index) => rows[index],
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          // Pagination footer.
          if (!_loading)
            _buildPaginationFooter(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.hover,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // Expand indicator + Action
          SizedBox(
            width: 144,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Action',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Code
          SizedBox(
            width: 120,
            child: _buildSortableHeader(1, 'Code', textTheme),
          ),
          // Status
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Status',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Product Name
          Expanded(
            flex: 2,
            child: _buildSortableHeader(3, 'Product Name', textTheme),
          ),
          // Selling Price (placed aside Product Name)
          SizedBox(
            width: 110,
            child: _buildSortableHeader(4, 'Selling Price', textTheme,
                numeric: true),
          ),
          // Expiry Date (placed aside Selling Price)
          SizedBox(
            width: 110,
            child: _buildSortableHeader(5, 'Expiry Date', textTheme),
          ),
          // Category
          Expanded(
            flex: 1,
            child: _buildSortableHeader(6, 'Category', textTheme),
          ),
          // Brand
          Expanded(
            flex: 1,
            child: _buildSortableHeader(7, 'Brand', textTheme),
          ),
          // Unit
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Unit',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Tax
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Tax',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          // Created Date
          SizedBox(
            width: 110,
            child: _buildSortableHeader(10, 'Created Date', textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(
    int index,
    String label,
    TextTheme textTheme, {
    bool numeric = false,
  }) {
    final isSorted = _sortColumnIndex == index;
    final align = numeric ? Alignment.centerRight : Alignment.centerLeft;

    return InkWell(
      onTap: () {
        final ascending =
            isSorted ? !_sortAscending : true;
        _onSort(index, ascending);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: align,
        child: Row(
          mainAxisSize: numeric ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: isSorted ? AppTheme.primary : AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isSorted
                  ? (_sortAscending
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded)
                  : Icons.unfold_more_rounded,
              size: 14,
              color: isSorted ? AppTheme.primary : AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentRow(
    ProductEntity product,
    bool isExpanded,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _toggleExpand(product.id),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isExpanded ? AppTheme.selected : null,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              // Expand icon + Actions
              SizedBox(
                width: 144,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_right_rounded,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      _ActionIcon(
                        icon: Icons.visibility_outlined,
                        tooltip: 'View',
                        onTap: () => _showProductDetails(product),
                      ),
                      const SizedBox(width: 2),
                      _ActionIcon(
                        icon: Icons.edit_outlined,
                        tooltip: 'Edit',
                        onTap: () => widget.onEditProduct(product),
                      ),
                      const SizedBox(width: 2),
                      _ActionIcon(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Delete',
                        onTap: () => _confirmDelete(product),
                        color: AppTheme.danger,
                      ),
                    ],
                  ),
                ),
              ),
              // Code
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.productCode,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Status
              SizedBox(
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: product.isActive
                          ? AppTheme.success.withValues(alpha: 0.1)
                          : AppTheme.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.isActive ? 'Active' : 'Inactive',
                      style: textTheme.labelSmall?.copyWith(
                        color:
                            product.isActive ? AppTheme.success : AppTheme.danger,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              // Product Name
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textTheme.bodyMedium,
                      ),
                      if (product.hasVariants)
                        Text(
                          '${product.variants.length} variant(s)',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Selling Price (placed aside Product Name)
              SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    ProductValidator.formatCurrency(product.sellingPrice),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // Expiry Date (placed aside Selling Price)
              SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.expiryDate != null
                        ? '${product.expiryDate!.day.toString().padLeft(2, '0')}/${product.expiryDate!.month.toString().padLeft(2, '0')}/${product.expiryDate!.year}'
                        : '—',
                    style: textTheme.bodySmall,
                  ),
                ),
              ),
              // Category
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.categoryName ?? '—',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              // Brand
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.brandName ?? '—',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              // Unit
              SizedBox(
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(product.unitName ?? '—'),
                ),
              ),
              // Tax
              SizedBox(
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(product.taxCategoryName ?? '—'),
                ),
              ),
              // Created Date
              SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${product.createdAt.day.toString().padLeft(2, '0')}/${product.createdAt.month.toString().padLeft(2, '0')}/${product.createdAt.year}',
                    style: textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedVariantSection(
    ProductEntity product,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Variant table header.
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Variant Name',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Selling Price',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Purchase Price',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'MRP',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      'Wholesale',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Barcode',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      'Expiry Date',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Actions',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Existing variants.
            for (final variant in product.variants)
              _buildVariantRow(variant, colorScheme, textTheme),

            // Inline variant creation form.
            if (_addingVariantForProductId == product.id)
              _buildInlineVariantForm(product.id, colorScheme, textTheme),

            // Add Variant button (only when not in creation mode).
            if (_addingVariantForProductId != product.id)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _startInlineVariantCreation(product.id),
                    icon: const Icon(Icons.add_rounded, size: 14),
                    label: const Text(
                      'Add Variant',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantRow(
    ProductVariantEntity variant,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final expiryText = variant.expiryDate != null
        ? '${variant.expiryDate!.day.toString().padLeft(2, '0')}/${variant.expiryDate!.month.toString().padLeft(2, '0')}/${variant.expiryDate!.year}'
        : '—';

    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      variant.variantName,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                ProductValidator.formatCurrency(variant.sellingPrice),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                variant.purchasePrice != null
                    ? ProductValidator.formatCurrency(variant.purchasePrice!)
                    : '—',
                style: textTheme.bodySmall,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                variant.mrp != null
                    ? ProductValidator.formatCurrency(variant.mrp!)
                    : '—',
                style: textTheme.bodySmall,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                variant.wholesalePrice != null
                    ? ProductValidator.formatCurrency(variant.wholesalePrice!)
                    : '—',
                style: textTheme.bodySmall,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                variant.barcode ?? '—',
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(expiryText, style: textTheme.bodySmall),
            ),
          ),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionIcon(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit Variant',
                  onTap: () => _openEditVariantDialog(variant),
                  size: 16,
                ),
                const SizedBox(width: 4),
                _ActionIcon(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete Variant',
                  onTap: () => _deleteVariant(variant.id),
                  color: AppTheme.danger,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineVariantForm(
    int productId,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant Name
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantNameController,
                autofocus: true,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Variant name *',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Selling Price
          SizedBox(
            width: 90,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantPriceController,
                style: const TextStyle(fontSize: 13),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Sell ₹*',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Purchase Price
          SizedBox(
            width: 90,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantPurchasePriceController,
                style: const TextStyle(fontSize: 13),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Buy ₹',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // MRP
          SizedBox(
            width: 80,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantMrpController,
                style: const TextStyle(fontSize: 13),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'MRP ₹',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Wholesale Price
          SizedBox(
            width: 90,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantWholesalePriceController,
                style: const TextStyle(fontSize: 13),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Wholesale ₹',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Barcode
          SizedBox(
            width: 100,
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _variantBarcodeController,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Barcode',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Expiry Date
          SizedBox(
            width: 90,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _variantExpiryDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _variantExpiryDate = picked);
                }
              },
              child: Container(
                height: 36,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Text(
                  _variantExpiryDate != null
                      ? '${_variantExpiryDate!.day.toString().padLeft(2, '0')}/${_variantExpiryDate!.month.toString().padLeft(2, '0')}/${_variantExpiryDate!.year}'
                      : 'Expiry',
                  style: TextStyle(
                    fontSize: 13,
                    color: _variantExpiryDate != null
                        ? null
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Actions
          SizedBox(
            width: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_rounded, size: 18),
                  tooltip: 'Save Variant',
                  onPressed: () => _saveInlineVariant(productId),
                  color: AppTheme.primary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  tooltip: 'Cancel',
                  onPressed: _cancelInlineVariantCreation,
                  color: AppTheme.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(ColorScheme colorScheme, TextTheme textTheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final filterChildren = [
          _buildCategoryFilter(colorScheme, textTheme),
          _buildSubCategoryFilter(colorScheme, textTheme),
          _buildBrandFilter(colorScheme, textTheme),
          _buildPriceRangeFilter(colorScheme, textTheme),
          _buildCreatedDateFilter(colorScheme, textTheme),
        ];

        if (isWide) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: filterChildren
                .map((w) => SizedBox(width: 200, child: w))
                .toList(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < filterChildren.length; i++) ...[
              filterChildren[i],
              if (i < filterChildren.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCategoryFilter(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          initialValue: _categoryId,
          isDense: true,
          isExpanded: true,
          items: [
            const DropdownMenuItem<int>(
              child: Text('All Categories'),
            ),
            for (final c in _categories)
              DropdownMenuItem(value: c.id, child: Text(c.name)),
          ],
          onChanged: (value) {
            setState(() {
              _categoryId = value == _categories.firstOrNull?.id ? null : value;
              _subCategoryId = null;
            });
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildSubCategoryFilter(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sub Category',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          initialValue: _subCategoryId,
          isDense: true,
          isExpanded: true,
          items: [
            const DropdownMenuItem<int>(
              child: Text('All Sub Categories'),
            ),
            for (final s in _subCategories)
              DropdownMenuItem(value: s.id, child: Text(s.name)),
          ],
          onChanged: (value) {
            setState(() {
              _subCategoryId =
                  value == _subCategories.firstOrNull?.id ? null : value;
            });
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildBrandFilter(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          initialValue: _brandId,
          isDense: true,
          isExpanded: true,
          items: [
            const DropdownMenuItem<int>(
              child: Text('All Brands'),
            ),
            for (final b in _brands)
              DropdownMenuItem(value: b.id, child: Text(b.name)),
          ],
          onChanged: (value) {
            setState(() {
              _brandId = value == _brands.firstOrNull?.id ? null : value;
            });
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range (₹)',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Min',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: (value) {
                  _minPrice = int.tryParse(value) != null
                      ? int.parse(value) * 100
                      : null;
                },
                onSubmitted: (_) => _applyFilters(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('–', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Max',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: (value) {
                  _maxPrice = int.tryParse(value) != null
                      ? int.parse(value) * 100
                      : null;
                },
                onSubmitted: (_) => _applyFilters(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreatedDateFilter(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created Date',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                label: 'From',
                date: _createdFrom,
                onPicked: (d) => setState(() => _createdFrom = d),
                onCleared: () => setState(() => _createdFrom = null),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('–', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: _buildDateField(
                context,
                label: 'To',
                date: _createdTo,
                onPicked: (d) => setState(() => _createdTo = d),
                onCleared: () => setState(() => _createdTo = null),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime> onPicked,
    required VoidCallback onCleared,
  }) {
    final formatted = date == null
        ? ''
        : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onPicked(picked);
          _applyFilters();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          suffixIcon: date != null
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 14),
                  onPressed: () {
                    onCleared();
                    _applyFilters();
                  },
                )
              : null,
        ),
        child: Text(
          formatted.isEmpty ? label : formatted,
          style: TextStyle(
            fontSize: 13,
            color: formatted.isEmpty
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final total = _totalCount;
    final page = _page;
    final pageSize = _pageSize;

    final start = total == 0 ? 0 : ((page - 1) * pageSize) + 1;
    final end = (page * pageSize) > total ? total : (page * pageSize);
    final maxPage = (total / pageSize).ceil().clamp(1, 999999);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 500;
          if (isNarrow) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 20),
                  onPressed: (page > 1) ? () => _onPageChanged(page - 1) : null,
                  tooltip: 'Previous page',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Page $page of $maxPage',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 20),
                  onPressed: (page < maxPage)
                      ? () => _onPageChanged(page + 1)
                      : null,
                  tooltip: 'Next page',
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Showing $start to $end of $total entries',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Rows per page:', style: textTheme.bodySmall),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: pageSize,
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    items: const [10, 25, 50, 100].map((sz) {
                      return DropdownMenuItem<int>(
                        value: sz,
                        child: Text('$sz', style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) _onPageSizeChanged(val);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    onPressed: (page > 1) ? () => _onPageChanged(page - 1) : null,
                    tooltip: 'Previous page',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Page $page of $maxPage',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    onPressed: (page < maxPage)
                        ? () => _onPageChanged(page + 1)
                        : null,
                    tooltip: 'Next page',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Small action icon button for the table action column.
class _ActionIcon extends StatefulWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.size = 17,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  final double size;

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.color ?? AppTheme.textSecondary;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered
                  ? (widget.color != null
                      ? widget.color!.withValues(alpha: 0.1)
                      : AppTheme.primary.withValues(alpha: 0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: _hovered
                  ? (widget.color ?? AppTheme.primary)
                  : defaultColor,
            ),
          ),
        ),
      ),
    );
  }
}
