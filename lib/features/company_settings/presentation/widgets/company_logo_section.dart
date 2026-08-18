import 'dart:io';

import 'package:flutter/material.dart';

/// "Company Logo" section: previews the current logo and offers upload,
/// replace and remove actions.
///
/// [previewPath] is the file to preview — the stored logo path or the
/// freshly picked file. When it is missing or unreadable the placeholder is
/// shown instead, so the section never breaks on a stale reference.
class CompanyLogoSection extends StatelessWidget {
  const CompanyLogoSection({
    super.key,
    required this.previewPath,
    required this.onUpload,
    required this.onRemove,
    this.busy = false,
  });

  /// Absolute path of the file to preview, or `null` when no logo is set.
  final String? previewPath;

  final VoidCallback onUpload;
  final VoidCallback onRemove;

  /// Disables the actions while a pick/upload is in progress.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasLogo = previewPath != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoPreview(
          path: previewPath,
          colorScheme: colorScheme,
          onTap: busy ? null : onUpload,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasLogo
                    ? 'Your logo will appear on invoices, receipts and reports.'
                    : 'Upload a square logo (PNG, JPG, WEBP or BMP, up to 5 MB).',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    key: const ValueKey('company-settings-logo-upload'),
                    onPressed: busy ? null : onUpload,
                    icon: const Icon(Icons.upload_rounded, size: 18),
                    label: Text(hasLogo ? 'Replace Logo' : 'Upload Logo'),
                  ),
                  if (hasLogo)
                    TextButton(
                      key: const ValueKey('company-settings-logo-remove'),
                      onPressed: busy ? null : onRemove,
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                      child: const Text('Remove'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoPreview extends StatelessWidget {
  const _LogoPreview({
    required this.path,
    required this.colorScheme,
    this.onTap,
  });

  final String? path;
  final ColorScheme colorScheme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 36,
            color: colorScheme.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    return Tooltip(
      message: 'Click to choose logo file',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: (path == null || !File(path!).existsSync())
                ? placeholder
                : Image.file(
                    File(path!),
                    key: ValueKey(
                      '${path}_${File(path!).existsSync() ? File(path!).lastModifiedSync().millisecondsSinceEpoch : 0}',
                    ),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => placeholder,
                  ),
          ),
        ),
      ),
    );
  }
}
