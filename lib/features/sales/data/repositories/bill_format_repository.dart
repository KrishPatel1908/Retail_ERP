import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/bill_format_settings.dart';

/// Repository for persisting and retrieving Bill Format Settings.
///
/// Uses an application document JSON file with in-memory caching so settings
/// persist across app restarts and can be read synchronously if already loaded.
class BillFormatRepository {
  BillFormatRepository._();

  static final BillFormatRepository instance = BillFormatRepository._();

  static BillFormatSettings _current = const BillFormatSettings();
  static bool _loaded = false;

  /// Returns the current in-memory settings (or default if not loaded yet).
  BillFormatSettings get currentSettings => _current;

  /// Loads settings from disk. Returns default if file does not exist or fails.
  Future<BillFormatSettings> loadSettings() async {
    if (_loaded) return _current;

    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final jsonMap = jsonDecode(content) as Map<String, dynamic>;
          _current = BillFormatSettings.fromJson(jsonMap);
          _loaded = true;
          return _current;
        }
      }
    } catch (_) {
      // Fallback to default if reading fails
    }

    _current = const BillFormatSettings();
    _loaded = true;
    return _current;
  }

  /// Saves the given settings to persistent disk storage and updates cache.
  Future<void> saveSettings(BillFormatSettings settings) async {
    _current = settings;
    _loaded = true;

    try {
      final file = await _getSettingsFile();
      final jsonString = jsonEncode(settings.toJson());
      await file.writeAsString(jsonString, flush: true);
    } catch (_) {
      // Ignore or handle gracefully
    }
  }

  Future<File> _getSettingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final settingsDir = Directory('${dir.path}/retail_erp_settings');
    if (!await settingsDir.exists()) {
      await settingsDir.create(recursive: true);
    }
    return File('${settingsDir.path}/bill_format_settings.json');
  }

  /// Resets repository state (used for testing).
  void resetForTest([BillFormatSettings? initial]) {
    _current = initial ?? const BillFormatSettings();
    _loaded = true;
  }
}
