/// Status of payment for a sale.
enum SalePaymentStatus {
  paid('Paid', 'PAID'),
  partial('Partial', 'PARTIAL'),
  unpaid('Credit / Unpaid', 'UNPAID');

  const SalePaymentStatus(this.label, this.dbValue);

  final String label;
  final String dbValue;

  static SalePaymentStatus fromDbValue(String value) {
    for (final status in values) {
      if (status.dbValue == value) return status;
    }
    return SalePaymentStatus.unpaid;
  }
}

/// Domain entity representing a completed or recorded Sale.
class SaleEntity {
  const SaleEntity({
    required this.id,
    required this.saleNumber,
    this.customerId,
    this.customerName,
    this.customerCode,
    required this.saleDate,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.paidAmount,
    required this.balanceAmount,
    required this.changeAmount,
    required this.paymentStatus,
    required this.paymentMethod,
    this.notes,
    required this.isActive,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String saleNumber;
  final int? customerId;
  final String? customerName;
  final String? customerCode;
  final DateTime saleDate;

  /// In paise.
  final int subtotal;
  final int discount;
  final int tax;
  final int grandTotal;
  final int paidAmount;
  final int balanceAmount;
  final int changeAmount;

  final SalePaymentStatus paymentStatus;
  final String paymentMethod;
  final String? notes;
  final bool isActive;
  final List<SaleItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Domain entity representing a line item in a sale.
class SaleItemEntity {
  const SaleItemEntity({
    required this.id,
    required this.saleId,
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    this.barcode,
    required this.unitId,
    required this.unitName,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.taxRate,
    required this.taxAmount,
    required this.lineTotal,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int saleId;
  final int productId;
  final int? variantId;
  final String productName;
  final String? variantName;
  final String? barcode;
  final int unitId;
  final String unitName;
  final double quantity;

  /// Selling price in paise.
  final int unitPrice;

  /// Line discount in paise.
  final int discount;

  /// Tax rate percentage (e.g. 18.0 for 18%).
  final double taxRate;

  /// Tax amount in paise.
  final int taxAmount;

  /// Line total in paise = (quantity * unitPrice) - discount + taxAmount.
  final int lineTotal;

  final DateTime createdAt;
  final DateTime updatedAt;

  String get displayName =>
      variantName != null ? '$productName ($variantName)' : productName;
}

/// Domain entity representing a financial entry in the customer ledger.
class CustomerTransactionEntity {
  const CustomerTransactionEntity({
    required this.id,
    this.saleId,
    required this.customerId,
    required this.debit,
    required this.credit,
    required this.runningTotal,
    required this.transactionDate,
    this.note,
    required this.createdAt,
  });

  final int id;
  final int? saleId;
  final int customerId;
  final int debit;
  final int credit;
  final int runningTotal;
  final DateTime transactionDate;
  final String? note;
  final DateTime createdAt;
}
