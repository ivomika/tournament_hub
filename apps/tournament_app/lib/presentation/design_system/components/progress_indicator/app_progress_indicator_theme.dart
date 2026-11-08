import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_progress_metrics.dart';

class AppProgressIndicatorTheme {
  AppProgressIndicatorTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    gap = theme.extension<AppSpacing>()!.space4;
    metrics = theme.extension<AppProgressMetrics>()!;
    color = theme.progressIndicatorTheme.color ?? theme.colorScheme.primary;
    track =
        theme.progressIndicatorTheme.linearTrackColor ??
        theme.colorScheme.surfaceContainerHigh;
  }
  late final AppProgressMetrics metrics;
  late final Color color, track;
  late final double gap;
}
