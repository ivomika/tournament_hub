import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';

class AppBracketMapTheme {
  AppBracketMapTheme.of(BuildContext context) {
    final t = Theme.of(context), m = t.extension<AppScreenMetrics>()!;
    grid = m.bracketGrid;
    dot = m.bracketDot;
    stroke = m.bracketStroke;
    minScale = m.bracketScaleMin;
    maxScale = m.bracketScaleMax;
    zero = t.extension<AppControlMetrics>()!.zero;
    gridColor = t.colorScheme.outlineVariant;
    edgeColor = t.colorScheme.outline;
    label = t.textTheme.bodySmall!.copyWith(
      color: t.colorScheme.onSurfaceVariant,
    );
    origin = m.topLeft;
  }
  late final double grid, dot, stroke, minScale, maxScale, zero;
  late final Color gridColor, edgeColor;
  late final TextStyle label;
  late final Alignment origin;
}
