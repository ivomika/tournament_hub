import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_score_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

enum AppScoreKind { pair, fixed }

class AppScoreTheme {
  AppScoreTheme.of(BuildContext context, AppScoreKind kind) {
    final t = Theme.of(context),
        m = t.extension<AppScoreMetrics>()!,
        r = t.extension<AppResponsive>()!,
        roles = t.extension<AppTypeRoles>()!,
        c = t.extension<AppControlMetrics>()!;
    final desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    valueStyle = roles.score.copyWith(
      fontSize: kind == AppScoreKind.pair && desktop
          ? m.desktopSize
          : roles.score.fontSize,
      color: kind == AppScoreKind.fixed
          ? t.colorScheme.primary
          : t.colorScheme.onSurface,
    );
    separatorStyle = roles.interfaceStyle(
      t.textTheme.titleLarge!.copyWith(
        fontWeight: c.regularWeight,
        height: m.lineHeight,
        letterSpacing: roles.normalTracking,
        color: t.disabledColor,
      ),
    );
    gap = t.extension<AppSpacing>()!.space24;
    center = c.center;
  }
  late final TextStyle valueStyle, separatorStyle;
  late final double gap;
  late final MainAxisAlignment center;
}
