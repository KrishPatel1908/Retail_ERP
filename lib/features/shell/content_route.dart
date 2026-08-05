import '../../core/navigation/app_page.dart';
import '../master_entry/category/domain/entities/category.dart';
import '../master_entry/unit/domain/entities/unit.dart';
import '../master_entry/uom_conversion/domain/entities/uom_conversion.dart';

/// A page rendered inside the shell's content area.
///
/// The content area keeps a small route stack so a module can show detail
/// pages (e.g. "Create Category") without leaving the shell chrome.
sealed class ContentRoute {
  const ContentRoute();
}

/// Root route for a module selected from the sidebar.
class ModuleRoute extends ContentRoute {
  const ModuleRoute(this.page);

  final AppPage page;
}

/// The "Create / Edit Category" form shown above the Category list.
///
/// When [category] is provided the form edits that category, otherwise it
/// creates a new one.
class CategoryFormRoute extends ContentRoute {
  const CategoryFormRoute({this.category});

  final Category? category;
}

/// The "Create / Edit Unit" form shown above the Unit Master list.
///
/// When [unit] is provided the form edits that unit, otherwise it creates
/// a new one.
class UnitFormRoute extends ContentRoute {
  const UnitFormRoute({this.unit});

  final Unit? unit;
}

/// The "Create / Edit Conversion" form shown above the UOM Conversion list.
///
/// When [uomConversion] is provided the form edits that conversion,
/// otherwise it creates a new one.
class UomConversionFormRoute extends ContentRoute {
  const UomConversionFormRoute({this.uomConversion});

  final UomConversion? uomConversion;
}

/// The "Create / Edit Product Conversion" form shown above the Product UOM Conversion list.
class ProductUomFormRoute extends ContentRoute {
  const ProductUomFormRoute({this.productUomDisplay});

  final dynamic productUomDisplay;
}
