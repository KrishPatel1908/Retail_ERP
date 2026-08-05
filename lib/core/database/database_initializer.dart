import 'package:drift/drift.dart';

import 'app_database.dart';
import 'database_provider.dart';
import 'exceptions/database_exceptions.dart';

/// Entry point for bootstrapping the application database.
///
/// Wraps [DatabaseProvider.initialize] with typed error handling so that
/// startup failures are always reported as an [AppDatabaseException]
/// subclass (initialization, migration, connection).
class DatabaseInitializer {
  DatabaseInitializer._();

  /// The global singleton.
  static final DatabaseInitializer instance = DatabaseInitializer._();

  /// Opens the database (creating the file and running migrations and seed
  /// data on first launch) and returns the single [AppDatabase] instance.
  ///
  /// [connection] is an optional override used by tests.
  Future<AppDatabase> initialize({QueryExecutor? connection}) async {
    try {
      return await DatabaseProvider.instance.initialize(connection: connection);
    } on AppDatabaseException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw DatabaseInitializationException(
        'Failed to initialize the application database.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Closes the database. Safe to call when it was never opened.
  Future<void> dispose() async {
    try {
      await DatabaseProvider.instance.close();
    } on Exception catch (error, stackTrace) {
      throw DatabaseConnectionException(
        'Failed to close the application database.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
