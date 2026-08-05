/// The measure a unit is used for, persisted in the `unit_family` column of
/// the `unit` table (approved blueprint §3.5).
///
/// The value is a display hint only — conversions between units live in the
/// UOM Conversion and Product UOM modules, not here.
enum UnitType {
  weight('Weight', 'WEIGHT'),
  length('Length', 'LENGTH'),
  volume('Volume', 'VOLUME'),
  count('Count', 'COUNT'),
  packaging('Packaging', 'PACKAGING'),
  area('Area', 'AREA'),
  time('Time', 'TIME'),
  other('Other', 'OTHER');

  const UnitType(this.label, this.dbValue);

  /// Human-readable label shown in the UI.
  final String label;

  /// Value stored in the `unit_family` column.
  final String dbValue;

  /// Resolves a stored family value back to its enum, or `null` for
  /// values the current build does not know about (e.g. legacy data).
  static UnitType? fromDbValue(String value) {
    for (final type in values) {
      if (type.dbValue == value) return type;
    }
    return null;
  }
}

/// Domain model of a unit of measure.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code.
class Unit {
  const Unit({
    required this.id,
    required this.unitName,
    required this.unitSymbol,
    required this.unitFamily,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  final String unitName;

  /// Short abbreviation, e.g. `kg`.
  final String unitSymbol;

  /// Family value from [UnitType], e.g. `WEIGHT`.
  final String unitFamily;

  final String? description;

  final bool isActive;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// A copy of this entity with the given fields replaced.
  Unit copyWith({
    String? unitName,
    String? unitSymbol,
    String? unitFamily,
    String? description,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Unit(
      id: id,
      unitName: unitName ?? this.unitName,
      unitSymbol: unitSymbol ?? this.unitSymbol,
      unitFamily: unitFamily ?? this.unitFamily,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
