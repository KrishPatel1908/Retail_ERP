import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_theme.dart';

/// Reusable Description Preview widget for data table cells and list views.
///
/// Displays a truncated description string with an ellipsis ("...").
/// When non-empty, clicking the description opens a centered dialog displaying
/// the full, unwrapped description text with copy and close actions.
///
/// If [description] is null or empty, displays "—" and disables interaction.
class DescriptionPreview extends StatelessWidget {
  const DescriptionPreview({
    super.key,
    required this.description,
    this.style,
    this.maxLines = 1,
  });

  final String? description;
  final TextStyle? style;
  final int maxLines;

  bool get _hasDescription =>
      description != null && description!.trim().isNotEmpty;

  void _showFullDescription(BuildContext context) {
    if (!_hasDescription) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _DescriptionDialog(
        description: description!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final defaultMutedStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    final effectiveStyle = style ?? defaultMutedStyle;

    if (!_hasDescription) {
      return Text(
        '—',
        style: effectiveStyle,
      );
    }

    return Tooltip(
      message: 'Click to view full description',
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showFullDescription(context),
          behavior: HitTestBehavior.opaque,
          child: Text(
            description!.trim(),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: effectiveStyle?.copyWith(
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionDialog extends StatefulWidget {
  const _DescriptionDialog({required this.description});

  final String description;

  @override
  State<_DescriptionDialog> createState() => _DescriptionDialogState();
}

class _DescriptionDialogState extends State<_DescriptionDialog> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.description));
    if (!mounted) return;
    setState(() => _copied = true);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Description copied to clipboard.'),
          duration: Duration(seconds: 2),
        ),
      );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      backgroundColor: colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 520,
          maxHeight: 480,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Description',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  child: SelectableText(
                    widget.description,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 16,
                    ),
                    label: Text(_copied ? 'Copied' : 'Copy'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
