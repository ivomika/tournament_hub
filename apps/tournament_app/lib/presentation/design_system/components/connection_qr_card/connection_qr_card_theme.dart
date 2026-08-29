import 'dart:ui';

import 'package:flutter/material.dart';

class ConnectionQrCardTheme extends ThemeExtension<ConnectionQrCardTheme> {
  const ConnectionQrCardTheme({
    required this.background,
    required this.border,
    required this.accent,
    required this.info,
    required this.success,
    required this.warning,
    required this.danger,
    required this.neutral,
    required this.addressStyle,
    required this.padding,
    required this.gap,
    required this.compactGap,
    required this.radius,
    required this.compactBreakpoint,
    required this.accentWidth,
  });

  final Color background;
  final Color border;
  final Color accent;
  final Color info;
  final Color success;
  final Color warning;
  final Color danger;
  final Color neutral;
  final TextStyle addressStyle;
  final double padding;
  final double gap;
  final double compactGap;
  final double radius;
  final double compactBreakpoint;
  final double accentWidth;

  @override
  ConnectionQrCardTheme copyWith({
    Color? background,
    Color? border,
    Color? accent,
    Color? info,
    Color? success,
    Color? warning,
    Color? danger,
    Color? neutral,
    TextStyle? addressStyle,
    double? padding,
    double? gap,
    double? compactGap,
    double? radius,
    double? compactBreakpoint,
    double? accentWidth,
  }) => ConnectionQrCardTheme(
    background: background ?? this.background,
    border: border ?? this.border,
    accent: accent ?? this.accent,
    info: info ?? this.info,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    neutral: neutral ?? this.neutral,
    addressStyle: addressStyle ?? this.addressStyle,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    compactGap: compactGap ?? this.compactGap,
    radius: radius ?? this.radius,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    accentWidth: accentWidth ?? this.accentWidth,
  );

  @override
  ConnectionQrCardTheme lerp(covariant ConnectionQrCardTheme? other, double t) {
    if (other == null) return this;
    return ConnectionQrCardTheme(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      addressStyle: TextStyle.lerp(addressStyle, other.addressStyle, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      compactGap: lerpDouble(compactGap, other.compactGap, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
      accentWidth: lerpDouble(accentWidth, other.accentWidth, t)!,
    );
  }
}
