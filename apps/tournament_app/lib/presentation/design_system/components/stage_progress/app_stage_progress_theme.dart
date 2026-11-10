import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';

class AppStageProgressTheme {
  AppStageProgressTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!;
    height = runtimeSpacing.space8;
    gap = runtimeSpacing.space8;
    radius = runtimeTheme.extension<AppShape>()!.pill;
    current = runtimeTheme.colorScheme.primary;
    upcoming = runtimeTheme.colorScheme.surfaceContainerHigh;
  }
  late final double height, gap;
  late final BorderRadius radius;
  late final Color current, upcoming;
}
