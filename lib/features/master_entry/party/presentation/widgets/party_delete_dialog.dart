import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';

/// Shows the shared destructive-action confirmation dialog used by the
/// customer and supplier list pages.
///
/// Returns `true` when the user confirmed the delete, `false` otherwise.
Future<bool> showPartyDeleteConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
