import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class AppAdaptiveGridTheme {
  AppAdaptiveGridTheme.of(BuildContext context, int columns, double maxWidth) {
    final runtimeTheme = Theme.of(context),
        runtimeScreenMetrics = runtimeTheme.extension<AppScreenMetrics>()!,
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!;
    gap = runtimeSpacing.space20;
    width =
        (maxWidth - gap * (columns - runtimeScreenMetrics.stackColumns)) /
        columns;
  }
  late final double gap, width;
}
