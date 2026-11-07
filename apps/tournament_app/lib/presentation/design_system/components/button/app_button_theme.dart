import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';

enum AppButtonKind {
  primary,
  secondary,
  destructive,
  icon,
  accentIcon,
  removeIcon,
  removeSwipe,
}

class AppButtonTheme {
  const AppButtonTheme({
    required this.half,
    required this.height,
    required this.width,
    required this.padding,
    required this.gap,
    required this.background,
    required this.foreground,
    required this.text,
    required this.radius,
    required this.circular,
    required this.justify,
    required this.cross,
    required this.shadows,
    required this.focusColor,
    required this.focusWidth,
    required this.focusOffset,
  });
  factory AppButtonTheme.of(
    BuildContext context,
    AppButtonKind kind,
    Set<WidgetState> states,
  ) {
    final t = Theme.of(context),
        m = t.extension<AppControlMetrics>()!,
        r = t.extension<AppResponsive>()!,
        s = t.extension<AppSpacing>()!,
        shape = t.extension<AppShape>()!,
        b = t.extension<AppBorderMetrics>()!;
    final desktop = MediaQuery.sizeOf(context).width >= r.mobileToDesktopWidth,
        disabled = states.contains(WidgetState.disabled),
        hovered = states.contains(WidgetState.hovered),
        pressed = states.contains(WidgetState.pressed);
    final circular =
        kind == AppButtonKind.icon ||
        kind == AppButtonKind.accentIcon ||
        kind == AppButtonKind.removeIcon;
    final accent =
        kind == AppButtonKind.primary || kind == AppButtonKind.accentIcon;
    final danger =
        kind == AppButtonKind.destructive ||
        kind == AppButtonKind.removeSwipe ||
        (kind == AppButtonKind.removeIcon && hovered);
    final regular =
        kind == AppButtonKind.destructive || kind == AppButtonKind.removeSwipe;
    final height = kind == AppButtonKind.removeSwipe
        ? m.removeHeight
        : kind == AppButtonKind.removeIcon
        ? m.removeIconExtent
        : circular && desktop
        ? r.compactControlHeight
        : r.touchControlHeight;
    final foreground = disabled
        ? t.disabledColor
        : danger
        ? t.colorScheme.error
        : accent
        ? t.colorScheme.onPrimary
        : kind == AppButtonKind.removeIcon
        ? t.colorScheme.onSurfaceVariant
        : t.colorScheme.onSurface;
    return AppButtonTheme(
      half: m.half,
      height: height,
      width: circular
          ? height
          : kind == AppButtonKind.removeSwipe
          ? m.removeWidth
          : null,
      padding: EdgeInsets.symmetric(
        horizontal: circular || kind == AppButtonKind.removeSwipe
            ? s.space0
            : s.space24,
      ),
      gap: s.space16,
      background: disabled
          ? t.colorScheme.surfaceContainerHigh
          : danger
          ? t.colorScheme.errorContainer
          : accent
          ? (pressed
                ? t.highlightColor
                : hovered
                ? t.hoverColor
                : t.colorScheme.primary)
          : hovered
          ? t.colorScheme.outlineVariant
          : t.colorScheme.surfaceContainerHigh,
      foreground: foreground,
      text: t.extension<AppTypeRoles>()!.interfaceStyle(
        (kind == AppButtonKind.removeSwipe
                ? t.textTheme.bodySmall!
                : t.textTheme.labelLarge!)
            .copyWith(
              color: foreground,
              letterSpacing: t.extension<AppTypeRoles>()!.normalTracking,
              fontWeight: regular ? m.regularWeight : null,
              fontVariations: regular ? m.regularVariations : null,
            ),
      ),
      radius: kind == AppButtonKind.removeSwipe
          ? BorderRadius.circular(s.space0)
          : shape.pill,
      circular: circular,
      justify: kind == AppButtonKind.primary ? m.spaceBetween : m.center,
      cross: m.centerCross,
      shadows: !desktop && !disabled && !danger
          ? [t.extension<AppElevation>()!.floating]
          : [],
      focusColor: t.focusColor,
      focusWidth: kind == AppButtonKind.removeIcon
          ? b.emphasis
          : b.highContrastFocus,
      focusOffset: b.focusOffset,
    );
  }
  final double half, height, gap, focusWidth, focusOffset;
  final double? width;
  final EdgeInsets padding;
  final Color background, foreground, focusColor;
  final TextStyle text;
  final BorderRadius radius;
  final bool circular;
  final MainAxisAlignment justify;
  final CrossAxisAlignment cross;
  final List<BoxShadow> shadows;
}
