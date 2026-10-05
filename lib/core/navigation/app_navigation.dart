import 'package:flutter/material.dart';

import 'app_page.dart';
import 'nav_item.dart';

/// The static navigation model for the application shell.
const List<NavSection> appNavigation = [
  NavSection('General', [
    NavItem('Dashboard', AppPage.dashboard),
    NavItem(
      'Master Entry',
      null,
      icon: Icons.dns_outlined,
      children: [
        NavItem('Company Settings', AppPage.companySettings),
        NavItem('Product Master', AppPage.product),
        NavItem('Category', AppPage.category),
        NavItem('Sub Category', AppPage.subCategory),
        NavItem('Brand', AppPage.brand),
        NavItem('Unit Master', AppPage.unitMaster),
        NavItem('UOM Conversion', AppPage.uomConversion),
        NavItem('Product UOM Conversion', AppPage.productUomConversion),
        NavItem('Tax Category', AppPage.taxCategory),
        NavItem('Tax Type', AppPage.taxType),
        NavItem('Customer', AppPage.customer),
        NavItem('Supplier', AppPage.supplier),
      ],
    ),
    NavItem(
      'Purchase',
      null,
      icon: Icons.shopping_cart_outlined,
      children: [
        NavItem('Purchase Entry', AppPage.purchaseEntry),
        NavItem('Purchase History', AppPage.purchaseHistory),
        NavItem('Purchase Returns', AppPage.purchaseReturns),
      ],
    ),
    NavItem('Sales (POS)', AppPage.salesPos),
    NavItem('Inventory', AppPage.inventory),
    NavItem('Reports', AppPage.reports),
    NavItem('Bill Format', AppPage.billFormat),
    NavItem('Settings', AppPage.settings),
  ]),
];
