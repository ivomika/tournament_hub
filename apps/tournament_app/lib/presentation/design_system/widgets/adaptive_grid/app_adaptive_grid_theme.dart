import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class AppAdaptiveGridTheme {
  AppAdaptiveGridTheme.of(BuildContext context, int columns, double maxWidth) {
    final t = Theme.of(context),
        m = t.extension<AppScreenMetrics>()!,
        s = t.extension<AppSpacing>()!;
    gap = s.space20;
    width = (maxWidth - gap * (columns - m.stackColumns)) / columns;
  }
  late final double gap, width;
}
