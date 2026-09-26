import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/uom_conversion.dart';
import '../../domain/exceptions/uom_conversion_exceptions.dart';

/// Data access for global unit conversions.
///
/// The single entry point the presentation layer uses to read and write
/// conversions. Drift types never leak past this class: callers receive and
/// return [UomConversion] domain entities only.
class UomConversionRepository {
  UomConversionRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All conversions, ordered by the from-unit name then the to-unit name.
  Future<List<UomConversion>> getAllConversions() async {
    final rows = await (_database.select(
      _database.uomConversions,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return _mapWithUnits(rows);
  }

  /// Case-insensitive search over the from/to unit names and symbols. An
  /// empty query returns all conversions.
  Future<List<UomConversion>> searchConversions(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllConversions();
    }
    final all = await getAllConversions();
    return all.where((conversion) {
      return conversion.fromUnitName.toLowerCase().contains(normalized) ||
          conversion.fromUnitSymbol.toLowerCase().contains(normalized) ||
          conversion.toUnitName.toLowerCase().contains(normalized) ||
          conversion.toUnitSymbol.toLowerCase().contains(normalized);
    }).toList();
  }

  /// Whether a conversion already exists between [fromUnitId] and
  /// [toUnitId] in *either* direction. [excludeId] ignores a single row
  /// (used when editing).
  Future<bool> existsBetween(
    int fromUnitId,
    int toUnitId, {
    int? excludeId,
  }) async {
    final t = _database.uomConversions;
    final sameDirection =
        t.fromUnitId.equals(fromUnitId) & t.toUnitId.equals(toUnitId);
    final reverse =
        t.fromUnitId.equals(toUnitId) & t.toUnitId.equals(fromUnitId);
    var matches = sameDirection | reverse;
    if (excludeId != null) {
      matches = matches & t.id.isNotValue(excludeId);
    }
    final row = await (_database.selectOnly(t)
          ..addColumns([t.id])
          ..where(matches)
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  /// Creates a conversion and returns the stored entity.
  ///
  /// Throws [UomConversionAlreadyExistsException] when a conversion between
  /// these units already exists in either direction, and [ArgumentError]
  /// when the units are identical or the factor is not positive.
  Future<UomConversion> createConversion({
    required int fromUnitId,
    required int toUnitId,
    required double conversionFactor,
    String? description,
  }) async {
    _validate(fromUnitId, toUnitId, conversionFactor);

    if (await existsBetween(fromUnitId, toUnitId)) {
      throw const UomConversionAlreadyExistsException();
    }

    try {
      final id = await _database
          .into(_database.uomConversions)
          .insert(
            db.UomConversionsCompanion.insert(
              fromUnitId: fromUnitId,
              toUnitId: toUnitId,
              conversionFactor: conversionFactor,
              description: Value(_normalizeDescription(description)),
            ),
          );
      final rows = await (_database.select(
        _database.uomConversions,
      )..where((t) => t.id.equals(id))).get();
      return (await _mapWithUnits(rows)).single;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const UomConversionAlreadyExistsException();
      }
      throw DatabaseOperationException(
        'Failed to create conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing conversion and returns the updated entity.
  ///
  /// Throws [UomConversionNotFoundException] when the row no longer exists
  /// and [UomConversionAlreadyExistsException] when the new unit pair
  /// collides with another conversion.
  Future<UomConversion> updateConversion(
    int id, {
    required int fromUnitId,
    required int toUnitId,
    required double conversionFactor,
    String? description,
  }) async {
    _validate(fromUnitId, toUnitId, conversionFactor);

    if (await existsBetween(fromUnitId, toUnitId, excludeId: id)) {
      throw const UomConversionAlreadyExistsException();
    }

    try {
      final updatedRows =
          await (_database.update(
            _database.uomConversions,
          )..where((t) => t.id.equals(id))).write(
            db.UomConversionsCompanion(
              fromUnitId: Value(fromUnitId),
              toUnitId: Value(toUnitId),
              conversionFactor: Value(conversionFactor),
              description: Value(_normalizeDescription(description)),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw UomConversionNotFoundException(id);
      }
      final rows = await (_database.select(
        _database.uomConversions,
      )..where((t) => t.id.equals(id))).get();
      return (await _mapWithUnits(rows)).single;
    } on UomConversionNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw const UomConversionAlreadyExistsException();
      }
      throw DatabaseOperationException(
        'Failed to update conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a conversion.
  Future<void> deleteConversion(int id) async {
    try {
      await (_database.delete(
        _database.uomConversions,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      throw DatabaseOperationException(
        'Failed to delete conversion.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Resolves the factor that converts a quantity from [fromUnitId] to
  /// [toUnitId], or `null` when no global conversion links the two units.
  ///
  /// A stored forward row is used directly; the reverse direction is derived
  /// as `1 / factor`. Identical units always resolve to `1.0`.
  Future<double?> resolveFactor(int fromUnitId, int toUnitId) async {
    if (fromUnitId == toUnitId) return 1.0;

    final forward =
        await (_database.select(_database.uomConversions)..where(
              (t) =>
                  t.fromUnitId.equals(fromUnitId) & t.toUnitId.equals(toUnitId),
            ))
            .getSingleOrNull();
    if (forward != null) return forward.conversionFactor;

    final reverse =
        await (_database.select(_database.uomConversions)..where(
              (t) =>
                  t.fromUnitId.equals(toUnitId) & t.toUnitId.equals(fromUnitId),
            ))
            .getSingleOrNull();
    if (reverse != null) return 1 / reverse.conversionFactor;

    return null;
  }

  // --- Internals -----------------------------------------------------------

  void _validate(int fromUnitId, int toUnitId, double conversionFactor) {
    if (fromUnitId == toUnitId) {
      throw ArgumentError('From and to units must be different.');
    }
    if (conversionFactor <= 0) {
      throw ArgumentError('Conversion factor must be greater than zero.');
    }
  }

  String? _normalizeDescription(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Resolves display names for the given conversion rows and sorts them by
  /// from-unit name then to-unit name (case-insensitive).
  Future<List<UomConversion>> _mapWithUnits(List<db.UomConversion> rows) async {
    if (rows.isEmpty) return const [];
    final units = await (_database.select(_database.units)).get();
    final byId = {for (final unit in units) unit.id: unit};

    final result = rows.map((row) {
      final from = byId[row.fromUnitId]!;
      final to = byId[row.toUnitId]!;
      return UomConversion(
        id: row.id,
        fromUnitId: row.fromUnitId,
        fromUnitName: from.unitName,
        fromUnitSymbol: from.unitSymbol,
        toUnitId: row.toUnitId,
        toUnitName: to.unitName,
        toUnitSymbol: to.unitSymbol,
        conversionFactor: row.conversionFactor,
        description: row.description,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();

    result.sort((a, b) {
      final byFrom = a.fromUnitName.toLowerCase().compareTo(
        b.fromUnitName.toLowerCase(),
      );
      if (byFrom != 0) return byFrom;
      return a.toUnitName.toLowerCase().compareTo(b.toUnitName.toLowerCase());
    });
    return result;
  }

  /// SQLite extended result code for a UNIQUE constraint violation.
  static const int _sqliteConstraintUnique = 2067;

  /// Extracts the underlying [SqliteException], whether it was thrown
  /// directly or wrapped by Drift.
  SqliteException? _asSqliteException(Object error) {
    return switch (error) {
      SqliteException exception => exception,
      DriftWrappedException(:final cause) when cause is SqliteException =>
        cause,
      _ => null,
    };
  }

  bool _isUniqueViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintUnique;
  }
}
