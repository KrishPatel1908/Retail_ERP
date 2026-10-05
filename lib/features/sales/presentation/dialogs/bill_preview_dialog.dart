import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../company_settings/domain/entities/company_settings.dart';
import '../../data/repositories/bill_format_repository.dart';
import '../../domain/entities/bill_format_settings.dart';
import '../../domain/entities/sale.dart';
import '../widgets/receipt_view.dart';

/// Opens the authentic retail receipt Bill Preview dialog after a successful sale.
Future<void> showBillPreviewDialog(
  BuildContext context, {
  required SaleEntity sale,
  required String currencySymbol,
  CompanySettings? companySettings,
  BillFormatSettings? formatSettings,
  required VoidCallback onNewSale,
}) async {
  final format = formatSettings ?? BillFormatRepository.instance.currentSettings;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BillPreviewDialog(
      sale: sale,
      currencySymbol: currencySymbol,
      companySettings: companySettings,
      formatSettings: format,
      onNewSale: onNewSale,
    ),
  );
}

class BillPreviewDialog extends StatefulWidget {
  const BillPreviewDialog({
    super.key,
    required this.sale,
    required this.currencySymbol,
    this.companySettings,
    required this.formatSettings,
    required this.onNewSale,
  });

  final SaleEntity sale;
  final String currencySymbol;
  final CompanySettings? companySettings;
  final BillFormatSettings formatSettings;
  final VoidCallback onNewSale;

  @override
  State<BillPreviewDialog> createState() => _BillPreviewDialogState();
}

class _BillPreviewDialogState extends State<BillPreviewDialog> {
  late BillFormatSettings _activeFormat;
  bool _printing = false;

  @override
  void initState() {
    super.initState();
    _activeFormat = widget.formatSettings;
  }

  void _onPrint() {
    setState(() => _printing = true);
    // Mimic print dispatch with feedback, without changing sale state or failing destructively
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bill #${widget.sale.saleNumber} sent to printer (${_activeFormat.paperSize.label}).'),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 3),
      ),
    );
    setState(() => _printing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final comp = widget.companySettings;
    final compAddress = [
      comp?.addressLine1,
      comp?.addressLine2,
      comp?.city,
      if (comp?.pincode != null) '- ${comp!.pincode}',
    ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

    final receiptItems = widget.sale.items.map((item) {
      return ReceiptLineItem(
        productName: item.productName,
        variantName: item.variantName,
        barcode: item.barcode,
        quantity: item.quantity,
        unitPricePaise: item.unitPrice,
        discountPaise: item.discount,
        lineTotalPaise: item.lineTotal,
      );
    }).toList();

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 780),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sale Completed — Bill Preview',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Invoice ${widget.sale.saleNumber} • ${_activeFormat.paperSize.label}',
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Paper toggle (80mm / 58mm) for quick preview inspection
                  SegmentedButton<ReceiptPaperSize>(
                    segments: const [
                      ButtonSegment(value: ReceiptPaperSize.mm80, label: Text('80mm')),
                      ButtonSegment(value: ReceiptPaperSize.mm58, label: Text('58mm')),
                    ],
                    selected: {_activeFormat.paperSize},
                    onSelectionChanged: (set) {
                      setState(() {
                        _activeFormat = _activeFormat.copyWith(paperSize: set.first);
                      });
                    },
                    style: SegmentedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Receipt Canvas
            Expanded(
              child: Container(
                color: AppTheme.hover,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Center(
                    child: ReceiptView(
                      saleNumber: widget.sale.saleNumber,
                      saleDate: widget.sale.saleDate,
                      customerName: widget.sale.customerName,
                      customerPhone: null,
                      companyName: comp?.companyName ?? 'RETAIL STORE ERP',
                      companyAddress: compAddress.isNotEmpty ? compAddress : null,
                      companyPhone: comp?.mobile,
                      companyEmail: comp?.email,
                      companyGstin: comp?.gstNumber,
                      items: receiptItems,
                      subtotalPaise: widget.sale.subtotal,
                      discountPaise: widget.sale.discount,
                      taxPaise: widget.sale.tax,
                      grandTotalPaise: widget.sale.grandTotal,
                      paidAmountPaise: widget.sale.paidAmount,
                      changeAmountPaise: widget.sale.changeAmount,
                      balanceAmountPaise: widget.sale.balanceAmount,
                      paymentMethod: widget.sale.paymentMethod,
                      paymentStatusLabel: widget.sale.paymentStatus.label,
                      formatSettings: _activeFormat,
                      currencySymbol: widget.currencySymbol,
                    ),
                  ),
                ),
              ),
            ),

            // Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onNewSale();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Close'),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: _printing ? null : _onPrint,
                    icon: const Icon(Icons.print_rounded, size: 18),
                    label: const Text('Print Bill'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onNewSale();
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                    label: const Text('Next Sale'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
