import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_metric_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';

enum AppMetricKind { plain, achievement }

class AppMetricTheme {
  AppMetricTheme.of(BuildContext context, AppMetricKind kind) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeMetricMetrics = runtimeTheme.extension<AppMetricMetrics>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        styles = AppTextStyles(runtimeTheme),
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        width = MediaQuery.sizeOf(context).width;
    desktop = width > runtimeResponsive.mobileToDesktopWidth;
    achievement = kind == AppMetricKind.achievement;
    background = _resolveBackground(runtimeTheme, runtimeControlMetrics);
    foreground = _resolveForeground(runtimeTheme);
    labelColor = achievement && desktop
        ? runtimeTheme.colorScheme.onPrimary
        : runtimeTheme.colorScheme.onSurfaceVariant;
    padding = EdgeInsets.all(
      _resolvePadding(width, runtimeResponsive, runtimeSpacing),
    );
    radius = !desktop && !achievement
        ? BorderRadius.circular(runtimeSpacing.space0)
        : runtimeTheme.extension<AppShape>()!.surface;
    fullWidth = runtimeTheme.extension<FoundationLayout>()!.fullWidth;
    valueStyle = roles.score.copyWith(
      fontSize: _resolveValueSize(
        runtimeMetricMetrics,
        roles,
        runtimeSpacing,
        runtimeTheme,
      ),
      height: achievement && desktop
          ? runtimeMetricMetrics.achievementLine
          : roles.score.height,
      color: foreground,
    );
    labelStyle =
        (achievement && !desktop
                ? roles.interfaceStyle(
                    runtimeTheme.textTheme.labelLarge!.copyWith(
                      fontWeight: runtimeControlMetrics.regularWeight,
                    ),
                  )
                : styles.caption)
            .copyWith(
              color: labelColor,
              height: achievement
                  ? runtimeControlMetrics.regularLine
                  : styles.compactHeader.height,
            );
    unrestrictedWidth = runtimeTheme.extension<FoundationLayout>()!.fullWidth;
    minHeight = _resolveMinHeight(runtimeMetricMetrics, runtimeControlMetrics);
    gap = achievement && desktop
        ? runtimeSpacing.space16
        : runtimeSpacing.space24;
    contentGap = runtimeSpacing.space8;
    iconExtent = AppIconTheme.of(
      context,
      AppIconSize.hero,
      AppIconTone.primary,
    ).extent;
    iconOpacity = desktop
        ? runtimeMetricMetrics.iconOpacity
        : runtimeControlMetrics.half + runtimeControlMetrics.half;
    stretch = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
    start = runtimeTheme.extension<AppFieldMetrics>()!.start;
    centerCross = runtimeControlMetrics.centerCross;
    center = runtimeControlMetrics.center;
    between = runtimeControlMetrics.spaceBetween;
    textAlign = desktop || achievement
        ? runtimeTheme.extension<AppIdentityMetrics>()!.textLeading
        : runtimeMetricMetrics.centerText;
    final painter = TextPainter(
      text: TextSpan(text: '0', style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    maxLabelWidth = painter.width * runtimeMetricMetrics.labelCharacters;
    painter.dispose();
  }

  Color _resolveBackground(ThemeData theme, AppControlMetrics controls) {
    if (achievement && desktop) return theme.colorScheme.primary;
    if (achievement || desktop) return theme.colorScheme.surface;
    return controls.transparent;
  }

  Color _resolveForeground(ThemeData theme) {
    if (!achievement) return theme.colorScheme.onSurface;
    if (desktop) return theme.colorScheme.onPrimary;
    return theme.colorScheme.primary;
  }

  double _resolvePadding(
    double width,
    AppResponsive responsive,
    AppSpacing spacing,
  ) {
    if (desktop) {
      if (width <= responsive.compactDesktopWidth) return spacing.space20;
      return spacing.space24;
    }
    if (achievement) return spacing.space24;
    return spacing.space16;
  }

  double? _resolveValueSize(
    AppMetricMetrics metrics,
    AppTypeRoles roles,
    AppSpacing spacing,
    ThemeData theme,
  ) {
    if (achievement) {
      if (desktop) return metrics.desktopAchievementSize;
      return roles.score.fontSize;
    }
    if (desktop) return spacing.space64;
    return theme.textTheme.headlineLarge!.fontSize;
  }

  double _resolveMinHeight(
    AppMetricMetrics metrics,
    AppControlMetrics controls,
  ) {
    if (!desktop) return controls.zero;
    if (achievement) return metrics.achievementMinHeight;
    return metrics.plainMinHeight;
  }

  late final bool desktop, achievement;
  late final Color background, foreground, labelColor;
  late final EdgeInsets padding;
  late final BorderRadius radius;
  late final TextStyle valueStyle, labelStyle;
  late final double fullWidth, unrestrictedWidth;
  late final double minHeight,
      gap,
      contentGap,
      iconExtent,
      iconOpacity,
      maxLabelWidth;
  late final CrossAxisAlignment start, centerCross, stretch;
  late final MainAxisAlignment center, between;
  late final TextAlign textAlign;
}
