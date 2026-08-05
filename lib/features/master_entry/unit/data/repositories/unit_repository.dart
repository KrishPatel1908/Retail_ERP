import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/unit.dart';
import '../../domain/exceptions/unit_exceptions.dart';

/// Data access for units of measure.
///
/// The single entry point the presentation layer uses to read and write
/// units. Drift types never leak past this class: callers receive and return
/// [Unit] domain entities only.
class UnitRepository {
  UnitRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All units, ordered case-insensitively by name.
  Future<List<Unit>> getAllUnits() async {
    final rows = await (_database.select(
      _database.units,
    )..orderBy([(t) => OrderingTerm.asc(t.unitName.lower())])).get();
    return rows.map(_toEntity).toList();
  }

  /// Case-insensitive search by name or symbol. An empty query returns all
  /// units.
  Future<List<Unit>> searchUnits(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllUnits();
    }
    final rows = await (_database.select(
      _database.units,
    )..where(
        (t) =>
            t.unitName.lower().contains(normalized) |
            t.unitSymbol.lower().contains(normalized),
      )..orderBy([(t) => OrderingTerm.asc(t.unitName.lower())])).get();
    return rows.map(_toEntity).toList();
  }

  /// Whether a unit with this name (case-insensitive) exists.
  ///
  /// [excludeId] ignores a single unit, used when checking name uniqueness
  /// during an edit.
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final normalized = name.trim().toLowerCase();
    final row = await (_database.select(_database.units)..where((t) {
      final matches = t.unitName.lower().equals(normalized);
      if (excludeId == null) {
        return matches;
      }
      return matches & t.id.isNotValue(excludeId);
    })).getSingleOrNull();
    return row != null;
  }

  /// Creates a unit and returns the stored entity.
  ///
  /// Throws [UnitAlreadyExistsException] when the name is already taken.
  Future<Unit> createUnit({
    required String name,
    required String symbol,
    required String family,
    String? description,
    bool isActive = true,
  }) async {
    final trimmedName = name.trim();
    final trimmedSymbol = symbol.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName)) {
      throw UnitAlreadyExistsException(trimmedName);
    }

    try {
      final id = await _database.into(_database.units).insert(
        db.UnitsCompanion.insert(
          unitName: trimmedName,
          unitSymbol: trimmedSymbol,
          unitFamily: Value(family),
          description: Value(trimmedDescription),
          isActive: Value(isActive),
        ),
      );
      return _toEntity(await _getById(id));
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName)) {
        throw UnitAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to create unit.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing unit and returns the updated entity.
  ///
  /// Throws [UnitAlreadyExistsException] when the new name collides with
  /// another unit, and [UnitNotFoundException] when the unit no longer
  /// exists.
  Future<Unit> updateUnit(
    int id, {
    required String name,
    required String symbol,
    required String family,
    String? description,
    bool? isActive,
  }) async {
    final trimmedName = name.trim();
    final trimmedSymbol = symbol.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, excludeId: id)) {
      throw UnitAlreadyExistsException(trimmedName);
    }

    try {
      final updatedRows =
          await (_database.update(
            _database.units,
          )..where((t) => t.id.equals(id))).write(
            db.UnitsCompanion(
              unitName: Value(trimmedName),
              unitSymbol: Value(trimmedSymbol),
              unitFamily: Value(family),
              description: Value(trimmedDescription),
              isActive: isActive == null
                  ? const Value.absent()
                  : Value(isActive),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw UnitNotFoundException(id);
      }
      return _toEntity(await _getById(id));
    } on UnitNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw UnitAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to update unit.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a unit.
  ///
  /// Throws [UnitInUseException] when other records reference the unit
  /// (e.g. global UOM conversions, product UOM conversions or products),
  /// which SQLite enforces via foreign keys.
  Future<void> deleteUnit(int id) async {
    try {
      await (_database.delete(
        _database.units,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const UnitInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete unit.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  // --- Internals -----------------------------------------------------------

  String? _normalizeDescription(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<db.Unit> _getById(int id) async {
    final row = await (_database.select(
      _database.units,
    )..where((t) => t.id.equals(id))).getSingle();
    return row;
  }

  Unit _toEntity(db.Unit row) {
    return Unit(
      id: row.id,
      unitName: row.unitName,
      unitSymbol: row.unitSymbol,
      unitFamily: row.unitFamily,
      description: row.description,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// SQLite extended result code for a UNIQUE constraint violation.
  static const int _sqliteConstraintUnique = 2067;

  /// SQLite extended result code for a FOREIGN KEY constraint violation.
  static const int _sqliteConstraintForeignKey = 787;

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

  bool _isForeignKeyViolation(Object error) {
    return _asSqliteException(error)?.extendedResultCode ==
        _sqliteConstraintForeignKey;
  }
}
