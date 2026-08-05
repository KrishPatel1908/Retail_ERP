import 'dart:io';

import 'package:drift/drift.dart' hide DatabaseConnection;
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'exceptions/database_exceptions.dart';

/// Creates the [QueryExecutor]s used by the application database.
///
/// The application owns exactly one on-disk database, `RetailERP.db`, stored
/// in the platform-specific application support directory:
/// - macOS: `~/Library/Application Support/<bundle-id>/RetailERP.db`
/// - Windows: `%APPDATA%\<app>\RetailERP.db`
class DatabaseConnection {
  const DatabaseConnection._();

  /// File name of the single application database.
  static const String databaseFileName = 'RetailERP.db';

  /// Creates the production [QueryExecutor] backed by `RetailERP.db`.
  ///
  /// The connection is lazy: the file is only opened on the first query.
  /// Errors while resolving the directory or opening the file are reported as
  /// [DatabaseConnectionException]. SQLite runs on a background isolate via
  /// [NativeDatabase.createInBackground] so database work never blocks the UI
  /// isolate.
  static QueryExecutor create() {
    return LazyDatabase(() async {
      try {
        final directory = await getApplicationSupportDirectory();
        await Directory(directory.path).create(recursive: true);
        final file = File(p.join(directory.path, databaseFileName));
        return NativeDatabase.createInBackground(file);
      } on AppDatabaseException {
        rethrow;
      } on Exception catch (error, stackTrace) {
        throw DatabaseConnectionException(
          'Failed to open the database file "$databaseFileName".',
          cause: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  /// Creates an in-memory [QueryExecutor], used by tests.
  static QueryExecutor inMemory() => NativeDatabase.memory();
}
