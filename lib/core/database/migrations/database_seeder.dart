import 'package:drift/drift.dart';

import '../app_database.dart';

/// Seeds the reference data defined by the approved blueprint on first run.
///
/// Runs inside the `onCreate` migration so a freshly created database is
/// immediately usable — e.g. the `GENERIC` brand and the `TAX-FREE` tax
/// category referenced by `product` defaults.
///
/// Rows use explicit ids so that cross-table references (tax category rates,
/// unit conversions) stay deterministic. Seed ids start at 1; user data
/// always receives auto-generated ids.
class DatabaseSeeder {
  const DatabaseSeeder(this._db);

  final AppDatabase _db;

  Future<void> seed() async {
    await _db.batch((batch) {
      batch.insertAll(_db.units, _units);
      batch.insertAll(_db.uomConversions, _uomConversions);
      batch.insertAll(_db.taxTypes, _taxTypes);
      batch.insertAll(_db.taxCategories, _taxCategories);
      batch.insertAll(_db.taxCategoryRates, _taxCategoryRates);
      batch.insertAll(_db.brands, _brands);
    });
  }

  /// Units of the approved blueprint (§3.5), final shape.
  ///
  /// The table stores available units only; conversion factors live in
  /// [_uomConversions] (global) and `product_uom` (per product).
  static final List<UnitsCompanion> _units = [
    UnitsCompanion.insert(
      id: Value(1),
      unitName: 'Piece',
      unitSymbol: 'pc',
      unitFamily: const Value('COUNT'),
      description: const Value('A single item; the base count unit.'),
    ),
    UnitsCompanion.insert(
      id: Value(2),
      unitName: 'Dozen',
      unitSymbol: 'doz',
      unitFamily: const Value('COUNT'),
      description: const Value('A group of twelve pieces.'),
    ),
    UnitsCompanion.insert(
      id: Value(3),
      unitName: 'Pair',
      unitSymbol: 'pr',
      unitFamily: const Value('COUNT'),
      description: const Value('Two pieces sold together.'),
    ),
    UnitsCompanion.insert(
      id: Value(4),
      unitName: 'Bundle',
      unitSymbol: 'bdl',
      unitFamily: const Value('COUNT'),
      description: const Value('A wrapped group of items.'),
    ),
    UnitsCompanion.insert(
      id: Value(5),
      unitName: 'Kilogram',
      unitSymbol: 'kg',
      unitFamily: const Value('WEIGHT'),
      description: const Value('One thousand grams.'),
    ),
    UnitsCompanion.insert(
      id: Value(6),
      unitName: 'Gram',
      unitSymbol: 'g',
      unitFamily: const Value('WEIGHT'),
      description: const Value('The base metric weight unit.'),
    ),
    UnitsCompanion.insert(
      id: Value(7),
      unitName: 'Liter',
      unitSymbol: 'l',
      unitFamily: const Value('VOLUME'),
      description: const Value('One thousand milliliters.'),
    ),
    UnitsCompanion.insert(
      id: Value(8),
      unitName: 'Milliliter',
      unitSymbol: 'ml',
      unitFamily: const Value('VOLUME'),
      description: const Value('The base metric volume unit.'),
    ),
    UnitsCompanion.insert(
      id: Value(9),
      unitName: 'Meter',
      unitSymbol: 'm',
      unitFamily: const Value('LENGTH'),
      description: const Value('The base metric length unit.'),
    ),
    UnitsCompanion.insert(
      id: Value(10),
      unitName: 'Foot',
      unitSymbol: 'ft',
      unitFamily: const Value('LENGTH'),
      description: const Value('One foot equals 0.3048 meters.'),
    ),
    UnitsCompanion.insert(
      id: Value(11),
      unitName: 'Centimeter',
      unitSymbol: 'cm',
      unitFamily: const Value('LENGTH'),
      description: const Value('One hundredth of a meter.'),
    ),
    UnitsCompanion.insert(
      id: Value(12),
      unitName: 'Box',
      unitSymbol: 'box',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A standard box of items.'),
    ),
    UnitsCompanion.insert(
      id: Value(13),
      unitName: 'Packet',
      unitSymbol: 'pkt',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A sealed packet of items.'),
    ),
    UnitsCompanion.insert(
      id: Value(14),
      unitName: 'Bottle',
      unitSymbol: 'btl',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A bottled quantity.'),
    ),
    UnitsCompanion.insert(
      id: Value(15),
      unitName: 'Bag',
      unitSymbol: 'bag',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A bag of items.'),
    ),
    UnitsCompanion.insert(
      id: Value(16),
      unitName: 'Carton',
      unitSymbol: 'ctn',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A carton of items.'),
    ),
    UnitsCompanion.insert(
      id: Value(17),
      unitName: 'Roll',
      unitSymbol: 'rol',
      unitFamily: const Value('PACKAGING'),
      description: const Value('A rolled quantity (cloth, tape, etc.).'),
    ),
    UnitsCompanion.insert(
      id: Value(18),
      unitName: 'Square Meter',
      unitSymbol: 'm²',
      unitFamily: const Value('AREA'),
      description: const Value('The base metric area unit.'),
    ),
    UnitsCompanion.insert(
      id: Value(19),
      unitName: 'Hour',
      unitSymbol: 'h',
      unitFamily: const Value('TIME'),
      description: const Value('Sixty minutes; used for time-based services.'),
    ),
  ];

  /// Universal conversions of the approved blueprint (§3.6).
  ///
  /// Semantics: `1 to_unit = conversion_factor × from_unit`. The reverse
  /// direction is derived automatically (divide by the factor), so only the
  /// forward row is stored.
  static final List<UomConversionsCompanion> _uomConversions = [
    UomConversionsCompanion.insert(
      id: Value(1),
      fromUnitId: 2, // Dozen
      toUnitId: 1, // Piece
      conversionFactor: 12,
      description: const Value('1 Dozen = 12 Pieces'),
    ),
    UomConversionsCompanion.insert(
      id: Value(2),
      fromUnitId: 3, // Pair
      toUnitId: 1, // Piece
      conversionFactor: 2,
      description: const Value('1 Pair = 2 Pieces'),
    ),
    UomConversionsCompanion.insert(
      id: Value(3),
      fromUnitId: 4, // Bundle
      toUnitId: 1, // Piece
      conversionFactor: 12,
      description: const Value('1 Bundle = 12 Pieces'),
    ),
    UomConversionsCompanion.insert(
      id: Value(4),
      fromUnitId: 5, // Kilogram
      toUnitId: 6, // Gram
      conversionFactor: 1000,
      description: const Value('1 Kilogram = 1000 Grams'),
    ),
    UomConversionsCompanion.insert(
      id: Value(5),
      fromUnitId: 7, // Liter
      toUnitId: 8, // Milliliter
      conversionFactor: 1000,
      description: const Value('1 Liter = 1000 Milliliters'),
    ),
    UomConversionsCompanion.insert(
      id: Value(6),
      fromUnitId: 10, // Foot
      toUnitId: 9, // Meter
      conversionFactor: 0.3048,
      description: const Value('1 Foot = 0.3048 Meters'),
    ),
    UomConversionsCompanion.insert(
      id: Value(7),
      fromUnitId: 9, // Meter
      toUnitId: 11, // Centimeter
      conversionFactor: 100,
      description: const Value('1 Meter = 100 Centimeters'),
    ),
  ];

  /// Tax types of the approved blueprint (§3.8). `GST` is the umbrella label;
  /// actual rates attach to CGST/SGST/IGST.
  static final List<TaxTypesCompanion> _taxTypes = [
    TaxTypesCompanion.insert(
      id: Value(1),
      taxTypeCode: 'GST',
      taxTypeName: 'GST',
    ),
    TaxTypesCompanion.insert(
      id: Value(2),
      taxTypeCode: 'CGST',
      taxTypeName: 'CGST',
    ),
    TaxTypesCompanion.insert(
      id: Value(3),
      taxTypeCode: 'SGST',
      taxTypeName: 'SGST',
    ),
    TaxTypesCompanion.insert(
      id: Value(4),
      taxTypeCode: 'IGST',
      taxTypeName: 'IGST',
    ),
    TaxTypesCompanion.insert(
      id: Value(5),
      taxTypeCode: 'CESS',
      taxTypeName: 'CESS',
    ),
  ];

  /// Tax categories of the approved blueprint (§3.7).
  static final List<TaxCategoriesCompanion> _taxCategories = [
    TaxCategoriesCompanion.insert(
      id: Value(1),
      taxCategoryCode: 'TAX-FREE',
      taxCategoryName: 'Tax Free',
    ),
    TaxCategoriesCompanion.insert(
      id: Value(2),
      taxCategoryCode: 'GST-5',
      taxCategoryName: 'GST 5%',
    ),
    TaxCategoriesCompanion.insert(
      id: Value(3),
      taxCategoryCode: 'GST-12',
      taxCategoryName: 'GST 12%',
    ),
    TaxCategoriesCompanion.insert(
      id: Value(4),
      taxCategoryCode: 'GST-18',
      taxCategoryName: 'GST 18%',
    ),
    TaxCategoriesCompanion.insert(
      id: Value(5),
      taxCategoryCode: 'GST-28',
      taxCategoryName: 'GST 28%',
    ),
  ];

  /// Rate breakdown per category.
  ///
  /// Each category stores its intra-state split only: CGST + SGST. The IGST
  /// component is intentionally omitted so that "sum of components" equals the
  /// category's total rate and matches its name (e.g. GST 18% = 9 + 9 = 18).
  /// Ids are preserved (1, 2, 3 ...) so fresh-create and migrated databases
  /// converge on the same reference data; the deleted IGST gaps are simply
  /// unused ids.
  static final List<TaxCategoryRatesCompanion> _taxCategoryRates = [
    // Tax Free: 0 + 0 = 0.
    TaxCategoryRatesCompanion.insert(
      id: Value(1),
      taxCategoryId: 1,
      taxTypeId: 2,
      ratePercent: 0,
    ),
    TaxCategoryRatesCompanion.insert(
      id: Value(2),
      taxCategoryId: 1,
      taxTypeId: 3,
      ratePercent: 0,
    ),
    // GST 5%: 2.5 + 2.5 = 5.
    TaxCategoryRatesCompanion.insert(
      id: Value(4),
      taxCategoryId: 2,
      taxTypeId: 2,
      ratePercent: 2.5,
    ),
    TaxCategoryRatesCompanion.insert(
      id: Value(5),
      taxCategoryId: 2,
      taxTypeId: 3,
      ratePercent: 2.5,
    ),
    // GST 12%: 6 + 6 = 12.
    TaxCategoryRatesCompanion.insert(
      id: Value(7),
      taxCategoryId: 3,
      taxTypeId: 2,
      ratePercent: 6,
    ),
    TaxCategoryRatesCompanion.insert(
      id: Value(8),
      taxCategoryId: 3,
      taxTypeId: 3,
      ratePercent: 6,
    ),
    // GST 18%: 9 + 9 = 18.
    TaxCategoryRatesCompanion.insert(
      id: Value(10),
      taxCategoryId: 4,
      taxTypeId: 2,
      ratePercent: 9,
    ),
    TaxCategoryRatesCompanion.insert(
      id: Value(11),
      taxCategoryId: 4,
      taxTypeId: 3,
      ratePercent: 9,
    ),
    // GST 28%: 14 + 14 = 28.
    TaxCategoryRatesCompanion.insert(
      id: Value(13),
      taxCategoryId: 5,
      taxTypeId: 2,
      ratePercent: 14,
    ),
    TaxCategoryRatesCompanion.insert(
      id: Value(14),
      taxCategoryId: 5,
      taxTypeId: 3,
      ratePercent: 14,
    ),
  ];

  /// The `GENERIC / No Brand` brand every product requires as fallback
  /// (approved blueprint §3.4).
  static final List<BrandsCompanion> _brands = [
    BrandsCompanion.insert(
      id: Value(1),
      brandCode: 'GENERIC',
      brandName: 'Generic / No Brand',
    ),
  ];
}
