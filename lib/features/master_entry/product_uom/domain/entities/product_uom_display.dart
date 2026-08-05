/// Display view model for Product UOM Conversions with joined details.
class ProductUomDisplay {
  const ProductUomDisplay({
    required this.id,
    required this.productId,
    required this.productName,
    required this.fromUnitId,
    required this.fromUnitName,
    required this.fromUnitSymbol,
    required this.toUnitId,
    required this.toUnitName,
    required this.toUnitSymbol,
    required this.conversionFactor,
    required this.isDefault,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int productId;
  final String productName;
  final int fromUnitId;
  final String fromUnitName;
  final String fromUnitSymbol;
  final int toUnitId;
  final String toUnitName;
  final String toUnitSymbol;
  final double conversionFactor;
  final bool isDefault;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get factorText =>
      conversionFactor % 1 == 0
          ? conversionFactor.toInt().toString()
          : conversionFactor.toString();
}
