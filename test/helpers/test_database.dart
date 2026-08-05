import 'package:drift/native.dart';

import 'package:retail_erp/core/database/database_provider.dart';

/// Closes any previous database and opens a fresh in-memory database through
/// the singleton [DatabaseProvider], giving each test isolated state.
///
/// Widget tests that pump [RetailErpApp] must call this in `setUp` so that
/// pages backed by the repository find an initialized database.
Future<void> resetTestDatabase() async {
  await DatabaseProvider.instance.close();
  await DatabaseProvider.instance.initialize(
    connection: NativeDatabase.memory(),
  );
}
