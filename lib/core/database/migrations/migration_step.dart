import 'package:drift/drift.dart';

import '../app_database.dart';

/// A single versioned schema upgrade step.
///
/// [migrator] provides the DDL helpers, [database] the connection for data
/// backfills. Register steps in the `_UpgradeSteps` registry inside
/// [DatabaseMigrationStrategy].
typedef MigrationStep =
    Future<void> Function(Migrator migrator, AppDatabase database);
