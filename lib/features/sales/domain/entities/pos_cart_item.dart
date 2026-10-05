import 'dart:math';

import 'sellable_item.dart';

/// Represents an item currently in the POS active cart.
class PosCartItem {
  PosCartItem({
    required this.sellableItem,
    this.quantity = 1.0,
    this.discountPaise = 0,
    this.discountPercentage = 0.0,
    this.isPercentageDiscount = false,
    this.customUnitPrice,
  });

  final SellableItem sellableItem;
  double quantity;
  int discountPaise;
  double discountPercentage;
  bool isPercentageDiscount;
  int? customUnitPrice;

  int get effectiveUnitPrice => customUnitPrice ?? sellableItem.sellingPrice;

  /// Line subtotal in paise before discount: (qty * price).
  int get lineSubtotal => (quantity * effectiveUnitPrice).round();

  /// Line discount in paise, respecting bounds [0, lineSubtotal].
  int get lineDiscount {
    if (isPercentageDiscount) {
      final clampedPercent = min(100.0, max(0.0, discountPercentage));
      return (lineSubtotal * clampedPercent / 100).round();
    }
    return min(lineSubtotal, max(0, discountPaise));
  }

  /// Taxable amount in paise after discount.
  int get taxableAmount => max(0, lineSubtotal - lineDiscount);

  /// Tax amount in paise: (taxable * rate / 100).
  int get lineTaxAmount => (taxableAmount * sellableItem.taxRate / 100).round();

  /// Line total in paise = taxable + tax.
  int get lineTotal => taxableAmount + lineTaxAmount;

  PosCartItem copyWith({
    SellableItem? sellableItem,
    double? quantity,
    int? discountPaise,
    double? discountPercentage,
    bool? isPercentageDiscount,
    int? customUnitPrice,
  }) {
    return PosCartItem(
      sellableItem: sellableItem ?? this.sellableItem,
      quantity: quantity ?? this.quantity,
      discountPaise: discountPaise ?? this.discountPaise,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isPercentageDiscount: isPercentageDiscount ?? this.isPercentageDiscount,
      customUnitPrice: customUnitPrice ?? this.customUnitPrice,
    );
  }
}
