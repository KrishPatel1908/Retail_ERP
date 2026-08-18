import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';

/// Small pill showing whether a customer or supplier is active or inactive.
///
/// Shared by both party tables so the status treatment stays identical.
class PartyStatusBadge extends StatelessWidget {
  const PartyStatusBadge({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF15803D) : AppTheme.textSecondary;
    final background = isActive
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFF1F5F9);
    final borderColor = isActive
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFE2E8F0);
    final dotColor = isActive ? AppTheme.success : AppTheme.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              isActive ? 'Active' : 'Inactive',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
