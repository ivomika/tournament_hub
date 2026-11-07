import 'package:flutter/material.dart';

enum AppTableAlignment { leading, trailing }

class AppTableColumn {
  const AppTableColumn({
    required this.label,
    this.alignment = AppTableAlignment.leading,
    this.semanticLabel,
  });
  final String label;
  final AppTableAlignment alignment;
  final String? semanticLabel;
}

sealed class AppTableCell {
  const AppTableCell();
}

class AppTableTextCell extends AppTableCell {
  const AppTableTextCell(this.text);
  final String text;
}

class AppTableIdentityCell extends AppTableCell {
  const AppTableIdentityCell({
    required this.primary,
    required this.secondary,
    required this.initials,
    this.avatarForeground,
  });
  final String primary, secondary, initials;
  final Color? avatarForeground;
}

class AppTableRow {
  const AppTableRow(this.cells);
  final List<AppTableCell> cells;
}
