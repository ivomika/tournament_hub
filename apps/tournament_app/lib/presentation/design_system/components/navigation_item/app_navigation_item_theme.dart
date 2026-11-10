import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';

class AppNavigationItemTheme {
  AppNavigationItemTheme.of(BuildContext context, Set<WidgetState> states) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        width = MediaQuery.sizeOf(context).width;
    zero = runtimeControlMetrics.zero;
    desktop = width > runtimeResponsive.mobileToDesktopWidth;
    final hovered = states.contains(WidgetState.hovered),
        disabled = states.contains(WidgetState.disabled);
    background = _resolveBackground(
      hovered,
      desktop,
      runtimeTheme,
      runtimeControlMetrics,
    );
    foreground = disabled
        ? runtimeTheme.disabledColor
        : runtimeTheme.colorScheme.onSurface;
    iconColor = disabled
        ? runtimeTheme.disabledColor
        : runtimeTheme.colorScheme.onSurfaceVariant;
    chevronColor = disabled
        ? runtimeTheme.disabledColor
        : runtimeTheme.disabledColor;
    labelStyle =
        (desktop
                ? AppTextStyles(runtimeTheme).body
                : AppTextStyles(runtimeTheme).label.copyWith(
                    fontWeight: runtimeControlMetrics.regularWeight,
                  ))
            .copyWith(color: foreground);
    minHeight = desktop
        ? runtimeSpacing.space64 + runtimeSpacing.space16
        : runtimeResponsive.touchControlHeight;
    padding = _resolvePadding(
      desktop,
      width,
      runtimeResponsive,
      runtimeSpacing,
    );
    gap = runtimeSpacing.space16;
    radius = desktop
        ? runtimeTheme.extension<AppShape>()!.surface
        : BorderRadius.circular(runtimeSpacing.space0);
    focusRadius = desktop ? radius : runtimeTheme.extension<AppShape>()!.nested;
    iconSize = desktop ? AppIconSize.large : AppIconSize.standard;
    chevronSize = AppIconSize.small;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = desktop
        ? runtimeBorderMetrics.focusOffset
        : -runtimeSpacing.space4;
    focusColor = runtimeTheme.focusColor;
    half = runtimeControlMetrics.half;
  }
  static Color _resolveBackground(
    bool hovered,
    bool desktop,
    ThemeData theme,
    AppControlMetrics metrics,
  ) {
    if (hovered) return theme.colorScheme.surfaceContainerHigh;
    if (desktop) return theme.colorScheme.surface;
    return metrics.transparent;
  }

  static EdgeInsets _resolvePadding(
    bool desktop,
    double width,
    AppResponsive responsive,
    AppSpacing spacing,
  ) {
    if (!desktop) return EdgeInsets.symmetric(horizontal: spacing.space24);
    if (width <= responsive.compactDesktopWidth) {
      return EdgeInsets.all(spacing.space20);
    }
    return EdgeInsets.all(spacing.space24);
  }

  late final bool desktop;
  late final Color background, foreground, iconColor, chevronColor, focusColor;
  late final TextStyle labelStyle;
  late final double zero, minHeight, gap, focusWidth, focusOffset, half;
  late final EdgeInsets padding;
  late final BorderRadius radius, focusRadius;
  late final AppIconSize iconSize, chevronSize;
}
