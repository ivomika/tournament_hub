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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!,
        c = t.extension<AppControlMetrics>()!,
        b = t.extension<AppBorderMetrics>()!,
        width = MediaQuery.sizeOf(context).width;
    zero = c.zero;
    desktop = width > r.mobileToDesktopWidth;
    final hovered = states.contains(WidgetState.hovered),
        disabled = states.contains(WidgetState.disabled);
    background = hovered
        ? t.colorScheme.surfaceContainerHigh
        : desktop
        ? t.colorScheme.surface
        : c.transparent;
    foreground = disabled ? t.disabledColor : t.colorScheme.onSurface;
    iconColor = disabled ? t.disabledColor : t.colorScheme.onSurfaceVariant;
    chevronColor = disabled ? t.disabledColor : t.disabledColor;
    labelStyle =
        (desktop
                ? AppTextStyles(t).body
                : AppTextStyles(t).label.copyWith(fontWeight: c.regularWeight))
            .copyWith(color: foreground);
    minHeight = desktop ? s.space64 + s.space16 : r.touchControlHeight;
    padding = desktop
        ? EdgeInsets.all(width <= r.compactDesktopWidth ? s.space20 : s.space24)
        : EdgeInsets.symmetric(horizontal: s.space24);
    gap = s.space16;
    radius = desktop
        ? t.extension<AppShape>()!.surface
        : BorderRadius.circular(s.space0);
    focusRadius = desktop ? radius : t.extension<AppShape>()!.nested;
    iconSize = desktop ? AppIconSize.large : AppIconSize.standard;
    chevronSize = AppIconSize.small;
    focusWidth = b.highContrastFocus;
    focusOffset = desktop ? b.focusOffset : -s.space4;
    focusColor = t.focusColor;
    half = c.half;
  }
  late final bool desktop;
  late final Color background, foreground, iconColor, chevronColor, focusColor;
  late final TextStyle labelStyle;
  late final double zero, minHeight, gap, focusWidth, focusOffset, half;
  late final EdgeInsets padding;
  late final BorderRadius radius, focusRadius;
  late final AppIconSize iconSize, chevronSize;
}
