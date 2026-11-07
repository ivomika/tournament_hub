import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_data_table_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
export 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    required this.caption,
    required this.columns,
    required this.rows,
    super.key,
  });
  final String caption;
  final List<AppTableColumn> columns;
  final List<AppTableRow> rows;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _layout);
  Widget _layout(BuildContext context, BoxConstraints constraints) {
    final t = AppDataTableTheme.of(context), widths = <double>[];
    for (final (index, column) in columns.indexed) {
      double maxWidth = _width(column.label, t.headerStyle);
      if (column.alignment == AppTableAlignment.trailing &&
          maxWidth < t.minNumericWidth - t.padding.horizontal) {
        maxWidth = t.minNumericWidth - t.padding.horizontal;
      }
      for (final row in rows) {
        final cell = row.cells[index];
        final width = switch (cell) {
          AppTableTextCell() => _width(cell.text, t.cellStyle),
          AppTableIdentityCell() =>
            t.identity.avatar.extent +
                t.identityGap +
                _width(cell.primary, t.identity.primary),
        };
        if (width > maxWidth) maxWidth = width;
      }
      widths.add(maxWidth + t.padding.horizontal);
    }
    return Semantics(
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: t.stretch,
        children: [
          Text(caption, style: t.captionStyle),
          SizedBox(height: t.captionGap),
          Table(
            columnWidths: {
              for (final (index, width) in widths.indexed)
                index: FlexColumnWidth(width),
            },
            defaultVerticalAlignment: t.verticalAlignment,
            children: [
              TableRow(
                children: [
                  for (final column in columns)
                    Padding(
                      padding: t.padding,
                      child: Semantics(
                        header: true,
                        label: column.semanticLabel,
                        child: Text(
                          column.label,
                          style: t.headerStyle,
                          textAlign:
                              column.alignment == AppTableAlignment.trailing
                              ? t.trailing
                              : t.leading,
                        ),
                      ),
                    ),
                ],
              ),
              for (final row in rows)
                TableRow(
                  children: [
                    for (final (index, cell) in row.cells.indexed)
                      Padding(
                        padding: t.padding,
                        child: _DataCell(
                          cell: cell,
                          column: columns[index],
                          theme: t,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  double _width(String text, TextStyle style) {
    final p = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final result = p.width;
    p.dispose();
    return result;
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.cell,
    required this.column,
    required this.theme,
  });
  final AppTableCell cell;
  final AppTableColumn column;
  final AppDataTableTheme theme;
  @override
  Widget build(BuildContext context) => switch (cell) {
    AppTableTextCell(:final text) => Semantics(
      label: column.semanticLabel ?? column.label,
      child: Text(
        text,
        style: theme.cellStyle,
        textAlign: column.alignment == AppTableAlignment.trailing
            ? theme.trailing
            : theme.leading,
      ),
    ),
    AppTableIdentityCell(
      :final primary,
      :final secondary,
      :final initials,
      :final avatarForeground,
    ) =>
      AppIdentity(
        primary: primary,
        secondary: secondary,
        initials: initials,
        avatarForeground: avatarForeground,
        theme: theme.identity,
      ),
  };
}
