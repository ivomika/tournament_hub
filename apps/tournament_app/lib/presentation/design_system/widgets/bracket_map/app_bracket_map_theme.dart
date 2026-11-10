import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';

class AppBracketMapTheme {
  AppBracketMapTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeScreenMetrics = runtimeTheme.extension<AppScreenMetrics>()!;
    grid = runtimeScreenMetrics.bracketGrid;
    dot = runtimeScreenMetrics.bracketDot;
    stroke = runtimeScreenMetrics.bracketStroke;
    minScale = runtimeScreenMetrics.bracketScaleMin;
    maxScale = runtimeScreenMetrics.bracketScaleMax;
    zero = runtimeTheme.extension<AppControlMetrics>()!.zero;
    gridColor = runtimeTheme.colorScheme.outlineVariant;
    edgeColor = runtimeTheme.colorScheme.outline;
    label = runtimeTheme.textTheme.bodySmall!.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
    origin = runtimeScreenMetrics.topLeft;
  }
  late final double grid, dot, stroke, minScale, maxScale, zero;
  late final Color gridColor, edgeColor;
  late final TextStyle label;
  late final Alignment origin;
}
