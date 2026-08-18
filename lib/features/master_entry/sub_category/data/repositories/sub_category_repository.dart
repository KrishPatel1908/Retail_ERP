import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/entities/sub_category.dart';
import '../../domain/exceptions/sub_category_exceptions.dart';
import '../sub_category_code_generator.dart';

/// Data access for sub-categories.
///
/// The single entry point the presentation layer uses to read and write
/// sub-categories. Drift types never leak past this class: callers receive and
/// return [SubCategory] domain entities only.
class SubCategoryRepository {
  SubCategoryRepository({db.AppDatabase? database})
      : _database = database ?? DatabaseProvider.instance.database;

  final db.AppDatabase _database;

  /// All sub-categories joined with their parent category name, ordered
  /// case-insensitively by sub-category name.
  Future<List<SubCategory>> getAllSubCategories() async {
    final query = _database.select(_database.subCategories).join([
      innerJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.subCategories.categoryId),
      ),
    ])..orderBy([
        OrderingTerm.asc(_database.subCategories.subCategoryName.lower()),
      ]);

    final rows = await query.get();
    return rows.map(_fromTypedResult).toList();
  }

  /// Case-insensitive search by Category Name, Sub Category Name, Code, or Description.
  /// An empty query returns all sub-categories.
  Future<List<SubCategory>> searchSubCategories(String queryText) async {
    final normalized = queryText.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllSubCategories();
    }

    final query = _database.select(_database.subCategories).join([
      innerJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.subCategories.categoryId),
      ),
    ])
      ..where(
        _database.categories.categoryName.lower().contains(normalized) |
            _database.subCategories.subCategoryName
                .lower()
                .contains(normalized) |
            _database.subCategories.subCategoryCode
                .lower()
                .contains(normalized) |
            _database.subCategories.description.lower().contains(normalized),
      )
      ..orderBy([
        OrderingTerm.asc(_database.subCategories.subCategoryName.lower()),
      ]);

    final rows = await query.get();
    return rows.map(_fromTypedResult).toList();
  }

  /// Whether a sub-category with this name (case-insensitive) exists under
  /// the given [categoryId].
  ///
  /// [excludeId] ignores a single sub-category, used when checking name
  /// uniqueness during an edit.
  Future<bool> existsByName(
    String name,
    int categoryId, {
    int? excludeId,
  }) async {
    final normalized = name.trim().toLowerCase();
    final query = _database.select(_database.subCategories)
      ..where((t) {
        final matches = t.categoryId.equals(categoryId) &
            t.subCategoryName.lower().equals(normalized);
        if (excludeId == null) {
          return matches;
        }
        return matches & t.id.isNotValue(excludeId);
      });
    final row = await query.getSingleOrNull();
    return row != null;
  }

  /// Creates a sub-category and returns the stored entity.
  ///
  /// If [code] is omitted or empty, a code is generated sequentially inside a
  /// transaction. Throws [SubCategoryAlreadyExistsException] when the name is
  /// already taken under the same category.
  Future<SubCategory> createSubCategory({
    required int categoryId,
    required String name,
    String? code,
    String? description,
    bool isActive = true,
  }) async {
    final trimmedName = name.trim();
    final trimmedCode = code?.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, categoryId)) {
      final category = await _getCategoryById(categoryId);
      throw SubCategoryAlreadyExistsException(trimmedName, category?.categoryName);
    }

    try {
      final id = await _database.transaction(() async {
        final finalCode = (trimmedCode != null && trimmedCode.isNotEmpty)
            ? trimmedCode
            : await SubCategoryCodeGenerator.nextCode(_database);

        return _database.into(_database.subCategories).insert(
              db.SubCategoriesCompanion.insert(
                categoryId: categoryId,
                subCategoryCode: finalCode,
                subCategoryName: trimmedName,
                description: Value(trimmedDescription),
                isActive: Value(isActive),
              ),
            );
      });

      return await getById(id);
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error) && await existsByName(trimmedName, categoryId)) {
        final category = await _getCategoryById(categoryId);
        throw SubCategoryAlreadyExistsException(trimmedName, category?.categoryName);
      }
      throw DatabaseOperationException(
        'Failed to create sub-category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing sub-category and returns the updated entity.
  ///
  /// Throws [SubCategoryAlreadyExistsException] when the new name collides with
  /// another sub-category under the same category, and [SubCategoryNotFoundException]
  /// when the sub-category no longer exists.
  Future<SubCategory> updateSubCategory(
    int id, {
    required int categoryId,
    required String name,
    String? code,
    String? description,
    bool? isActive,
  }) async {
    final trimmedName = name.trim();
    final trimmedCode = code?.trim();
    final trimmedDescription = _normalizeDescription(description);

    if (await existsByName(trimmedName, categoryId, excludeId: id)) {
      final category = await _getCategoryById(categoryId);
      throw SubCategoryAlreadyExistsException(trimmedName, category?.categoryName);
    }

    try {
      final updatedRows = await (_database.update(_database.subCategories)
            ..where((t) => t.id.equals(id)))
          .write(
        db.SubCategoriesCompanion(
          categoryId: Value(categoryId),
          subCategoryName: Value(trimmedName),
          subCategoryCode: (trimmedCode != null && trimmedCode.isNotEmpty)
              ? Value(trimmedCode)
              : const Value.absent(),
          description: Value(trimmedDescription),
          isActive: isActive == null
              ? const Value.absent()
              : Value(isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );

      if (updatedRows == 0) {
        throw SubCategoryNotFoundException(id);
      }

      return await getById(id);
    } on SubCategoryNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (_isUniqueViolation(error)) {
        final category = await _getCategoryById(categoryId);
        throw SubCategoryAlreadyExistsException(trimmedName, category?.categoryName);
      }
      throw DatabaseOperationException(
        'Failed to update sub-category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a sub-category.
  ///
  /// Throws [SubCategoryInUseException] when other records (e.g. products)
  /// reference the sub-category.
  Future<void> deleteSubCategory(int id) async {
    try {
      await (_database.delete(_database.subCategories)
            ..where((t) => t.id.equals(id)))
          .go();
    } on Exception catch (error, stackTrace) {
      if (_isForeignKeyViolation(error)) {
        throw const SubCategoryInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete sub-category.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieves a sub-category entity by id, joined with category name.
  Future<SubCategory> getById(int id) async {
    final query = _database.select(_database.subCategories).join([
      innerJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.subCategories.categoryId),
      ),
    ])..where(_database.subCategories.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) {
      throw SubCategoryNotFoundException(id);
    }
    return _fromTypedResult(row);
  }

  // --- Internals -----------------------------------------------------------

  String? _normalizeDescription(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<db.Category?> _getCategoryById(int categoryId) async {
    return (_database.select(_database.categories)
          ..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
  }

  SubCategory _fromTypedResult(TypedResult row) {
    final subCategoryRow = row.readTable(_database.subCategories);
    final categoryRow = row.readTableOrNull(_database.categories);

    return SubCategory(
      id: subCategoryRow.id,
      categoryId: subCategoryRow.categoryId,
      categoryName: categoryRow?.categoryName,
      subCategoryCode: subCategoryRow.subCategoryCode,
      subCategoryName: subCategoryRow.subCategoryName,
      description: subCategoryRow.description,
      isActive: subCategoryRow.isActive,
      createdAt: subCategoryRow.createdAt,
      updatedAt: subCategoryRow.updatedAt,
    );
  }

  /// SQLite extended result code for a UNIQUE constraint violation.
  static const int _sqliteConstraintUnique = 2067;

  /// SQLite extended result code for a FOREIGN KEY constraint violation.
  static const int _sqliteConstraintForeignKey = 787;

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
