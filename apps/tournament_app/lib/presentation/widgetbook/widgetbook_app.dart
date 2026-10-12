import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';

/// Оболочка preview-инструмента, не визуальный компонент продукта.
class TournamentWidgetbookApp extends StatelessWidget {
  const TournamentWidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    const foundation = AppFoundation.dark();
    return Widgetbook.material(
      directories: widgetbookCatalog,
      themeMode: ThemeMode.dark,
      darkTheme: foundation.materialTheme,
    );
  }
}
