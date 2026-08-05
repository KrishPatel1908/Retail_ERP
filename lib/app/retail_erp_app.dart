import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../features/shell/shell_page.dart';
import 'theme/app_theme.dart';

/// Root widget of the Retail ERP desktop application.
class RetailErpApp extends StatelessWidget {
  const RetailErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ShellPage(),
    );
  }
}
