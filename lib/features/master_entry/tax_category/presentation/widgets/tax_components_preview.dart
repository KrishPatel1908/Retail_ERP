import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../domain/entities/tax_category_component.dart';

/// Displays tax components in a compact readable format (e.g. "CGST 9% + SGST 9%").
///
/// Clicking the cell opens a centered dialog displaying the complete list of tax components.
class TaxComponentsPreview extends StatelessWidget {
  const TaxComponentsPreview({
    super.key,
    required this.components,
    this.style,
    this.maxLines = 1,
  });

  final List<TaxCategoryComponent> components;
  final TextStyle? style;
  final int maxLines;

  static String formatComponents(List<TaxCategoryComponent> components) {
    if (components.isEmpty) return '—';
    return components
        .map((c) {
          final formattedPct = c.percentage.toStringAsFixed(
            c.percentage.truncateToDouble() == c.percentage ? 0 : 2,
          );
          return '${c.taxTypeName} $formattedPct%';
        })
        .join(' + ');
  }

  bool get _hasComponents => components.isNotEmpty;

  void _showFullComponents(BuildContext context) {
    if (!_hasComponents) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _TaxComponentsDialog(components: components),
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
    final formattedText = formatComponents(components);

    if (!_hasComponents) {
      return Text('—', style: effectiveStyle);
    }

    return Tooltip(
      message: 'Click to view full component details',
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showFullComponents(context),
          behavior: HitTestBehavior.opaque,
          child: Text(
            formattedText,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: effectiveStyle?.copyWith(decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }
}

class _TaxComponentsDialog extends StatefulWidget {
  const _TaxComponentsDialog({required this.components});

  final List<TaxCategoryComponent> components;

  @override
  State<_TaxComponentsDialog> createState() => _TaxComponentsDialogState();
}

class _TaxComponentsDialogState extends State<_TaxComponentsDialog> {
  bool _copied = false;

  String get _plainTextSummary =>
      TaxComponentsPreview.formatComponents(widget.components);

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _plainTextSummary));
    if (!mounted) return;
    setState(() => _copied = true);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Tax components copied to clipboard.'),
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
    final totalPercentage = widget.components.fold(
      0.0,
      (sum, item) => sum + item.percentage,
    );
    final formattedTotal = totalPercentage.toStringAsFixed(
      totalPercentage.truncateToDouble() == totalPercentage ? 0 : 2,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      backgroundColor: colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 480),
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
                        Icons.percent_rounded,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tax Components Breakdown',
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
                  child: Column(
                    children: widget.components.map((comp) {
                      final formattedPct = comp.percentage.toStringAsFixed(
                        comp.percentage.truncateToDouble() == comp.percentage
                            ? 0
                            : 2,
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comp.taxTypeName,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '$formattedPct%',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Tax Rate:',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '$formattedTotal%',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
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
