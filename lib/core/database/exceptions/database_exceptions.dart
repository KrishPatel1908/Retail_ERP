/// Exception hierarchy for the database layer.
///
/// Every database failure is surfaced as one of the [AppDatabaseException]
/// subclasses so that callers never have to handle raw `SqliteException`s or
/// generic `Error`s.
sealed class AppDatabaseException implements Exception {
  const AppDatabaseException(this.message, {this.cause, this.stackTrace});

  /// A human-readable description of the failure.
  final String message;

  /// The underlying error that caused this failure, if any.
  final Object? cause;

  /// Stack trace captured at the failure site, if available.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final causeText = cause == null ? '' : '\nCause: $cause';
    return '$runtimeType: $message$causeText';
  }
}

/// Thrown when the application database cannot be created or opened.
final class DatabaseInitializationException extends AppDatabaseException {
  const DatabaseInitializationException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when a schema migration fails while opening the database.
final class DatabaseMigrationException extends AppDatabaseException {
  const DatabaseMigrationException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when the database connection could not be established.
final class DatabaseConnectionException extends AppDatabaseException {
  const DatabaseConnectionException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// Thrown for unexpected errors raised by database operations.
final class DatabaseOperationException extends AppDatabaseException {
  const DatabaseOperationException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when the database is accessed before it has been initialized
/// (or after it has been closed).
final class DatabaseNotInitializedException extends AppDatabaseException {
  const DatabaseNotInitializedException([
    super.message =
        'The database has not been initialized. '
        'Call DatabaseInitializer.instance.initialize() first.',
  ]);
}
