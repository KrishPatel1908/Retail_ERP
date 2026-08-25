import 'package:flutter/material.dart';

/// Every destination reachable from the sidebar.
///
/// Each page carries its display title and icon variants so widgets can stay
/// free of hard-coded presentation strings.
enum AppPage {
  dashboard('Dashboard', Icons.space_dashboard_outlined, Icons.space_dashboard),
  companySettings('Company Settings', Icons.business_outlined, Icons.business),
  category('Category', Icons.category_outlined, Icons.category),
  subCategory('Sub Category', Icons.account_tree_outlined, Icons.account_tree),
  brand('Brand', Icons.local_offer_outlined, Icons.local_offer),
  unitMaster('Unit Master', Icons.straighten_outlined, Icons.straighten),
  uomConversion(
    'UOM Conversion',
    Icons.swap_horiz_outlined,
    Icons.swap_horiz,
  ),
  productUomConversion(
    'Product UOM Conversion',
    Icons.transform_outlined,
    Icons.transform,
  ),
  taxCategory(
    'Tax Category',
    Icons.request_quote_outlined,
    Icons.request_quote,
  ),
  taxType('Tax Type', Icons.percent_outlined, Icons.percent),
  customer('Customer', Icons.group_outlined, Icons.group),
  supplier('Supplier', Icons.local_shipping_outlined, Icons.local_shipping),
  product('Product Master', Icons.inventory_2_outlined, Icons.inventory_2),
  productTracking(
    'Product Tracking',
    Icons.show_chart_outlined,
    Icons.show_chart,
  ),
  purchase('Purchase', Icons.shopping_cart_outlined, Icons.shopping_cart),
  purchaseEntry('Purchase Entry', Icons.add_shopping_cart_outlined, Icons.add_shopping_cart),
  purchaseHistory('Purchase History', Icons.receipt_long_outlined, Icons.receipt_long),
  purchaseReturns('Purchase Returns', Icons.assignment_return_outlined, Icons.assignment_return),
  salesPos('Sales (POS)', Icons.point_of_sale_outlined, Icons.point_of_sale),
  inventory('Inventory', Icons.warehouse_outlined, Icons.warehouse),
  reports('Reports', Icons.bar_chart_outlined, Icons.bar_chart),
  settings('Settings', Icons.settings_outlined, Icons.settings);

  const AppPage(this.title, this.outlinedIcon, this.filledIcon);

  /// Human-readable label shown in the sidebar and the content area.
  final String title;

  /// Icon used for resting (unselected) states.
  final IconData outlinedIcon;

  /// Icon used for the selected state.
  final IconData filledIcon;
}
