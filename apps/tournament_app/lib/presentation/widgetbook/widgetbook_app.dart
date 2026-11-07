import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';

/// Оболочка preview-инструмента, не визуальный компонент продукта.
class TournamentWidgetbookApp extends StatelessWidget {
  const TournamentWidgetbookApp({required this.theme, super.key});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: widgetbookCatalog,
      themeMode: ThemeMode.dark,
      darkTheme: theme,
    );
  }
}
