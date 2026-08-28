import 'package:flutter/material.dart';

import 'ds_field_theme.dart';

class DsTextField extends StatelessWidget {
  const DsTextField({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsFieldTheme>()!;
    return TextField(decoration: theme.decoration.copyWith(labelText: label));
  }
}
