/// Paper size options for retail receipt printing.
enum ReceiptPaperSize {
  mm80('80mm Thermal', 80, 380.0),
  mm58('58mm Thermal', 58, 290.0);

  const ReceiptPaperSize(this.label, this.widthMm, this.previewWidth);

  final String label;
  final int widthMm;
  final double previewWidth;

  static ReceiptPaperSize fromString(String? value) {
    if (value == '58mm' || value == 'mm58') return ReceiptPaperSize.mm58;
    return ReceiptPaperSize.mm80;
  }

  String get code => this == ReceiptPaperSize.mm58 ? '58mm' : '80mm';
}

/// The 4 distinct receipt layout templates supported by Retail ERP.
enum BillTemplateType {
  standard80('Standard 80mm', 'Professional retail receipt', ReceiptPaperSize.mm80),
  detailedGst80('Detailed GST 80mm', 'Detailed tax, HSN & customer info', ReceiptPaperSize.mm80),
  compact58('Compact 58mm', 'Compact thermal receipt', ReceiptPaperSize.mm58),
  simple80('Simple 80mm', 'Minimal fast receipt', ReceiptPaperSize.mm80);

  const BillTemplateType(this.label, this.description, this.defaultPaperSize);

  final String label;
  final String description;
  final ReceiptPaperSize defaultPaperSize;

  static BillTemplateType fromString(String? value) {
    if (value == 'detailedGst80' || value == 'detailed_gst_80') return BillTemplateType.detailedGst80;
    if (value == 'compact58' || value == 'compact_58') return BillTemplateType.compact58;
    if (value == 'simple80' || value == 'simple_80') return BillTemplateType.simple80;
    return BillTemplateType.standard80;
  }

  String get code => name;
}

/// Settings entity controlling what fields and formats appear on retail receipts.
class BillFormatSettings {
  const BillFormatSettings({
    this.templateType = BillTemplateType.standard80,
    this.paperSize = ReceiptPaperSize.mm80,
    this.showLogo = true,
    this.showCompanyName = true,
    this.showAddress = true,
    this.showPhone = true,
    this.showEmail = true,
    this.showGstin = true,
    this.showCustomer = true,
    this.showHsn = true,
    this.showBarcode = false,
    this.showTaxBreakdown = true,
    this.showDiscount = true,
    this.showPaymentDetails = true,
    this.footerMessage = 'Thank you for shopping with us! Visit again.',
    this.selectedPrinter,
  });

  final BillTemplateType templateType;
  final ReceiptPaperSize paperSize;
  final bool showLogo;
  final bool showCompanyName;
  final bool showAddress;
  final bool showPhone;
  final bool showEmail;
  final bool showGstin;
  final bool showCustomer;
  final bool showHsn;
  final bool showBarcode;
  final bool showTaxBreakdown;
  final bool showDiscount;
  final bool showPaymentDetails;
  final String footerMessage;
  final String? selectedPrinter;

  BillFormatSettings copyWith({
    BillTemplateType? templateType,
    ReceiptPaperSize? paperSize,
    bool? showLogo,
    bool? showCompanyName,
    bool? showAddress,
    bool? showPhone,
    bool? showEmail,
    bool? showGstin,
    bool? showCustomer,
    bool? showHsn,
    bool? showBarcode,
    bool? showTaxBreakdown,
    bool? showDiscount,
    bool? showPaymentDetails,
    String? footerMessage,
    String? selectedPrinter,
  }) {
    return BillFormatSettings(
      templateType: templateType ?? this.templateType,
      paperSize: paperSize ?? (templateType != null ? templateType.defaultPaperSize : this.paperSize),
      showLogo: showLogo ?? this.showLogo,
      showCompanyName: showCompanyName ?? this.showCompanyName,
      showAddress: showAddress ?? this.showAddress,
      showPhone: showPhone ?? this.showPhone,
      showEmail: showEmail ?? this.showEmail,
      showGstin: showGstin ?? this.showGstin,
      showCustomer: showCustomer ?? this.showCustomer,
      showHsn: showHsn ?? this.showHsn,
      showBarcode: showBarcode ?? this.showBarcode,
      showTaxBreakdown: showTaxBreakdown ?? this.showTaxBreakdown,
      showDiscount: showDiscount ?? this.showDiscount,
      showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
      footerMessage: footerMessage ?? this.footerMessage,
      selectedPrinter: selectedPrinter ?? this.selectedPrinter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templateType': templateType.code,
      'paperSize': paperSize.code,
      'showLogo': showLogo,
      'showCompanyName': showCompanyName,
      'showAddress': showAddress,
      'showPhone': showPhone,
      'showEmail': showEmail,
      'showGstin': showGstin,
      'showCustomer': showCustomer,
      'showHsn': showHsn,
      'showBarcode': showBarcode,
      'showTaxBreakdown': showTaxBreakdown,
      'showDiscount': showDiscount,
      'showPaymentDetails': showPaymentDetails,
      'footerMessage': footerMessage,
      if (selectedPrinter != null) 'selectedPrinter': selectedPrinter,
    };
  }

  factory BillFormatSettings.fromJson(Map<String, dynamic> json) {
    final tType = BillTemplateType.fromString(json['templateType'] as String?);
    return BillFormatSettings(
      templateType: tType,
      paperSize: json['paperSize'] != null
          ? ReceiptPaperSize.fromString(json['paperSize'] as String?)
          : tType.defaultPaperSize,
      showLogo: json['showLogo'] as bool? ?? true,
      showCompanyName: json['showCompanyName'] as bool? ?? true,
      showAddress: json['showAddress'] as bool? ?? true,
      showPhone: json['showPhone'] as bool? ?? true,
      showEmail: json['showEmail'] as bool? ?? true,
      showGstin: json['showGstin'] as bool? ?? true,
      showCustomer: json['showCustomer'] as bool? ?? true,
      showHsn: json['showHsn'] as bool? ?? true,
      showBarcode: json['showBarcode'] as bool? ?? false,
      showTaxBreakdown: json['showTaxBreakdown'] as bool? ?? true,
      showDiscount: json['showDiscount'] as bool? ?? true,
      showPaymentDetails: json['showPaymentDetails'] as bool? ?? true,
      footerMessage: json['footerMessage'] as String? ??
          'Thank you for shopping with us! Visit again.',
      selectedPrinter: json['selectedPrinter'] as String?,
    );
  }
}
