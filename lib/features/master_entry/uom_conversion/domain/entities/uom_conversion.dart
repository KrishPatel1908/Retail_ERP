/// A universal conversion between two units (approved blueprint §3.6).
///
/// Semantics: `1 toUnit = conversionFactor × fromUnit`. Only the forward
/// direction is stored — the reverse direction is derived by dividing by
/// [conversionFactor]. There is no "default" flag on a global conversion;
/// defaults exist only per product (see `ProductUom`).
class UomConversion {
  const UomConversion({
    required this.id,
    required this.fromUnitId,
    required this.fromUnitName,
    required this.fromUnitSymbol,
    required this.toUnitId,
    required this.toUnitName,
    required this.toUnitSymbol,
    required this.conversionFactor,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  final int fromUnitId;

  /// Denormalised for display; resolved from the `unit` table by the
  /// repository.
  final String fromUnitName;

  final String fromUnitSymbol;

  final int toUnitId;

  final String toUnitName;

  final String toUnitSymbol;

  /// How many [toUnitName] one [fromUnitName] equals (e.g. `1000` for
  /// Kilogram → Gram).
  final double conversionFactor;

  final String? description;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// A human-readable summary, e.g. `1 Kilogram = 1000 Gram`.
  String get summary => '1 $fromUnitName = $factorText $toUnitName';

  String get factorText {
    if (conversionFactor == conversionFactor.roundToDouble()) {
      return conversionFactor.toStringAsFixed(0);
    }
    return conversionFactor.toString();
  }
}
