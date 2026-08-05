import 'package:flutter/material.dart';

import 'app/retail_erp_app.dart';
import 'core/database/database_initializer.dart';
import 'core/database/exceptions/database_exceptions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseInitializer.instance.initialize();
  } on AppDatabaseException catch (error) {
    // Keep the shell alive; affected pages surface their own error states.
    debugPrint('Database initialization failed: $error');
  }
  runApp(const RetailErpApp());
}
