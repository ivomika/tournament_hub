import 'package:flutter/material.dart';

import 'ds_select_theme.dart';

class DsSelectOption<T> {
  const DsSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

class DsSelect<T> extends StatelessWidget {
  const DsSelect({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String label;
  final T value;
  final List<DsSelectOption<T>> options;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSelectTheme>()!;
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      menuMaxHeight: theme.menuMaxHeight,
      decoration: theme.decoration.copyWith(labelText: label),
      items: [
        for (final option in options)
          DropdownMenuItem<T>(value: option.value, child: Text(option.label)),
      ],
      onChanged: enabled && onChanged != null
          ? (selected) {
              if (selected != null) onChanged!(selected);
            }
          : null,
    );
  }
}
