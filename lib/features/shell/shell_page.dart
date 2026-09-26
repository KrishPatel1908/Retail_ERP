import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_page.dart';
import '../company_settings/presentation/pages/company_settings_page.dart';
import '../inventory/presentation/pages/inventory_list_page.dart';
import '../master_entry/brand/domain/entities/brand.dart';
import '../master_entry/brand/presentation/pages/brand_list_page.dart';
import '../master_entry/brand/presentation/pages/create_brand_page.dart';
import '../master_entry/category/domain/entities/category.dart';
import '../master_entry/customer/domain/entities/customer.dart';
import '../master_entry/customer/presentation/pages/create_customer_page.dart';
import '../master_entry/customer/presentation/pages/customer_list_page.dart';
import '../master_entry/product/domain/entities/product.dart';
import '../master_entry/product/presentation/pages/create_product_page.dart';
import '../master_entry/product/presentation/pages/product_list_page.dart';
import '../master_entry/category/presentation/pages/category_list_page.dart';
import '../master_entry/category/presentation/pages/create_category_page.dart';
import '../master_entry/sub_category/domain/entities/sub_category.dart';
import '../master_entry/sub_category/presentation/pages/create_sub_category_page.dart';
import '../master_entry/sub_category/presentation/pages/sub_category_list_page.dart';
import '../master_entry/supplier/domain/entities/supplier.dart';
import '../master_entry/supplier/presentation/pages/create_supplier_page.dart';
import '../master_entry/supplier/presentation/pages/supplier_list_page.dart';
import '../purchase/presentation/pages/create_purchase_return_page.dart';
import '../purchase/presentation/pages/create_purchase_page.dart';
import '../purchase/presentation/pages/purchase_history_page.dart';
import '../purchase/presentation/pages/purchase_returns_page.dart';
import '../master_entry/product_uom/domain/entities/product_uom_display.dart';
import '../master_entry/product_uom/presentation/pages/create_product_uom_page.dart';
import '../master_entry/product_uom/presentation/pages/product_uom_list_page.dart';
import '../master_entry/tax_category/domain/entities/tax_category.dart';
import '../master_entry/tax_category/presentation/pages/create_tax_category_page.dart';
import '../master_entry/tax_category/presentation/pages/tax_category_list_page.dart';
import '../master_entry/tax_type/domain/entities/tax_type.dart';
import '../master_entry/tax_type/presentation/pages/create_tax_type_page.dart';
import '../master_entry/tax_type/presentation/pages/tax_type_list_page.dart';
import '../master_entry/unit/domain/entities/unit.dart';
import '../master_entry/unit/presentation/pages/create_unit_page.dart';
import '../master_entry/unit/presentation/pages/unit_list_page.dart';
import '../master_entry/uom_conversion/domain/entities/uom_conversion.dart';
import '../master_entry/uom_conversion/presentation/pages/create_uom_conversion_page.dart';
import '../master_entry/uom_conversion/presentation/pages/uom_conversion_list_page.dart';
import 'content_route.dart';
import 'widgets/app_sidebar.dart';
import 'widgets/app_top_bar.dart';
import 'widgets/page_placeholder.dart';
import 'widgets/status_bar.dart';

/// The main desktop shell.
///
/// Owns lightweight navigation state (selected page, sidebar expansion and a
/// small content-area route stack) and composes the reusable shell widgets.
/// No business logic lives here.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  AppPage _selectedPage = AppPage.dashboard;
  bool _sidebarExpanded = true;

  /// Content-area route stack; the last entry is what gets rendered.
  final List<ContentRoute> _contentStack = [
    const ModuleRoute(AppPage.dashboard),
  ];

  void _onPageSelected(AppPage page) {
    setState(() {
      _selectedPage = page;
      _contentStack
        ..clear()
        ..add(ModuleRoute(page));
    });
  }

  void _toggleSidebar() {
    setState(() => _sidebarExpanded = !_sidebarExpanded);
  }

  void _openCategoryForm({Category? category}) {
    setState(() => _contentStack.add(CategoryFormRoute(category: category)));
  }

  void _closeCategoryForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openSubCategoryForm({SubCategory? subCategory}) {
    setState(
      () => _contentStack.add(SubCategoryFormRoute(subCategory: subCategory)),
    );
  }

  void _closeSubCategoryForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openBrandForm({Brand? brand}) {
    setState(() => _contentStack.add(BrandFormRoute(brand: brand)));
  }

  void _closeBrandForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openTaxCategoryForm({TaxCategory? taxCategory}) {
    setState(
      () => _contentStack.add(TaxCategoryFormRoute(taxCategory: taxCategory)),
    );
  }

  void _closeTaxCategoryForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openTaxTypeForm({TaxType? taxType}) {
    setState(() => _contentStack.add(TaxTypeFormRoute(taxType: taxType)));
  }

  void _closeTaxTypeForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openUnitForm({Unit? unit}) {
    setState(() => _contentStack.add(UnitFormRoute(unit: unit)));
  }

  void _closeUnitForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openUomConversionForm({UomConversion? uomConversion}) {
    setState(
      () => _contentStack.add(
        UomConversionFormRoute(uomConversion: uomConversion),
      ),
    );
  }

  void _closeUomConversionForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openProductUomForm({ProductUomDisplay? conversion}) {
    setState(
      () =>
          _contentStack.add(ProductUomFormRoute(productUomDisplay: conversion)),
    );
  }

  void _closeProductUomForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openProductForm({ProductEntity? product}) {
    setState(() => _contentStack.add(ProductFormRoute(product: product)));
  }

  void _closeProductForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openCustomerForm({Customer? customer}) {
    setState(() => _contentStack.add(CustomerFormRoute(customer: customer)));
  }

  void _closeCustomerForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openSupplierForm({Supplier? supplier}) {
    setState(() => _contentStack.add(SupplierFormRoute(supplier: supplier)));
  }

  void _closeSupplierForm() {
    setState(() => _contentStack.removeLast());
  }

  Widget _buildContentPage(ContentRoute route) {
    return switch (route) {
      ModuleRoute(:final page) => switch (page) {
        AppPage.category => CategoryListPage(
          onAddCategory: () => _openCategoryForm(),
          onEditCategory: (category) => _openCategoryForm(category: category),
        ),
        AppPage.subCategory => SubCategoryListPage(
          onAddSubCategory: () => _openSubCategoryForm(),
          onEditSubCategory: (subCategory) =>
              _openSubCategoryForm(subCategory: subCategory),
        ),
        AppPage.brand => BrandListPage(
          onAddBrand: () => _openBrandForm(),
          onEditBrand: (brand) => _openBrandForm(brand: brand),
        ),
        AppPage.taxCategory => TaxCategoryListPage(
          onAddTaxCategory: () => _openTaxCategoryForm(),
          onEditTaxCategory: (category) =>
              _openTaxCategoryForm(taxCategory: category),
        ),
        AppPage.taxType => TaxTypeListPage(
          onAddTaxType: () => _openTaxTypeForm(),
          onEditTaxType: (taxType) => _openTaxTypeForm(taxType: taxType),
        ),
        AppPage.unitMaster => UnitListPage(
          onAddUnit: () => _openUnitForm(),
          onEditUnit: (unit) => _openUnitForm(unit: unit),
        ),
        AppPage.uomConversion => UomConversionListPage(
          onAddConversion: () => _openUomConversionForm(),
          onEditConversion: (conversion) =>
              _openUomConversionForm(uomConversion: conversion),
        ),
        AppPage.productUomConversion => ProductUomListPage(
          onAddConversion: () => _openProductUomForm(),
          onEditConversion: (conversion) =>
              _openProductUomForm(conversion: conversion),
        ),
        AppPage.customer => CustomerListPage(
          onAddCustomer: () => _openCustomerForm(),
          onEditCustomer: (customer) => _openCustomerForm(customer: customer),
        ),
        AppPage.product => ProductListPage(
          onAddProduct: () => _openProductForm(),
          onEditProduct: (product) => _openProductForm(product: product),
        ),
        AppPage.supplier => SupplierListPage(
          onAddSupplier: () => _openSupplierForm(),
          onEditSupplier: (supplier) => _openSupplierForm(supplier: supplier),
        ),
        AppPage.companySettings => const CompanySettingsPage(),
        AppPage.inventory => const InventoryListPage(),
        AppPage.purchaseEntry => CreatePurchasePage(
          onSave: () => _onPageSelected(AppPage.purchaseHistory),
          onCancel: () => _onPageSelected(AppPage.purchaseHistory),
        ),
        AppPage.purchaseHistory => PurchaseHistoryPage(
          onNewPurchase: () => _onPageSelected(AppPage.purchaseEntry),
          onEditPurchase: (purchase) {
            setState(
              () => _contentStack.add(PurchaseFormRoute(purchase: purchase)),
            );
          },
        ),
        AppPage.purchaseReturns => PurchaseReturnHistoryPage(
          onNewReturn: () {
            setState(() {
              _contentStack.add(const PurchaseReturnFormRoute());
            });
          },
        ),
        _ => PagePlaceholder(page: page),
      },
      CategoryFormRoute(:final category) => CreateCategoryPage(
        onSave: _closeCategoryForm,
        onCancel: _closeCategoryForm,
        category: category,
      ),
      SubCategoryFormRoute(:final subCategory) => CreateSubCategoryPage(
        onSave: _closeSubCategoryForm,
        onCancel: _closeSubCategoryForm,
        subCategory: subCategory,
      ),
      BrandFormRoute(:final brand) => CreateBrandPage(
        onSave: _closeBrandForm,
        onCancel: _closeBrandForm,
        brand: brand,
      ),
      TaxCategoryFormRoute(:final taxCategory) => CreateTaxCategoryPage(
        onSave: _closeTaxCategoryForm,
        onCancel: _closeTaxCategoryForm,
        category: taxCategory,
      ),
      TaxTypeFormRoute(:final taxType) => CreateTaxTypePage(
        onSave: _closeTaxTypeForm,
        onCancel: _closeTaxTypeForm,
        taxType: taxType,
      ),
      UnitFormRoute(:final unit) => CreateUnitPage(
        onSave: _closeUnitForm,
        onCancel: _closeUnitForm,
        unit: unit,
      ),
      UomConversionFormRoute(:final uomConversion) => CreateUomConversionPage(
        onSave: _closeUomConversionForm,
        onCancel: _closeUomConversionForm,
        conversion: uomConversion,
      ),
      ProductUomFormRoute(:final productUomDisplay) => CreateProductUomPage(
        onSave: _closeProductUomForm,
        onCancel: _closeProductUomForm,
        onNavigateToProducts: () => _onPageSelected(AppPage.product),
        conversion: productUomDisplay,
      ),
      CustomerFormRoute(:final customer) => CreateCustomerPage(
        onSave: _closeCustomerForm,
        onCancel: _closeCustomerForm,
        customer: customer,
      ),
      ProductFormRoute(:final product) => CreateProductPage(
        onSave: _closeProductForm,
        onCancel: _closeProductForm,
        product: product,
      ),
      SupplierFormRoute(:final supplier) => CreateSupplierPage(
        onSave: _closeSupplierForm,
        onCancel: _closeSupplierForm,
        supplier: supplier,
      ),
      PurchaseFormRoute(:final purchase) => CreatePurchasePage(
        onSave: () {
          setState(() => _contentStack.removeLast());
          _onPageSelected(AppPage.purchaseHistory);
        },
        onCancel: () {
          setState(() => _contentStack.removeLast());
        },
        purchase: purchase,
      ),
      PurchaseReturnFormRoute() => CreatePurchaseReturnPage(
        onSave: () {
          setState(() => _contentStack.removeLast());
          _onPageSelected(AppPage.purchaseReturns);
        },
        onCancel: () {
          setState(() => _contentStack.removeLast());
        },
      ),
    };
  }

  String get _contentKey {
    return switch (_contentStack.last) {
      ModuleRoute(:final page) => 'module-${page.name}',
      CategoryFormRoute() => 'category-form',
      SubCategoryFormRoute() => 'sub-category-form',
      BrandFormRoute() => 'brand-form',
      TaxCategoryFormRoute() => 'tax-category-form',
      TaxTypeFormRoute() => 'tax-type-form',
      UnitFormRoute() => 'unit-form',
      UomConversionFormRoute() => 'uom-conversion-form',
      ProductUomFormRoute() => 'product-uom-form',
      CustomerFormRoute() => 'customer-form',
      ProductFormRoute() => 'product-form',
      SupplierFormRoute() => 'supplier-form',
      PurchaseFormRoute() => 'purchase-form',
      PurchaseReturnFormRoute() => 'purchase-return-form',
    };
  }

  bool _popContent() {
    if (_contentStack.length > 1) {
      setState(() => _contentStack.removeLast());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          _popContent();
        },
      },
      child: PopScope(
        canPop: _contentStack.length <= 1,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            _popContent();
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool expanded =
                  _sidebarExpanded &&
                  constraints.maxWidth >=
                      AppConstants.autoCollapseSidebarBelowWidth;

              return Column(
                children: [
                  AppTopBar(
                    onToggleSidebar: _toggleSidebar,
                    sidebarExpanded: expanded,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSidebar(
                          expanded: expanded,
                          selectedPage: _selectedPage,
                          onSelect: _onPageSelected,
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.015, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: KeyedSubtree(
                              key: ValueKey(_contentKey),
                              child: _buildContentPage(_contentStack.last),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBar(selectedPage: _selectedPage),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
