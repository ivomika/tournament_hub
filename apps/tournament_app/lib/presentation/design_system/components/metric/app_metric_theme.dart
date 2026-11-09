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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!,
        m = t.extension<AppMetricMetrics>()!,
        c = t.extension<AppControlMetrics>()!,
        styles = AppTextStyles(t),
        roles = t.extension<AppTypeRoles>()!,
        width = MediaQuery.sizeOf(context).width;
    desktop = width > r.mobileToDesktopWidth;
    achievement = kind == AppMetricKind.achievement;
    background = achievement
        ? (desktop ? t.colorScheme.primary : t.colorScheme.surface)
        : (desktop ? t.colorScheme.surface : c.transparent);
    foreground = achievement
        ? (desktop ? t.colorScheme.onPrimary : t.colorScheme.primary)
        : t.colorScheme.onSurface;
    labelColor = achievement && desktop
        ? t.colorScheme.onPrimary
        : t.colorScheme.onSurfaceVariant;
    padding = EdgeInsets.all(
      desktop
          ? (width <= r.compactDesktopWidth ? s.space20 : s.space24)
          : achievement
          ? s.space24
          : s.space16,
    );
    radius = !desktop && !achievement
        ? BorderRadius.circular(s.space0)
        : t.extension<AppShape>()!.surface;
    fullWidth = t.extension<FoundationLayout>()!.fullWidth;
    valueStyle = roles.score.copyWith(
      fontSize: achievement
          ? (desktop ? m.desktopAchievementSize : roles.score.fontSize)
          : (desktop ? s.space64 : t.textTheme.headlineLarge!.fontSize),
      height: achievement && desktop ? m.achievementLine : roles.score.height,
      color: foreground,
    );
    labelStyle =
        (achievement && !desktop
                ? roles.interfaceStyle(
                    t.textTheme.labelLarge!.copyWith(
                      fontWeight: c.regularWeight,
                    ),
                  )
                : styles.caption)
            .copyWith(
              color: labelColor,
              height: achievement
                  ? c.regularLine
                  : desktop
                  ? styles.compactHeader.height
                  : styles.compactHeader.height,
            );
    unrestrictedWidth = t.extension<FoundationLayout>()!.fullWidth;
    minHeight = desktop
        ? (achievement ? m.achievementMinHeight : m.plainMinHeight)
        : c.zero;
    gap = achievement && desktop ? s.space16 : s.space24;
    contentGap = s.space8;
    iconExtent = AppIconTheme.of(
      context,
      AppIconSize.hero,
      AppIconTone.primary,
    ).extent;
    iconOpacity = desktop ? m.iconOpacity : c.half + c.half;
    stretch = t.extension<AppFieldMetrics>()!.stretch;
    start = t.extension<AppFieldMetrics>()!.start;
    centerCross = c.centerCross;
    center = c.center;
    between = c.spaceBetween;
    textAlign = desktop || achievement
        ? t.extension<AppIdentityMetrics>()!.textLeading
        : m.centerText;
    final painter = TextPainter(
      text: TextSpan(text: '0', style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    maxLabelWidth = painter.width * m.labelCharacters;
    painter.dispose();
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
