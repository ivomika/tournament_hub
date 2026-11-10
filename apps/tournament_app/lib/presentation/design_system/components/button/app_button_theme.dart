import 'dart:math' as math;

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
  textLink,
  secondary,
  destructive,
  icon,
  accentIcon,
  removeIcon,
  removeSwipe,
  dialogDestructive,
  dialogCancel,
  shareIcon,
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
    Set<WidgetState> states, {
    String? label,
    bool glyphLeading = false,
  }) {
    final runtimeTheme = Theme.of(context),
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        shape = runtimeTheme.extension<AppShape>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!;
    final desktop =
            MediaQuery.sizeOf(context).width >
            runtimeResponsive.mobileToDesktopWidth,
        disabled = states.contains(WidgetState.disabled),
        hovered = states.contains(WidgetState.hovered),
        pressed = states.contains(WidgetState.pressed);
    final dialog =
        kind == AppButtonKind.dialogDestructive ||
        kind == AppButtonKind.dialogCancel;
    final circular =
        kind == AppButtonKind.icon ||
        kind == AppButtonKind.shareIcon ||
        kind == AppButtonKind.accentIcon ||
        kind == AppButtonKind.removeIcon;
    final accent =
        kind == AppButtonKind.primary || kind == AppButtonKind.accentIcon;
    final danger =
        kind == AppButtonKind.destructive ||
        kind == AppButtonKind.dialogDestructive ||
        kind == AppButtonKind.removeSwipe ||
        (kind == AppButtonKind.removeIcon && hovered);
    final regular =
        kind == AppButtonKind.destructive || kind == AppButtonKind.removeSwipe;
    final height = _resolveHeight(
      kind,
      circular,
      desktop,
      runtimeControlMetrics,
      runtimeResponsive,
    );
    final foreground = _resolveForeground(
      kind,
      disabled && !dialog,
      danger,
      accent,
      runtimeTheme,
    );
    final text = runtimeTheme.extension<AppTypeRoles>()!.interfaceStyle(
      (kind == AppButtonKind.removeSwipe
              ? runtimeTheme.textTheme.bodySmall!
              : runtimeTheme.textTheme.labelLarge!)
          .copyWith(
            color: foreground,
            letterSpacing: runtimeTheme
                .extension<AppTypeRoles>()!
                .normalTracking,
            fontWeight: regular ? runtimeControlMetrics.regularWeight : null,
            fontVariations: regular
                ? runtimeControlMetrics.regularVariations
                : null,
          ),
    );
    var removeWidth = runtimeControlMetrics.removeWidth;
    if (kind == AppButtonKind.removeSwipe && label != null) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: text),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      removeWidth = math.max(
        removeWidth,
        painter.width.ceilToDouble() +
            runtimeSpacing.space12 +
            runtimeSpacing.space12,
      );
      painter.dispose();
    }
    return AppButtonTheme(
      half: runtimeControlMetrics.half,
      height: height,
      width: _resolveWidth(kind, circular, height, removeWidth),
      padding: EdgeInsets.symmetric(
        horizontal: _resolveHorizontalPadding(
          kind,
          circular,
          dialog,
          runtimeSpacing,
        ),
      ),
      gap: glyphLeading ? runtimeSpacing.space8 : runtimeSpacing.space16,
      background: _resolveBackground(
        kind,
        hovered,
        pressed,
        disabled && !dialog,
        danger,
        accent,
        runtimeTheme,
        runtimeControlMetrics,
      ),
      foreground: foreground,
      text: text,
      radius: _resolveRadius(kind, dialog, shape, runtimeSpacing),
      circular: circular,
      justify: kind == AppButtonKind.primary || kind == AppButtonKind.textLink
          ? runtimeControlMetrics.spaceBetween
          : runtimeControlMetrics.center,
      cross: runtimeControlMetrics.centerCross,
      shadows:
          kind != AppButtonKind.textLink &&
              kind != AppButtonKind.shareIcon &&
              !dialog &&
              !desktop &&
              !disabled &&
              !danger
          ? [runtimeTheme.extension<AppElevation>()!.floating]
          : [],
      focusColor: runtimeTheme.focusColor,
      focusWidth: kind == AppButtonKind.removeIcon
          ? runtimeBorderMetrics.emphasis
          : runtimeBorderMetrics.highContrastFocus,
      focusOffset: runtimeBorderMetrics.focusOffset,
    );
  }

  static double _resolveHeight(
    AppButtonKind kind,
    bool circular,
    bool desktop,
    AppControlMetrics metrics,
    AppResponsive responsive,
  ) {
    if (kind == AppButtonKind.removeSwipe) return metrics.removeHeight;
    if (kind == AppButtonKind.removeIcon) return metrics.removeIconExtent;
    if (circular && desktop) return responsive.compactControlHeight;
    return responsive.touchControlHeight;
  }

  static Color _resolveForeground(
    AppButtonKind kind,
    bool disabled,
    bool danger,
    bool accent,
    ThemeData theme,
  ) {
    if (disabled) return theme.disabledColor;
    if (danger) return theme.colorScheme.error;
    if (accent) return theme.colorScheme.onPrimary;
    if (kind == AppButtonKind.removeIcon ||
        kind == AppButtonKind.dialogCancel ||
        kind == AppButtonKind.textLink) {
      return theme.colorScheme.onSurfaceVariant;
    }
    return theme.colorScheme.onSurface;
  }

  static double? _resolveWidth(
    AppButtonKind kind,
    bool circular,
    double height,
    double removeWidth,
  ) {
    if (circular) return height;
    if (kind == AppButtonKind.removeSwipe) return removeWidth;
    return null;
  }

  static double _resolveHorizontalPadding(
    AppButtonKind kind,
    bool circular,
    bool dialog,
    AppSpacing spacing,
  ) {
    if (circular ||
        kind == AppButtonKind.removeSwipe ||
        kind == AppButtonKind.textLink) {
      return spacing.space0;
    }
    if (dialog) return spacing.space16;
    return spacing.space24;
  }

  static Color _resolveBackground(
    AppButtonKind kind,
    bool hovered,
    bool pressed,
    bool disabled,
    bool danger,
    bool accent,
    ThemeData theme,
    AppControlMetrics metrics,
  ) {
    if (kind == AppButtonKind.textLink) return metrics.transparent;
    if (kind == AppButtonKind.dialogCancel) {
      if (hovered) return theme.colorScheme.surfaceContainerHigh;
      return metrics.transparent;
    }
    if (disabled) return theme.colorScheme.surfaceContainerHigh;
    if (danger) return theme.colorScheme.errorContainer;
    if (accent) {
      if (pressed) return theme.highlightColor;
      if (hovered) return theme.hoverColor;
      return theme.colorScheme.primary;
    }
    if (hovered) return theme.colorScheme.outlineVariant;
    return theme.colorScheme.surfaceContainerHigh;
  }

  static BorderRadius _resolveRadius(
    AppButtonKind kind,
    bool dialog,
    AppShape shape,
    AppSpacing spacing,
  ) {
    if (dialog) return shape.nested;
    if (kind == AppButtonKind.removeSwipe) {
      return BorderRadius.circular(spacing.space0);
    }
    return shape.pill;
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
