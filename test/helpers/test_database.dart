import 'package:drift/native.dart';

import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_service.dart';

/// Closes any previous database and opens a fresh in-memory database through
/// the singleton [DatabaseProvider], giving each test isolated state.
///
/// Widget tests that pump [RetailErpApp] must call this in `setUp` so that
/// pages backed by the repository find an initialized database. The company
/// settings process-wide cache is cleared so one test can never observe
/// another test's configuration.
Future<void> resetTestDatabase() async {
  CompanySettingsService.invalidateCache();
  await DatabaseProvider.instance.close();
  await DatabaseProvider.instance.initialize(
    connection: NativeDatabase.memory(),
  );
}
