import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'company_logo_storage.dart';

/// Persists the company background cover banner outside the database.
///
/// Only surfaced on the Profile View (outside of the edit form) as a stylish
/// custom cover photo banner.
class CompanyBannerStorage {
  CompanyBannerStorage({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _directoryProvider;

  static const List<String> supportedExtensions = [
    'png',
    'jpg',
    'jpeg',
    'webp',
    'bmp',
  ];

  /// Maximum banner file size (5 MB) — medium size for crisp display.
  static const int maxBytes = 5 * 1024 * 1024;

  /// Checks [source] without copying it.
  Future<void> validate(File source) async {
    final extension = _extensionOf(source.path);
    if (!supportedExtensions.contains(extension)) {
      throw CompanyLogoException(
        'Only ${supportedExtensions.join(', ')} images are supported for banner.',
      );
    }
    final size = await source.length();
    if (size > maxBytes) {
      throw const CompanyLogoException(
        'Banner image must be 5 MB or smaller. Please choose a smaller image.',
      );
    }
  }

  /// Returns the current stored banner path if one exists.
  Future<String?> getStoredBannerPath() async {
    try {
      final directory = await _directoryProvider().timeout(
        const Duration(milliseconds: 100),
        onTimeout: () => Directory.systemTemp,
      );
      for (final ext in supportedExtensions) {
        final file = File(p.join(directory.path, 'company_banner.$ext'));
        if (file.existsSync()) {
          return file.path;
        }
      }
    } catch (_) {
      // Safe fallback when path_provider is not mocked or unavailable.
    }
    return null;
  }

  /// Validates and stores the banner file, replacing any existing banner.
  Future<String> store(File source) async {
    await validate(source);
    final extension = _extensionOf(source.path);
    final directory = await _directoryProvider();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    // Delete any previous banner files
    await delete();

    final target = File(p.join(directory.path, 'company_banner.$extension'));
    await source.copy(target.path);
    return target.path;
  }

  /// Removes any existing banner file.
  Future<void> delete() async {
    final directory = await _directoryProvider();
    for (final ext in supportedExtensions) {
      final file = File(p.join(directory.path, 'company_banner.$ext'));
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0 || dot == path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }
}
