import 'package:drift/drift.dart' hide DatabaseConnection;

import 'app_database.dart';
import 'database_connection.dart';
import 'exceptions/database_exceptions.dart';

/// Owns the single [AppDatabase] instance for the application's lifetime.
///
/// Access the shared instance through [DatabaseProvider.instance]. The
/// database is created lazily on the first call to [initialize] and lives
/// until [close] is called.
class DatabaseProvider {
  DatabaseProvider._();

  /// The global singleton.
  static final DatabaseProvider instance = DatabaseProvider._();

  AppDatabase? _database;

  /// Whether the database has been initialized and not yet closed.
  bool get isInitialized => _database != null;

  /// The initialized database.
  ///
  /// Throws [DatabaseNotInitializedException] if [initialize] has not been
  /// called yet, or after [close] has been called.
  AppDatabase get database {
    final database = _database;
    if (database == null) {
      throw const DatabaseNotInitializedException();
    }
    return database;
  }

  /// Initializes the database, or returns the already-initialized instance.
  ///
  /// [connection] allows tests to inject an in-memory executor; when omitted
  /// the production file connection ([DatabaseConnection.create]) is used.
  /// Opening the connection also runs the configured migrations and seeds the
  /// reference data on first launch.
  ///
  /// Failures during open or migration leave the provider uninitialized so a
  /// later retry can start from a clean state.
  Future<AppDatabase> initialize({QueryExecutor? connection}) async {
    final existing = _database;
    if (existing != null) return existing;

    final executor = connection ?? DatabaseConnection.create();
    final database = AppDatabase(executor);
    _database = database;
    try {
      // Force the lazy connection to open and run migrations now so that
      // failures surface here instead of on the first query.
      await database.customSelect('SELECT 1').get();
      return database;
    } catch (_) {
      _database = null;
      await database.close();
      rethrow;
    }
  }

  /// Closes the database and releases all resources. Safe to call when the
  /// database was never opened.
  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }
}
