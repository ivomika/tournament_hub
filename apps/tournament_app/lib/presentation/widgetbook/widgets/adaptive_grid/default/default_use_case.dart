import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/component_preview.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';

final adaptiveGridDefaultUseCase = WidgetbookUseCase(
  name: 'default',
  builder: AdaptiveGridDefaultUseCase.build,
);

abstract final class AdaptiveGridDefaultUseCase {
  static Widget build(BuildContext context) =>
      const ComponentPreview(padded: true, child: AdaptiveGridFixture());
}

class AdaptiveGridFixture extends StatelessWidget {
  const AdaptiveGridFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => AppAdaptiveGrid(
    columns:
        MediaQuery.sizeOf(context).width >
            Theme.of(context).extension<AppResponsive>()!.mobileToDesktopWidth
        ? Theme.of(context).extension<AppScreenMetrics>()!.gridColumns
        : Theme.of(context).extension<AppScreenMetrics>()!.stackColumns,
    children: [
      AppRosterRow(name: 'Иван', initials: 'И', onRemove: action),
      AppRosterRow(name: 'Алексей', initials: 'А', onRemove: action),
    ],
  );
}
