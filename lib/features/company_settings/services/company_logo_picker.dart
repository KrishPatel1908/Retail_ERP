import 'dart:io';

import 'package:file_selector/file_selector.dart';

import 'company_logo_storage.dart';

/// Opens the native file dialog for choosing a logo image.
///
/// The dialog filters to the supported image types; [CompanyLogoStorage]
/// re-validates the selection so the two layers stay consistent.
class CompanyLogoPicker {
  const CompanyLogoPicker();

  /// Returns the selected file, or `null` when the user cancelled.
  Future<File?> pick() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Images',
        extensions: CompanyLogoStorage.supportedExtensions,
        uniformTypeIdentifiers: [
          'public.image',
          'public.png',
          'public.jpeg',
          'org.webmproject.webp',
          'com.microsoft.bmp',
        ],
        mimeTypes: ['image/*'],
      );
      final file = await openFile(acceptedTypeGroups: const [typeGroup]);
      return file == null ? null : File(file.path);
    } catch (_) {
      try {
        const fallbackGroup = XTypeGroup(
          label: 'Images',
          extensions: CompanyLogoStorage.supportedExtensions,
        );
        final file = await openFile(acceptedTypeGroups: const [fallbackGroup]);
        return file == null ? null : File(file.path);
      } catch (_) {
        final file = await openFile();
        return file == null ? null : File(file.path);
      }
    }
  }
}
