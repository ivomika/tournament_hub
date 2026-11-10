import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_score_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

enum AppScoreKind { pair, fixed }

class AppScoreTheme {
  AppScoreTheme.of(BuildContext context, AppScoreKind kind) {
    final runtimeTheme = Theme.of(context),
        runtimeScoreMetrics = runtimeTheme.extension<AppScoreMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!;
    final desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    valueStyle = roles.score.copyWith(
      fontSize: kind == AppScoreKind.pair && desktop
          ? runtimeScoreMetrics.desktopSize
          : roles.score.fontSize,
      color: kind == AppScoreKind.fixed
          ? runtimeTheme.colorScheme.primary
          : runtimeTheme.colorScheme.onSurface,
    );
    separatorStyle = roles.interfaceStyle(
      runtimeTheme.textTheme.titleLarge!.copyWith(
        fontWeight: runtimeControlMetrics.regularWeight,
        height: runtimeScoreMetrics.lineHeight,
        letterSpacing: roles.normalTracking,
        color: runtimeTheme.disabledColor,
      ),
    );
    gap = runtimeTheme.extension<AppSpacing>()!.space24;
    center = runtimeControlMetrics.center;
  }
  late final TextStyle valueStyle, separatorStyle;
  late final double gap;
  late final MainAxisAlignment center;
}
