import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/utils/form_focus_controller.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../data/repositories/purchase_return_repository.dart';
import '../../domain/entities/purchase.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_service.dart';

/// A single return line being edited in the return form.
class _ReturnRow {
  _ReturnRow({
    required this.purchaseItem,
    required this.stock,
    required this.unitPurchasePrice,
    required this.unitTaxRate,
    required this.unitLineTotal,
  });

  final PurchaseItemEntity purchaseItem;
  final int stock;
  final int unitPurchasePrice;
  final double unitTaxRate;
  final int unitLineTotal;

  final quantityController = TextEditingController();
  FocusNode? focusNode;
  GlobalKey? containerKey;

  int get productId => purchaseItem.productId;
  int? get variantId => purchaseItem.variantId;

  int get enteredQuantity => int.tryParse(quantityController.text.trim()) ?? 0;

  int returnAmount(int qty) {
    if (qty <= 0) return 0;
    final lineSubtotal = qty * unitPurchasePrice;
    final origQty = purchaseItem.quantity;
    final origDisc = purchaseItem.discount;
    final lineDiscount = (origQty > 0 && origDisc > 0)
        ? (origDisc * qty / origQty).round()
        : 0;
    final taxable = lineSubtotal - lineDiscount;
    final lineTax = (taxable * unitTaxRate / 100).round();
    return taxable + lineTax;
  }

  void dispose() {
    quantityController.dispose();
    focusNode?.dispose();
  }
}

/// Purchase Return Entry page.
class CreatePurchaseReturnPage extends StatefulWidget {
  const CreatePurchaseReturnPage({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  State<CreatePurchaseReturnPage> createState() =>
      _CreatePurchaseReturnPageState();
}

class _CreatePurchaseReturnPageState extends State<CreatePurchaseReturnPage> {
  late final PurchaseReturnRepository _repository;
  late final FormFocusController _focusController;

  static const _fieldOrder = ['supplier', 'purchase', 'date', 'save'];

  // Selected values.
  int? _supplierId;
  int? _purchaseId;
  DateTime _returnDate = DateTime.now();

  // Dropdown data.
  List<({int id, String name})> _suppliers = const [];
  List<PurchaseEntity> _purchases = const [];
  List<_ReturnRow> _returnRows = [];

  bool _loadingSuppliers = true;
  bool _loadingPurchases = false;
  bool _loadingItems = false;

  Map<String, String?> _errors = const {};
  bool _saving = false;

  String _currencySymbol = '';

  // Computed totals from the return rows.
  int _subtotal = 0;
  int _totalDiscount = 0;
  int _totalTax = 0;

  @override
  void initState() {
    super.initState();
    _repository = PurchaseReturnRepository();
    _focusController = FormFocusController(_fieldOrder);
    _loadCurrencySymbol();
    _loadSuppliers();
  }

  Future<void> _loadCurrencySymbol() async {
    try {
      final settings = await CompanySettingsService().getSettings();
      if (!mounted) return;
      final symbol = settings.currencySymbol.trim();
      setState(() {
        _currencySymbol = symbol.isEmpty ? '₹' : symbol;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _currencySymbol = '₹');
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    for (final row in _returnRows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    setState(() => _loadingSuppliers = true);
    try {
      final suppliers = await _repository.distinctSuppliers();
      if (!mounted) return;
      setState(() {
        _suppliers = suppliers;
        _loadingSuppliers = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSuppliers = false);
    }
  }

  Future<void> _onSupplierChanged(int? supplierId) async {
    setState(() {
      _supplierId = supplierId;
      _purchaseId = null;
      _returnRows.clear();
      _subtotal = 0;
      _totalDiscount = 0;
      _totalTax = 0;
      _purchases = const [];
      _errors = const {};
    });
    if (supplierId == null) return;

    setState(() => _loadingPurchases = true);
    try {
      final purchases = await _repository.purchasesForSupplier(supplierId);
      if (!mounted) return;
      setState(() {
        _purchases = purchases;
        _loadingPurchases = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPurchases = false);
    }
  }

  Future<void> _onPurchaseChanged(int? purchaseId) async {
    _disposeRows();
    setState(() {
      _purchaseId = purchaseId;
      _returnRows.clear();
      _subtotal = 0;
      _totalDiscount = 0;
      _totalTax = 0;
      _errors = const {};
    });

    if (purchaseId == null) return;

    setState(() => _loadingItems = true);
    try {
      final items = await _repository.returnableItemsForPurchase(purchaseId);
      if (!mounted) return;
      setState(() {
        _returnRows = [
          for (final item in items)
            _ReturnRow(
              purchaseItem: item.purchaseItem,
              stock: item.currentStock,
              unitPurchasePrice: item.purchasePrice,
              unitTaxRate: item.taxRate,
              unitLineTotal: item.unitLineTotal,
            ),
        ];
        for (var i = 0; i < _returnRows.length; i++) {
          _returnRows[i].focusNode = FocusNode();
          _returnRows[i].containerKey = GlobalKey();
          _returnRows[i].quantityController.addListener(() {
            _recalculate();
          });
        }
        _loadingItems = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingItems = false);
    }
  }

  void _disposeRows() {
    for (final row in _returnRows) {
      row.dispose();
    }
  }

  void _recalculate() {
    if (!mounted) return;
    int subtotal = 0;
    int totalDiscount = 0;
    int totalTax = 0;

    for (final row in _returnRows) {
      final qty = row.enteredQuantity;
      if (qty <= 0) continue;
      final lineSubtotal = qty * row.unitPurchasePrice;
      final origQty = row.purchaseItem.quantity;
      final origDisc = row.purchaseItem.discount;
      final lineDiscount = (origQty > 0 && origDisc > 0)
          ? (origDisc * qty / origQty).round()
          : 0;
      final taxable = lineSubtotal - lineDiscount;
      final lineTax = (taxable * row.unitTaxRate / 100).round();
      subtotal += lineSubtotal;
      totalDiscount += lineDiscount;
      totalTax += lineTax;
    }

    setState(() {
      _subtotal = subtotal;
      _totalDiscount = totalDiscount;
      _totalTax = totalTax;
    });
  }

  void _validate() {
    final errors = <String, String?>{};

    if (_supplierId == null) {
      errors['supplier'] = 'Please select a supplier.';
    }
    if (_purchaseId == null) {
      errors['purchase'] = 'Please select an original purchase.';
    }

    if (_returnRows.isEmpty && _purchaseId != null) {
      errors['items'] = 'No items found for this purchase.';
    }

    bool hasPositiveQty = false;
    for (var i = 0; i < _returnRows.length; i++) {
      final row = _returnRows[i];
      final text = row.quantityController.text.trim();
      final qty = int.tryParse(text) ?? 0;
      final maxFromPurchase =
          row.purchaseItem.quantity - row.purchaseItem.returnedQuantity;

      if (text.isNotEmpty && int.tryParse(text) == null) {
        errors['qty_$i'] = 'Please enter a valid quantity.';
      } else if (qty < 0) {
        errors['qty_$i'] = 'Return quantity cannot be negative.';
      } else if (qty > row.stock) {
        errors['qty_$i'] =
            'Return quantity cannot exceed available stock ($qty > ${row.stock}).';
      } else if (qty > maxFromPurchase) {
        errors['qty_$i'] =
            'Return quantity cannot exceed purchased quantity ($qty > $maxFromPurchase).';
      } else if (qty > 0) {
        hasPositiveQty = true;
      }
    }

    if (_returnRows.isNotEmpty && !hasPositiveQty) {
      errors['items'] =
          'Please enter a return quantity for at least one product.';
    }

    setState(() => _errors = errors);
  }

  Future<void> _save() async {
    _validate();
    if (_errors.values.any((e) => e != null)) {
      if (_errors['items'] != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(_errors['items']!)));
      }
      return;
    }
    if (_saving) return;

    setState(() => _saving = true);
    try {
      final items = [
        for (final row in _returnRows)
          if (row.enteredQuantity > 0)
            PurchaseReturnItemInput(
              purchaseItemId: row.purchaseItem.id,
              productId: row.productId,
              variantId: row.variantId,
              returnQuantity: row.enteredQuantity,
              purchasePrice: row.unitPurchasePrice,
              discount:
                  (row.purchaseItem.quantity > 0 &&
                      row.purchaseItem.discount > 0)
                  ? (row.purchaseItem.discount *
                            row.enteredQuantity /
                            row.purchaseItem.quantity)
                        .round()
                  : 0,
              taxRate: row.unitTaxRate,
            ),
      ];

      await _repository.createReturn(
        originalPurchaseId: _purchaseId!,
        supplierId: _supplierId!,
        returnDate: _returnDate,
        items: items,
      );
      if (!mounted) return;
      setState(() => _saving = false);
      widget.onSave();
    } on PurchaseReturnValidationException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e, st) {
      debugPrint('Error saving purchase return: $e\n$st');
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Failed to save the return.')),
        );
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
              title: 'Purchase Return',
              description:
                  'Return purchased goods to a supplier from an original purchase.',
              breadcrumbs: const ['Purchase', 'Purchase Return'],
              actions: [
                OutlinedButton.icon(
                  onPressed: _saving ? null : widget.onCancel,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: Text(_saving ? 'Saving...' : 'Save Return'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDetailsPanel(textTheme),
                    const SizedBox(height: 16),
                    if (_purchaseId != null) ...[
                      _buildItemsPanel(textTheme, colorScheme),
                      const SizedBox(height: 16),
                      _buildSummaryPanel(textTheme, colorScheme),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPanel(TextTheme textTheme) {
    return ContentPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Return Information',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supplier*',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _supplierId,
                      isExpanded: true,
                      items: _loadingSuppliers
                          ? const []
                          : [
                              for (final s in _suppliers)
                                DropdownMenuItem(
                                  value: s.id,
                                  child: Text(s.name),
                                ),
                            ],
                      onChanged: _onSupplierChanged,
                      hint: _loadingSuppliers
                          ? const Text('Loading...')
                          : const Text('Select supplier'),
                      decoration: InputDecoration(
                        errorText: _errors['supplier'],
                        errorMaxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Purchase*',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _purchaseId,
                      isExpanded: true,
                      items: _loadingPurchases
                          ? const []
                          : [
                              for (final p in _purchases)
                                DropdownMenuItem(
                                  value: p.id,
                                  child: Text(
                                    '${p.purchaseNumber} · ${p.invoiceNumber ?? ''} · ${_formatDate(p.purchaseDate)} · ${_formatCurrency(p.total)}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                      onChanged: _onPurchaseChanged,
                      hint: _loadingPurchases
                          ? const Text('Loading...')
                          : _supplierId == null
                          ? const Text('Select supplier first')
                          : const Text('Select purchase'),
                      decoration: InputDecoration(
                        errorText: _errors['purchase'],
                        errorMaxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 220,
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _returnDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      helpText: 'Select return date',
                    );
                    if (picked != null) {
                      setState(() => _returnDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Return Date*',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputDecorator(
                        decoration: const InputDecoration(),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(_returnDate),
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_errors['items'] != null) ...[
            const SizedBox(height: 12),
            Text(
              _errors['items']!,
              style: textTheme.bodySmall?.copyWith(color: AppTheme.danger),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsPanel(TextTheme textTheme, ColorScheme colorScheme) {
    if (_loadingItems) {
      return const ContentPanel(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }

    if (_returnRows.isEmpty) {
      return ContentPanel(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No items found for this purchase.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return ContentPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Return Items',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              if (_errors['items'] != null)
                Text(
                  _errors['items']!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildItemsHeader(textTheme),
                for (var i = 0; i < _returnRows.length; i++)
                  _buildItemRow(
                    row: _returnRows[i],
                    index: i,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsHeader(TextTheme textTheme) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.hover,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _headerCell('Product', textTheme)),
          Expanded(flex: 2, child: _headerCell('Variant', textTheme)),
          SizedBox(width: 90, child: _headerCell('Barcode', textTheme)),
          SizedBox(
            width: 80,
            child: _headerCell('Purchased', textTheme, alignRight: true),
          ),
          SizedBox(
            width: 80,
            child: _headerCell('Stock', textTheme, alignRight: true),
          ),
          SizedBox(
            width: 90,
            child: _headerCell('Return Qty*', textTheme, alignRight: true),
          ),
          SizedBox(
            width: 90,
            child: _headerCell('Price', textTheme, alignRight: true),
          ),
          SizedBox(
            width: 70,
            child: _headerCell('Tax', textTheme, alignRight: true),
          ),
          SizedBox(
            width: 100,
            child: _headerCell('Return Amt', textTheme, alignRight: true),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(
    String text,
    TextTheme textTheme, {
    bool alignRight = false,
  }) {
    return Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildItemRow({
    required _ReturnRow row,
    required int index,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    final isEven = index % 2 == 0;
    final qty = row.enteredQuantity;
    final error = _errors['qty_$index'];

    return Container(
      key: row.containerKey,
      height: 64,
      color: isEven ? null : colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              row.purchaseItem.productName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              row.purchaseItem.variantName ?? '—',
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              row.purchaseItem.barcode ?? '—',
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '${row.purchaseItem.quantity}',
              textAlign: TextAlign.right,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '${row.stock}',
              textAlign: TextAlign.right,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              key: ValueKey('return-qty-$index'),
              controller: row.quantityController,
              focusNode: row.focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                errorText: error,
                errorMaxLines: 2,
              ),
              onSubmitted: (_) {
                final next = index + 1 < _returnRows.length ? index + 1 : 0;
                _returnRows[next].focusNode?.requestFocus();
              },
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              _formatCurrency(row.unitPurchasePrice),
              textAlign: TextAlign.right,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              '${row.unitTaxRate.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              qty > 0 ? _formatCurrency(row.returnAmount(qty)) : '—',
              textAlign: TextAlign.right,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel(TextTheme textTheme, ColorScheme colorScheme) {
    final grandTotal = _subtotal - _totalDiscount + _totalTax;
    return ContentPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _summaryRow('Subtotal', _formatCurrency(_subtotal), textTheme),
          _summaryRow(
            'Discount',
            '- ${_formatCurrency(_totalDiscount)}',
            textTheme,
          ),
          _summaryRow('Tax', _formatCurrency(_totalTax), textTheme),
          const SizedBox(height: 8),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: 8),
          _summaryRow(
            'Total Return Amount',
            _formatCurrency(grandTotal),
            textTheme,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    TextTheme textTheme, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 140,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return '$_currencySymbol$text';
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }
}
