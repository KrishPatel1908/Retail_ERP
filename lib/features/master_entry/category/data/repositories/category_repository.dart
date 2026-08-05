import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/category.dart';
import '../../domain/exceptions/category_exceptions.dart';
import '../category_code_generator.dart';

/// Data access for categories.
///
/// The single entry point the presentation layer uses to read and write
/// categories. Drift types never leak past this class: callers receive and
/// return [Category] domain entities only.
class CategoryRepository {
  CategoryRepository({db.AppDatabase? database})
    : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All categories, ordered case-insensitively by name.
  Future<List<Category>> getAllCategories() async {
    final rows = await (_database.select(
      _database.categories,
    )..orderBy([(t) => OrderingTerm.asc(t.categoryName.lower())])).get();
    return rows.map(_toEntity).toList();
  }

  /// Case-insensitive search by name. An empty query returns all categories.
  Future<List<Category>> searchCategories(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllCategories();
    }
    final rows = await (_database.select(
      _database.categories,
    )..where((t) => t.categoryName.lower().contains(normalized))).get();
    return rows.map(_toEntity).toList();
  }

  /// Whether a category with this name (case-insensitive) exists.
  ///
  /// [excludeId] ignores a single category, used when checking name
  /// uniqueness during an edit.
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final normalized = name.trim().toLowerCase();
    final row =
        await (_database.select(_database.categories)..where((t) {
              final matches = t.categoryName.lower().equals(normalized);
              if (excludeId == null) {
                return matches;
              }
              return matches & t.id.isNotValue(excludeId);
            }))
            .getSingleOrNull();
    return row != null;
  }

  /// Creates a category and returns the stored entity.
  ///
  /// The category code is generated and the row inserted inside one
  /// transaction, so two rapid creates can never compute the same code. Throws
  /// [CategoryAlreadyExistsException] when the name is already taken.
  Future<Category> createCategory({
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName)) {
      throw CategoryAlreadyExistsException(trimmedName);
    }

    try {
      final id = await _database.transaction(() async {
        final code = await CategoryCodeGenerator.nextCode(_database);
        return _database
            .into(_database.categories)
            .insert(
              db.CategoriesCompanion.insert(
                categoryCode: code,
                categoryName: trimmedName,
                description: Value(trimmedDescription),
                isActive: Value(isActive),
              ),
            );
      });
      return _toEntity(await _getById(id));
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName)) {
        throw CategoryAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to create category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing category and returns the updated entity.
  ///
  /// Throws [CategoryAlreadyExistsException] when the new name collides with
  /// another category, and [CategoryNotFoundException] when the category no
  /// longer exists.
  Future<Category> updateCategory(
    int id, {
    required String name,
    String? description,
    bool? isActive,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, excludeId: id)) {
      throw CategoryAlreadyExistsException(trimmedName);
    }

    try {
      final updatedRows =
          await (_database.update(
            _database.categories,
          )..where((t) => t.id.equals(id))).write(
            db.CategoriesCompanion(
              categoryName: Value(trimmedName),
              description: Value(trimmedDescription),
              isActive: isActive == null
                  ? const Value.absent()
                  : Value(isActive),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw CategoryNotFoundException(id);
      }
      return _toEntity(await _getById(id));
    } on CategoryNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        throw CategoryAlreadyExistsException(trimmedName);
      }
      throw DatabaseOperationException(
        'Failed to update category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a category.
  ///
  /// Throws [CategoryInUseException] when other records reference the
  /// category (e.g. sub-categories), which SQLite enforces via a foreign key.
  Future<void> deleteCategory(int id) async {
    try {
      await (_database.delete(
        _database.categories,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const CategoryInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete category.',
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

  Future<db.Category> _getById(int id) async {
    final row = await (_database.select(
      _database.categories,
    )..where((t) => t.id.equals(id))).getSingle();
    return row;
  }

  Category _toEntity(db.Category row) {
    return Category(
      id: row.id,
      categoryCode: row.categoryCode,
      categoryName: row.categoryName,
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
