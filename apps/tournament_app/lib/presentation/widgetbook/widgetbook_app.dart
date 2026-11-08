import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';

/// Оболочка preview-инструмента, не визуальный компонент продукта.
class TournamentWidgetbookApp extends StatelessWidget {
  const TournamentWidgetbookApp({
    required this.theme,
    this.initialRoute = "/",
    super.key,
  });

  final ThemeData theme;
  final String initialRoute;

  Widget _buildPreview(BuildContext context, Widget child) =>
      FoundationScenarioHost(theme: theme, child: child);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: widgetbookCatalog,
      initialRoute: initialRoute,
      appBuilder: _buildPreview,
      themeMode: ThemeMode.dark,
      darkTheme: theme,
    );
  }
}
