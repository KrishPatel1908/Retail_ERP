/// Status of a purchase return.
enum PurchaseReturnStatus {
  completed('COMPLETED', 'Completed'),
  reverted('REVERTED', 'Reverted');

  const PurchaseReturnStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static PurchaseReturnStatus fromDbValue(String value) {
    for (final status in values) {
      if (status.dbValue == value) return status;
    }
    return PurchaseReturnStatus.completed;
  }
}

/// Domain model of a purchase return.
///
/// Monetary values are stored as paise.
class PurchaseReturnEntity {
  const PurchaseReturnEntity({
    required this.id,
    required this.returnNumber,
    required this.originalPurchaseId,
    required this.originalPurchaseNumber,
    required this.originalInvoiceNumber,
    required this.supplierId,
    required this.supplierName,
    this.supplierCode,
    required this.returnDate,
    this.subtotal = 0,
    this.discount = 0,
    this.tax = 0,
    this.total = 0,
    this.notes,
    this.status = PurchaseReturnStatus.completed,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  final int id;
  final String returnNumber;
  final int originalPurchaseId;
  final String originalPurchaseNumber;
  final String? originalInvoiceNumber;
  final int supplierId;
  final String supplierName;
  final String? supplierCode;
  final DateTime returnDate;
  final int subtotal;
  final int discount;
  final int tax;
  final int total;
  final String? notes;
  final PurchaseReturnStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PurchaseReturnItemEntity> items;

  bool get isReverted => status == PurchaseReturnStatus.reverted;
}

/// Domain model of a purchase return line item.
///
/// Monetary values are stored as paise.
class PurchaseReturnItemEntity {
  const PurchaseReturnItemEntity({
    required this.id,
    required this.purchaseReturnId,
    required this.purchaseItemId,
    required this.productId,
    required this.productName,
    this.productCode,
    this.variantId,
    this.variantName,
    this.barcode,
    this.unitName,
    required this.returnQuantity,
    required this.purchasePrice,
    this.discount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.lineTotal = 0,
    required this.createdAt,
  });

  final int id;
  final int purchaseReturnId;
  final int purchaseItemId;
  final int productId;
  final String productName;
  final String? productCode;
  final int? variantId;
  final String? variantName;
  final String? barcode;
  final String? unitName;
  final int returnQuantity;
  final int purchasePrice;
  final int discount;
  final double taxRate;
  final int taxAmount;
  final int lineTotal;
  final DateTime createdAt;
}
