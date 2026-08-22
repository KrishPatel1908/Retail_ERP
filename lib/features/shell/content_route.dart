import '../../core/navigation/app_page.dart';
import '../master_entry/brand/domain/entities/brand.dart';
import '../master_entry/category/domain/entities/category.dart';
import '../master_entry/customer/domain/entities/customer.dart';
import '../master_entry/product/domain/entities/product.dart';
import '../master_entry/sub_category/domain/entities/sub_category.dart';
import '../master_entry/supplier/domain/entities/supplier.dart';
import '../master_entry/tax_category/domain/entities/tax_category.dart';
import '../master_entry/tax_type/domain/entities/tax_type.dart';
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

/// The "Create / Edit Sub Category" form shown above the Sub Category list.
class SubCategoryFormRoute extends ContentRoute {
  const SubCategoryFormRoute({this.subCategory});

  final SubCategory? subCategory;
}

/// The "Create / Edit Brand" form shown above the Brand list.
///
/// When [brand] is provided the form edits that brand, otherwise it creates
/// a new one.
class BrandFormRoute extends ContentRoute {
  const BrandFormRoute({this.brand});

  final Brand? brand;
}

/// The "Create / Edit Tax Category" form shown above the Tax Category list.
///
/// When [taxCategory] is provided the form edits that category, otherwise it creates
/// a new one.
class TaxCategoryFormRoute extends ContentRoute {
  const TaxCategoryFormRoute({this.taxCategory});

  final TaxCategory? taxCategory;
}

/// The "Create / Edit Tax Type" form shown above the Tax Type list.
///
/// When [taxType] is provided the form edits that tax type, otherwise it creates
/// a new one.
class TaxTypeFormRoute extends ContentRoute {
  const TaxTypeFormRoute({this.taxType});

  final TaxType? taxType;
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

/// The "Create / Edit Customer" form shown above the Customer list.
///
/// When [customer] is provided the form edits that customer, otherwise it
/// creates a new one.
class CustomerFormRoute extends ContentRoute {
  const CustomerFormRoute({this.customer});

  final Customer? customer;
}

/// The "Create / Edit Supplier" form shown above the Supplier list.
///
/// When [supplier] is provided the form edits that supplier, otherwise it
/// creates a new one.
class SupplierFormRoute extends ContentRoute {
  const SupplierFormRoute({this.supplier});

  final Supplier? supplier;
}

/// The "Create / Edit Product" form shown above the Product list.
///
/// When [product] is provided the form edits that product, otherwise it
/// creates a new one.
class ProductFormRoute extends ContentRoute {
  const ProductFormRoute({this.product});

  final ProductEntity? product;
}
