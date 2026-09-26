import 'package:drift/drift.dart';

import '../app_database.dart';
import '../exceptions/database_exceptions.dart';
import 'database_indexes.dart';
import 'database_seeder.dart';
import 'migration_step.dart';
import 'migration_versions.dart';
import 'upgrade_to_v2.dart';
import 'upgrade_to_v3.dart';
import 'upgrade_to_v4.dart';
import 'upgrade_to_v5.dart';
import 'upgrade_to_v6.dart';
import 'upgrade_to_v7.dart';
import 'upgrade_to_v8.dart';
import 'upgrade_to_v9.dart';
import 'upgrade_to_v10.dart';
import 'upgrade_to_v11.dart';
import 'upgrade_to_v12.dart';
import 'upgrade_to_v13.dart';
import 'upgrade_to_v14.dart';
import 'upgrade_to_v15.dart';

/// Builds the [MigrationStrategy] used by [AppDatabase].
///
/// Strategy:
/// - **On create:** create all tables, create the blueprint's
///   case-insensitive unique indexes, then seed the reference data.
/// - **On upgrade:** run registered versioned steps one by one
///   (see [_UpgradeSteps]).
/// - **Before open:** enable foreign keys, WAL journal mode and a busy
///   timeout on every connection.
class DatabaseMigrationStrategy {
  const DatabaseMigrationStrategy(this._db);

  final AppDatabase _db;

  MigrationStrategy get strategy => MigrationStrategy(
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
    beforeOpen: _beforeOpen,
  );

  Future<void> _onCreate(Migrator migrator) async {
    try {
      await migrator.createAll();
      await DatabaseIndexes.create(_db);
      await DatabaseSeeder(_db).seed();
    } on AppDatabaseException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw DatabaseMigrationException(
        'Failed to create the database schema '
        '(v${DatabaseSchemaVersion.latest}).',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onUpgrade(Migrator migrator, int from, int to) async {
    try {
      final steps = _UpgradeSteps.all;
      for (var version = from + 1; version <= to; version++) {
        final step = steps[version];
        if (step == null) {
          throw StateError(
            'No migration step registered for schema version v$version.',
          );
        }
        await step(migrator, _db);
      }
    } on AppDatabaseException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw DatabaseMigrationException(
        'Failed to migrate the database schema from v$from to v$to.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _beforeOpen(OpeningDetails details) async {
    // Foreign keys are disabled by default in SQLite — enable per connection.
    await _db.customStatement('PRAGMA foreign_keys = ON');
    // WAL improves durability and read concurrency on desktop. It is a no-op
    // for in-memory databases used by tests.
    await _db.customStatement('PRAGMA journal_mode = WAL');
    // Prevents "database is locked" errors under concurrent access.
    await _db.customStatement('PRAGMA busy_timeout = 5000');
  }
}

/// Registered, versioned upgrade steps.
///
/// The map key is the target schema version. Version 1 is the initial schema
/// and has no steps; future versions add one entry each.
abstract final class _UpgradeSteps {
  static const Map<int, MigrationStep> all = {
    2: upgradeToV2,
    3: upgradeToV3,
    4: upgradeToV4,
    5: upgradeToV5,
    6: upgradeToV6,
    7: upgradeToV7,
    8: upgradeToV8,
    9: upgradeToV9,
    10: upgradeToV10,
    11: upgradeToV11,
    12: upgradeToV12,
    13: upgradeToV13,
    14: upgradeToV14,
    15: upgradeToV15,
  };
}
