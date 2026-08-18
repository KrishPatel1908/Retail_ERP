import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Raised when a logo file is rejected (unsupported type or too large) or
/// cannot be stored.
class CompanyLogoException implements Exception {
  const CompanyLogoException(this.message);

  final String message;

  @override
  String toString() => 'CompanyLogoException: $message';
}

/// Persists the company logo as a file outside the database and returns the
/// file path that is stored in `company_settings.logo_path`.
///
/// Only a small reference is ever stored in the database — never the raw
/// image bytes. The file lives in the application support directory so it
/// survives across sessions.
class CompanyLogoStorage {
  CompanyLogoStorage({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _directoryProvider;

  /// Image extensions accepted for the logo.
  static const List<String> supportedExtensions = [
    'png',
    'jpg',
    'jpeg',
    'webp',
    'bmp',
  ];

  /// Maximum logo file size (5 MB) — medium size for crisp print and display logos.
  static const int maxBytes = 5 * 1024 * 1024;

  /// Checks [source] without copying it, throwing [CompanyLogoException] for
  /// unsupported types or oversized files. Used to fail fast at pick time.
  Future<void> validate(File source) async {
    final extension = _extensionOf(source.path);
    if (!supportedExtensions.contains(extension)) {
      throw CompanyLogoException(
        'Only ${supportedExtensions.join(', ')} images are supported.',
      );
    }
    final size = await source.length();
    if (size > maxBytes) {
      throw const CompanyLogoException(
        'Logo must be 5 MB or smaller. Please choose a smaller image.',
      );
    }
  }

  /// Validates [source] and copies it into the application support directory,
  /// returning the absolute path of the stored copy. Throws
  /// [CompanyLogoException] for unsupported types or oversized files.
  Future<String> store(File source) async {
    await validate(source);
    final extension = _extensionOf(source.path);
    final directory = await _directoryProvider();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final target = File(p.join(directory.path, 'company_logo.$extension'));
    await source.copy(target.path);
    return target.path;
  }

  /// Removes a previously stored logo file. Missing files are a no-op.
  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0 || dot == path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }
}
