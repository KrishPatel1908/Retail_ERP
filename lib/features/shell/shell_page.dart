import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_page.dart';
import '../master_entry/category/domain/entities/category.dart';
import '../master_entry/category/presentation/pages/category_list_page.dart';
import '../master_entry/category/presentation/pages/create_category_page.dart';
import '../master_entry/product_uom/domain/entities/product_uom_display.dart';
import '../master_entry/product_uom/presentation/pages/create_product_uom_page.dart';
import '../master_entry/product_uom/presentation/pages/product_uom_list_page.dart';
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

  void _openUnitForm({Unit? unit}) {
    setState(() => _contentStack.add(UnitFormRoute(unit: unit)));
  }

  void _closeUnitForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openUomConversionForm({UomConversion? uomConversion}) {
    setState(
      () => _contentStack.add(UomConversionFormRoute(uomConversion: uomConversion)),
    );
  }

  void _closeUomConversionForm() {
    setState(() => _contentStack.removeLast());
  }

  void _openProductUomForm({ProductUomDisplay? conversion}) {
    setState(
      () => _contentStack.add(ProductUomFormRoute(productUomDisplay: conversion)),
    );
  }

  void _closeProductUomForm() {
    setState(() => _contentStack.removeLast());
  }

  Widget _buildContentPage(ContentRoute route) {
    return switch (route) {
      ModuleRoute(:final page) => switch (page) {
        AppPage.category => CategoryListPage(
          onAddCategory: () => _openCategoryForm(),
          onEditCategory: (category) => _openCategoryForm(category: category),
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
        _ => PagePlaceholder(page: page),
      },
      CategoryFormRoute(:final category) => CreateCategoryPage(
        onSave: _closeCategoryForm,
        onCancel: _closeCategoryForm,
        category: category,
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
        conversion: productUomDisplay as ProductUomDisplay?,
      ),
    };
  }

  String get _contentKey {
    return switch (_contentStack.last) {
      ModuleRoute(:final page) => 'module-${page.name}',
      CategoryFormRoute() => 'category-form',
      UnitFormRoute() => 'unit-form',
      UomConversionFormRoute() => 'uom-conversion-form',
      ProductUomFormRoute() => 'product-uom-form',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
