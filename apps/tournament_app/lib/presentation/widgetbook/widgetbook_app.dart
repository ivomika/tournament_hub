import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';
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
      addons: [ViewportAddon(WidgetbookViewports.values)],
      themeMode: ThemeMode.dark,
      darkTheme: theme,
    );
  }
}

/// Размеры среды preview, общие с comparison; не токены layout продукта.
abstract final class WidgetbookViewports {
  static final values = <ViewportData>[
    Viewports.none,
    for (final viewport in VisualViewport.values)
      ViewportData(
        name: viewport == VisualViewport.mobile
            ? 'Mobile 390 × 844'
            : 'Desktop 1440 × 900',
        width: viewport.size.width,
        height: viewport.size.height,
        pixelRatio: 1,
        platform: viewport == VisualViewport.mobile
            ? TargetPlatform.android
            : TargetPlatform.macOS,
      ),
  ];
}
