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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        roles = t.extension<AppTypeRoles>()!,
        styles = AppTextStyles(t);
    color = tone == AppStatusTone.error
        ? t.colorScheme.error
        : t.colorScheme.primary;
    dot = s.space8;
    gap = s.space8;
    radius = t.extension<AppShape>()!.pill;
    fullWidth = t.extension<FoundationLayout>()!.fullWidth;
    style = roles.interfaceStyle(
      styles.caption.copyWith(
        color: color,
        height: kind == AppStatusKind.live
            ? styles.caption.height
            : styles.compactHeader.height,
        fontWeight: kind == AppStatusKind.outcome
            ? t.extension<AppSelectMetrics>()!.optionWeight
            : kind == AppStatusKind.points
            ? t.textTheme.labelLarge!.fontWeight
            : styles.caption.fontWeight,
      ),
    );
    heightBehavior = kind == AppStatusKind.live
        ? null
        : t.extension<AppStatusMetrics>()!.inlineHeightBehavior;
  }
  late final Color color;
  late final double dot, gap, fullWidth;
  late final BorderRadius radius;
  late final TextStyle style;
  late final TextHeightBehavior? heightBehavior;
}
