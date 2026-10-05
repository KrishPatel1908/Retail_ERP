import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Shows a confirmation dialog before clearing the active POS cart.
Future<bool> showClearCartDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Clear Cart'),
      content: const Text(
        'Clear all items from this sale? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Clear Cart'),
        ),
      ],
    ),
  );
  return result ?? false;
}
