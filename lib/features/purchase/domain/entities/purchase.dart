/// Payment status of a purchase.
enum PurchasePaymentStatus {
  unpaid('UNPAID', 'Unpaid'),
  partial('PARTIAL', 'Partial'),
  paid('PAID', 'Paid');

  const PurchasePaymentStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static PurchasePaymentStatus fromDbValue(String value) {
    for (final status in values) {
      if (status.dbValue == value) return status;
    }
    return PurchasePaymentStatus.unpaid;
  }
}

/// Payment method options.
enum PaymentMethod {
  cash('Cash'),
  upi('UPI'),
  bank('Bank Transfer'),
  card('Card'),
  other('Other');

  const PaymentMethod(this.label);

  final String label;

  static PaymentMethod? fromLabel(String? value) {
    if (value == null) return null;
    for (final method in values) {
      if (method.label == value) return method;
    }
    return null;
  }
}

/// Domain model of a purchase.
///
/// Monetary values are stored as paise.
class PurchaseEntity {
  const PurchaseEntity({
    required this.id,
    required this.purchaseNumber,
    required this.supplierId,
    required this.supplierName,
    this.supplierCode,
    required this.purchaseDate,
    this.invoiceNumber,
    this.subtotal = 0,
    this.discount = 0,
    this.tax = 0,
    this.total = 0,
    this.paidAmount = 0,
    this.dueAmount = 0,
    this.paymentStatus = PurchasePaymentStatus.unpaid,
    this.paymentMethod,
    this.notes,
    this.isReturn = false,
    this.originalPurchaseId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  final int id;
  final String purchaseNumber;
  final int supplierId;
  final String supplierName;
  final String? supplierCode;
  final DateTime purchaseDate;
  final String? invoiceNumber;

  /// Subtotal before discount and tax, in paise.
  final int subtotal;

  /// Total discount, in paise.
  final int discount;

  /// Total tax, in paise.
  final int tax;

  /// Grand total, in paise.
  final int total;

  /// Amount paid, in paise.
  final int paidAmount;

  /// Amount due, in paise.
  final int dueAmount;

  final PurchasePaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? notes;
  final bool isReturn;
  final int? originalPurchaseId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Line items. Populated when fetching purchase details.
  final List<PurchaseItemEntity> items;

  /// Whether this is a return purchase.
  bool get isReturnPurchase => isReturn;
}

/// Domain model of a purchase line item.
///
/// Monetary values are stored as paise.
class PurchaseItemEntity {
  const PurchaseItemEntity({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.productName,
    this.productCode,
    this.variantId,
    this.variantName,
    required this.quantity,
    required this.unitId,
    this.unitName,
    required this.purchasePrice,
    this.discount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.lineTotal = 0,
    this.returnedQuantity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int purchaseId;
  final int productId;
  final String productName;
  final String? productCode;
  final int? variantId;
  final String? variantName;
  final int quantity;
  final int unitId;
  final String? unitName;

  /// Price per unit in paise.
  final int purchasePrice;

  /// Line discount in paise.
  final int discount;

  /// Tax rate percent (e.g. 18.0 for 18%).
  final double taxRate;

  /// Tax amount in paise.
  final int taxAmount;

  /// line_total in paise.
  final int lineTotal;

  /// Quantity returned against this item (for return tracking).
  final int returnedQuantity;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Maximum quantity that can still be returned.
  int get returnableQuantity => quantity - returnedQuantity;
}

/// Domain model for inventory transaction records.
class InventoryTransactionEntity {
  const InventoryTransactionEntity({
    required this.id,
    required this.productId,
    this.productName,
    this.variantId,
    this.variantName,
    this.warehouseId,
    required this.transactionType,
    required this.quantity,
    this.purchaseId,
    this.purchaseNumber,
    required this.transactionDate,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
  });

  final int id;
  final int productId;
  final String? productName;
  final int? variantId;
  final String? variantName;
  final int? warehouseId;

  /// PURCHASE, PURCHASE_RETURN, MANUAL_ADJUSTMENT, SALE.
  final String transactionType;

  /// Positive for stock in, negative for stock out.
  final int quantity;

  final int? purchaseId;
  final String? purchaseNumber;
  final DateTime transactionDate;
  final String? referenceNumber;
  final String? notes;
  final DateTime createdAt;
}
