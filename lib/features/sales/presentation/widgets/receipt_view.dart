import 'package:flutter/material.dart';

import '../../domain/entities/bill_format_settings.dart';

/// The pure, reusable visual receipt widget used in both Bill Preview dialog and Live Settings preview.
///
/// Accurately renders an 80mm or 58mm thermal receipt with authentic paper aesthetics,
/// monospace numbers, dashed dividers, company details, customer info, item lines,
/// GST breakdown, totals in integer-paise precision, and customizable footer.
class ReceiptView extends StatelessWidget {
  const ReceiptView({
    super.key,
    required this.saleNumber,
    required this.saleDate,
    this.customerName,
    this.customerPhone,
    this.companyName = 'RETAIL STORE ERP',
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.companyGstin,
    required this.items,
    required this.subtotalPaise,
    this.discountPaise = 0,
    this.taxPaise = 0,
    required this.grandTotalPaise,
    required this.paidAmountPaise,
    this.changeAmountPaise = 0,
    this.balanceAmountPaise = 0,
    required this.paymentMethod,
    this.paymentStatusLabel = 'Paid',
    required this.formatSettings,
    this.currencySymbol = '₹',
  });

  final String saleNumber;
  final DateTime saleDate;
  final String? customerName;
  final String? customerPhone;

  final String companyName;
  final String? companyAddress;
  final String? companyPhone;
  final String? companyEmail;
  final String? companyGstin;

  final List<ReceiptLineItem> items;

  final int subtotalPaise;
  final int discountPaise;
  final int taxPaise;
  final int grandTotalPaise;
  final int paidAmountPaise;
  final int changeAmountPaise;
  final int balanceAmountPaise;

  final String paymentMethod;
  final String paymentStatusLabel;

  final BillFormatSettings formatSettings;
  final String currencySymbol;

  String _formatAmount(int paise) {
    return '$currencySymbol${(paise / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final is58mm = formatSettings.paperSize == ReceiptPaperSize.mm58 ||
        formatSettings.templateType == BillTemplateType.compact58;
    final template = is58mm
        ? (formatSettings.templateType == BillTemplateType.compact58
            ? BillTemplateType.compact58
            : BillTemplateType.compact58)
        : formatSettings.templateType;
    final contentWidth = is58mm
        ? ReceiptPaperSize.mm58.previewWidth
        : ReceiptPaperSize.mm80.previewWidth;

    return Center(
      child: Container(
        width: contentWidth,
        padding: EdgeInsets.symmetric(
          horizontal: is58mm ? 12 : 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: switch (template) {
          BillTemplateType.detailedGst80 => _buildDetailedGstLayout(),
          BillTemplateType.compact58 => _buildCompact58Layout(),
          BillTemplateType.simple80 => _buildSimple80Layout(),
          BillTemplateType.standard80 => _buildStandard80Layout(),
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // TEMPLATE 1: STANDARD 80mm
  // ══════════════════════════════════════════════════════════
  Widget _buildStandard80Layout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (formatSettings.showLogo) ...[
          Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black54, width: 1.5),
              ),
              child: const Icon(Icons.storefront_rounded, size: 22, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
        ],

        if (formatSettings.showCompanyName)
          Text(
            companyName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),

        if (formatSettings.showAddress && companyAddress != null && companyAddress!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            companyAddress!.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: Colors.black87, fontFamily: 'monospace'),
          ),
        ],

        if (formatSettings.showPhone && companyPhone != null && companyPhone!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'Phone: ${companyPhone!.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: Colors.black87, fontFamily: 'monospace'),
          ),
        ],

        if (formatSettings.showEmail && companyEmail != null && companyEmail!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'Email: ${companyEmail!.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: Colors.black87, fontFamily: 'monospace'),
          ),
        ],

        if (formatSettings.showGstin && companyGstin != null && companyGstin!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'GSTIN: ${companyGstin!.trim().toUpperCase()}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'monospace'),
          ),
        ],

        const SizedBox(height: 10),
        _buildDashedLine(),
        const SizedBox(height: 8),

        // Bill Information
        _buildReceiptRow('Invoice No:', saleNumber, false, isBold: true),
        _buildReceiptRow('Date & Time:', _formatDateTime(saleDate), false),

        if (formatSettings.showCustomer) ...[
          _buildReceiptRow(
            'Customer:',
            customerName?.trim().isNotEmpty == true ? customerName!.trim() : 'Walk-in Customer',
            false,
          ),
          if (customerPhone != null && customerPhone!.trim().isNotEmpty)
            _buildReceiptRow('Phone:', customerPhone!.trim(), false),
        ],

        const SizedBox(height: 8),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Items Header
        _buildItemTableHeader(false),
        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Items List
        ...items.asMap().entries.map((e) => _buildStandardItemRow(e.key + 1, e.value)),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Totals
        _buildReceiptRow('Subtotal', _formatAmount(subtotalPaise), false),
        if (formatSettings.showDiscount && discountPaise > 0) ...[
          const SizedBox(height: 2),
          _buildReceiptRow('Discount', '-${_formatAmount(discountPaise)}', false),
        ],
        if (formatSettings.showTaxBreakdown && taxPaise > 0) ...[
          const SizedBox(height: 2),
          _buildReceiptRow('CGST', _formatAmount(taxPaise ~/ 2), false),
          const SizedBox(height: 2),
          _buildReceiptRow('SGST', _formatAmount(taxPaise - (taxPaise ~/ 2)), false),
        ],

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Grand Total
        _buildGrandTotalRow(false),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Payment Details
        if (formatSettings.showPaymentDetails) ...[
          _buildReceiptRow('Payment Mode:', '$paymentMethod ($paymentStatusLabel)', false),
          _buildReceiptRow('Amount Paid:', _formatAmount(paidAmountPaise), false),
          if (changeAmountPaise > 0)
            _buildReceiptRow('Change Due:', _formatAmount(changeAmountPaise), false, isBold: true),
          if (balanceAmountPaise > 0)
            _buildReceiptRow('Outstanding:', _formatAmount(balanceAmountPaise), false, isBold: true),
          const SizedBox(height: 8),
          _buildDashedLine(),
        ],

        const SizedBox(height: 10),
        _buildFooter(false),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // TEMPLATE 2: DETAILED GST 80mm
  // ══════════════════════════════════════════════════════════
  Widget _buildDetailedGstLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top TAX INVOICE Badge
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
          ),
          child: const Text(
            'TAX INVOICE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontFamily: 'monospace',
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),

        if (formatSettings.showCompanyName)
          Text(
            companyName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),

        if (formatSettings.showAddress && companyAddress != null && companyAddress!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            companyAddress!.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black87, fontFamily: 'monospace'),
          ),
        ],

        if (formatSettings.showPhone && companyPhone != null && companyPhone!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'Tel: ${companyPhone!.trim()} | Email: ${companyEmail ?? "—"}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black87, fontFamily: 'monospace'),
          ),
        ],

        // GSTIN Box
        if (formatSettings.showGstin) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              border: Border.all(color: Colors.black38),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GSTIN:',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                ),
                Text(
                  (companyGstin != null && companyGstin!.trim().isNotEmpty)
                      ? companyGstin!.trim().toUpperCase()
                      : 'URP (Unregistered)',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Invoice Meta
        _buildReceiptRow('Invoice #:', saleNumber, false, isBold: true),
        _buildReceiptRow('Date & Time:', _formatDateTime(saleDate), false),
        _buildReceiptRow('Place of Supply:', 'State (24)', false),

        if (formatSettings.showCustomer) ...[
          const SizedBox(height: 4),
          _buildDashedLine(),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Billed To: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              Expanded(
                child: Text(
                  customerName?.trim().isNotEmpty == true ? customerName!.trim() : 'Walk-in Customer',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                ),
              ),
              if (customerPhone != null && customerPhone!.trim().isNotEmpty)
                Text('Mo: ${customerPhone!.trim()}', style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
            ],
          ),
        ],

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Detailed GST Item Table Header
        const Row(
          children: [
            SizedBox(width: 20, child: Text('#', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
            Expanded(flex: 5, child: Text('Item / HSN', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
            Expanded(flex: 2, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
            Expanded(flex: 3, child: Text('Rate', textAlign: TextAlign.right, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
            Expanded(flex: 3, child: Text('Taxable', textAlign: TextAlign.right, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
            Expanded(flex: 3, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
          ],
        ),
        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 4),

        // Detailed Items List
        ...items.asMap().entries.map((e) {
          final idx = e.key + 1;
          final item = e.value;
          final qtyStr = item.quantity == item.quantity.roundToDouble()
              ? item.quantity.toInt().toString()
              : item.quantity.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20, child: Text('$idx', style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
                    Expanded(
                      flex: 5,
                      child: Text(
                        item.displayName,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                      ),
                    ),
                    Expanded(flex: 2, child: Text(qtyStr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
                    Expanded(flex: 3, child: Text(_formatAmount(item.unitPricePaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
                    Expanded(flex: 3, child: Text(_formatAmount(item.lineTotalPaise - item.discountPaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
                    Expanded(flex: 3, child: Text(_formatAmount(item.lineTotalPaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                  ],
                ),
                if (formatSettings.showHsn && item.hsnCode != null && item.hsnCode!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('HSN: ${item.hsnCode}', style: const TextStyle(fontSize: 8.5, color: Colors.black54, fontFamily: 'monospace')),
                  ),
              ],
            ),
          );
        }),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // GST Tax Summary Matrix Box
        if (formatSettings.showTaxBreakdown && taxPaise > 0) ...[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'GST TAX BREAKDOWN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 4),
                _buildDashedLine(),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Expanded(child: Text('Taxable', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                    Expanded(child: Text('CGST', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                    Expanded(child: Text('SGST', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                    Expanded(child: Text('Total Tax', textAlign: TextAlign.right, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(child: Text(_formatAmount(subtotalPaise - discountPaise), style: const TextStyle(fontSize: 9, fontFamily: 'monospace'))),
                    Expanded(child: Text(_formatAmount(taxPaise ~/ 2), textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontFamily: 'monospace'))),
                    Expanded(child: Text(_formatAmount(taxPaise - (taxPaise ~/ 2)), textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontFamily: 'monospace'))),
                    Expanded(child: Text(_formatAmount(taxPaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Totals
        _buildReceiptRow('Taxable Amount:', _formatAmount(subtotalPaise), false),
        if (formatSettings.showDiscount && discountPaise > 0)
          _buildReceiptRow('Total Discount:', '-${_formatAmount(discountPaise)}', false),
        if (taxPaise > 0)
          _buildReceiptRow('Total Tax (GST):', _formatAmount(taxPaise), false),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        _buildGrandTotalRow(false),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Payment Mode
        if (formatSettings.showPaymentDetails) ...[
          _buildReceiptRow('Payment Method:', paymentMethod, false),
          _buildReceiptRow('Amount Tendered:', _formatAmount(paidAmountPaise), false),
          if (changeAmountPaise > 0)
            _buildReceiptRow('Balance Refunded:', _formatAmount(changeAmountPaise), false, isBold: true),
          if (balanceAmountPaise > 0)
            _buildReceiptRow('Balance Due:', _formatAmount(balanceAmountPaise), false, isBold: true),
          const SizedBox(height: 8),
          _buildDashedLine(),
        ],

        const SizedBox(height: 8),
        const Text(
          'Statutory Note: Certified that the particulars given above are true and correct.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 8.5, fontStyle: FontStyle.italic, color: Colors.black54, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 6),
        _buildFooter(false),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // TEMPLATE 3: COMPACT 58mm
  // ══════════════════════════════════════════════════════════
  Widget _buildCompact58Layout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (formatSettings.showCompanyName)
          Text(
            companyName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: Colors.black,
            ),
          ),

        if (formatSettings.showPhone && companyPhone != null && companyPhone!.trim().isNotEmpty) ...[
          const SizedBox(height: 1),
          Text(
            'Ph: ${companyPhone!.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.black87),
          ),
        ],

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(saleNumber, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace')),
            Text(_formatDateTime(saleDate), style: const TextStyle(fontSize: 9, fontFamily: 'monospace')),
          ],
        ),

        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 4),

        // Compact Items List: 2 lines per item
        ...items.map((item) {
          final qtyStr = item.quantity == item.quantity.roundToDouble()
              ? item.quantity.toInt().toString()
              : item.quantity.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$qtyStr × ${_formatAmount(item.unitPricePaise)}',
                      style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.black87),
                    ),
                    Text(
                      _formatAmount(item.lineTotalPaise),
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 4),

        // Totals
        _buildReceiptRow('Subtotal', _formatAmount(subtotalPaise), true),
        if (discountPaise > 0)
          _buildReceiptRow('Discount', '-${_formatAmount(discountPaise)}', true),
        if (taxPaise > 0)
          _buildReceiptRow('Tax', _formatAmount(taxPaise), true),

        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 4),

        _buildGrandTotalRow(true),

        const SizedBox(height: 4),
        _buildDashedLine(),
        const SizedBox(height: 4),

        if (formatSettings.showPaymentDetails) ...[
          _buildReceiptRow('Paid ($paymentMethod)', _formatAmount(paidAmountPaise), true),
          if (changeAmountPaise > 0)
            _buildReceiptRow('Change', _formatAmount(changeAmountPaise), true, isBold: true),
          const SizedBox(height: 6),
          _buildDashedLine(),
        ],

        const SizedBox(height: 8),
        _buildFooter(true),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // TEMPLATE 4: SIMPLE 80mm
  // ══════════════════════════════════════════════════════════
  Widget _buildSimple80Layout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (formatSettings.showCompanyName)
          Text(
            companyName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              color: Colors.black,
            ),
          ),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bill: $saleNumber', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            Text(_formatDateTime(saleDate), style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
          ],
        ),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        // Simple item list
        ...items.map((item) {
          final qtyStr = item.quantity == item.quantity.roundToDouble()
              ? item.quantity.toInt().toString()
              : item.quantity.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    item.displayName,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'monospace'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '× $qtyStr',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _formatAmount(item.lineTotalPaise),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),
        _buildDashedLine(),
        const SizedBox(height: 8),

        // Large Grand Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'NET AMOUNT',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
            ),
            Text(
              _formatAmount(grandTotalPaise),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
            ),
          ],
        ),

        const SizedBox(height: 6),
        _buildDashedLine(),
        const SizedBox(height: 6),

        if (formatSettings.showPaymentDetails)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mode: $paymentMethod', style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
              Text('Paid: ${_formatAmount(paidAmountPaise)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ],
          ),

        const SizedBox(height: 12),
        _buildFooter(false),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // HELPER SUBWIDGETS & FORMATTERS
  // ══════════════════════════════════════════════════════════

  Widget _buildGrandTotalRow(bool is58mm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'TOTAL',
            style: TextStyle(
              fontSize: is58mm ? 12 : 14,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: Colors.black,
            ),
          ),
        ),
        Text(
          _formatAmount(grandTotalPaise),
          style: TextStyle(
            fontSize: is58mm ? 12.5 : 15,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool is58mm) {
    return Column(
      children: [
        if (formatSettings.footerMessage.trim().isNotEmpty)
          Text(
            formatSettings.footerMessage.trim(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: is58mm ? 9 : 10,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
          ),
        const SizedBox(height: 4),
        Text(
          '*** THANK YOU ***',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: is58mm ? 8.5 : 9.5,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
            letterSpacing: 1,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.black45)),
            );
          }),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, bool is58mm, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: is58mm ? 9.5 : 10.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              fontFamily: 'monospace',
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: is58mm ? 9.5 : 10.5,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                fontFamily: 'monospace',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTableHeader(bool is58mm) {
    return const Row(
      children: [
        SizedBox(width: 20, child: Text('#', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
        Expanded(flex: 5, child: Text('Item', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
        Expanded(flex: 2, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
        Expanded(flex: 3, child: Text('Rate', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
        Expanded(flex: 3, child: Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
      ],
    );
  }

  Widget _buildStandardItemRow(int index, ReceiptLineItem item) {
    final qtyStr = item.quantity == item.quantity.roundToDouble()
        ? item.quantity.toInt().toString()
        : item.quantity.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 20, child: Text('$index', style: const TextStyle(fontSize: 9.5, color: Colors.black54, fontFamily: 'monospace'))),
              Expanded(
                flex: 5,
                child: Text(
                  item.displayName,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                ),
              ),
              Expanded(flex: 2, child: Text(qtyStr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
              Expanded(flex: 3, child: Text(_formatAmount(item.unitPricePaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontFamily: 'monospace'))),
              Expanded(flex: 3, child: Text(_formatAmount(item.lineTotalPaise), textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
            ],
          ),
          if (formatSettings.showHsn && item.hsnCode != null && item.hsnCode!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('HSN: ${item.hsnCode}', style: const TextStyle(fontSize: 8.5, color: Colors.black54, fontFamily: 'monospace')),
            ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  static String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  static String _formatDateTime(DateTime dt) => '${_formatDate(dt)} ${_formatTime(dt)}';
}

/// Helper model for receipt line items.
class ReceiptLineItem {
  const ReceiptLineItem({
    required this.productName,
    this.variantName,
    this.barcode,
    this.hsnCode,
    required this.quantity,
    required this.unitPricePaise,
    this.discountPaise = 0,
    required this.lineTotalPaise,
    this.unitSymbol = 'pcs',
  });

  final String productName;
  final String? variantName;
  final String? barcode;
  final String? hsnCode;
  final double quantity;
  final int unitPricePaise;
  final int discountPaise;
  final int lineTotalPaise;
  final String unitSymbol;

  String get displayName => (variantName != null && variantName!.trim().isNotEmpty)
      ? '$productName ($variantName)'
      : productName;
}
