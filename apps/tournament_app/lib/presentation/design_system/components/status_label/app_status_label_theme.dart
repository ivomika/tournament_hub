import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_status_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';

enum AppStatusKind { live, outcome, points }

enum AppStatusTone { accent, error }

class AppStatusLabelTheme {
  AppStatusLabelTheme.of(
    BuildContext context,
    AppStatusKind kind,
    AppStatusTone tone,
  ) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        styles = AppTextStyles(runtimeTheme);
    color = tone == AppStatusTone.error
        ? runtimeTheme.colorScheme.error
        : runtimeTheme.colorScheme.primary;
    dot = runtimeSpacing.space8;
    gap = runtimeSpacing.space8;
    radius = runtimeTheme.extension<AppShape>()!.pill;
    fullWidth = runtimeTheme.extension<FoundationLayout>()!.fullWidth;
    style = roles.interfaceStyle(
      styles.caption.copyWith(
        color: color,
        height: kind == AppStatusKind.live
            ? styles.caption.height
            : styles.compactHeader.height,
        fontWeight: _resolveWeight(kind, runtimeTheme, styles),
      ),
    );
    heightBehavior = kind == AppStatusKind.live
        ? null
        : runtimeTheme.extension<AppStatusMetrics>()!.inlineHeightBehavior;
  }
  static FontWeight? _resolveWeight(
    AppStatusKind kind,
    ThemeData theme,
    AppTextStyles styles,
  ) {
    if (kind == AppStatusKind.outcome) {
      return theme.extension<AppSelectMetrics>()!.optionWeight;
    }
    if (kind == AppStatusKind.points) {
      return theme.textTheme.labelLarge!.fontWeight;
    }
    return styles.caption.fontWeight;
  }

  late final Color color;
  late final double dot, gap, fullWidth;
  late final BorderRadius radius;
  late final TextStyle style;
  late final TextHeightBehavior? heightBehavior;
}
