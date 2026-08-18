import 'package:flutter/material.dart';

/// A compact, rounded search text field with a search icon and clear button.
///
/// Owns its value locally; filtering behaviour is delegated to [onChanged].
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.hintText = 'Search',
    this.width,
    this.onChanged,
  });

  final String hintText;
  final double? width;
  final ValueChanged<String>? onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final field = TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() => _hasText = value.isNotEmpty);
        widget.onChanged?.call(value);
      },
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 18,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _hasText
            ? IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close_rounded, size: 16),
                onPressed: _clear,
              )
            : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: field);
    }
    return field;
  }
}
