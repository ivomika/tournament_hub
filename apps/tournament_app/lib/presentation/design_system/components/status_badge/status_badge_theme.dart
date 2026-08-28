import 'dart:ui';

import 'package:flutter/material.dart';

class StatusBadgeTheme extends ThemeExtension<StatusBadgeTheme> {
  const StatusBadgeTheme({
    required this.background,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.neutral,
    required this.radius,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.gap,
    required this.iconSize,
  });

  final Color background;
  final Color success;
  final Color danger;
  final Color warning;
  final Color info;
  final Color neutral;
  final double radius;
  final double horizontalPadding;
  final double verticalPadding;
  final double gap;
  final double iconSize;

  @override
  StatusBadgeTheme copyWith({
    Color? background,
    Color? success,
    Color? danger,
    Color? warning,
    Color? info,
    Color? neutral,
    double? radius,
    double? horizontalPadding,
    double? verticalPadding,
    double? gap,
    double? iconSize,
  }) => StatusBadgeTheme(
    background: background ?? this.background,
    success: success ?? this.success,
    danger: danger ?? this.danger,
    warning: warning ?? this.warning,
    info: info ?? this.info,
    neutral: neutral ?? this.neutral,
    radius: radius ?? this.radius,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    gap: gap ?? this.gap,
    iconSize: iconSize ?? this.iconSize,
  );

  @override
  StatusBadgeTheme lerp(covariant StatusBadgeTheme? other, double t) {
    if (other == null) return this;
    return StatusBadgeTheme(
      background: Color.lerp(background, other.background, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      )!,
      verticalPadding: lerpDouble(verticalPadding, other.verticalPadding, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
    );
  }
}
