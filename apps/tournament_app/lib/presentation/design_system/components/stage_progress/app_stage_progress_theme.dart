import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';

class AppStageProgressTheme {
  AppStageProgressTheme.of(BuildContext context) {
    final t = Theme.of(context), s = t.extension<AppSpacing>()!;
    height = s.space8;
    gap = s.space8;
    radius = t.extension<AppShape>()!.pill;
    current = t.colorScheme.primary;
    upcoming = t.colorScheme.surfaceContainerHigh;
  }
  late final double height, gap;
  late final BorderRadius radius;
  late final Color current, upcoming;
}
