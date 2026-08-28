import 'dart:ui';

import 'package:flutter/material.dart';

class ConfirmationTheme extends ThemeExtension<ConfirmationTheme> {
  const ConfirmationTheme({
    required this.background,
    required this.radius,
    required this.padding,
    required this.gap,
  });

  final Color background;
  final double radius;
  final double padding;
  final double gap;

  @override
  ConfirmationTheme copyWith({
    Color? background,
    double? radius,
    double? padding,
    double? gap,
  }) => ConfirmationTheme(
    background: background ?? this.background,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
  );

  @override
  ConfirmationTheme lerp(covariant ConfirmationTheme? other, double t) {
    if (other == null) return this;
    return ConfirmationTheme(
      background: Color.lerp(background, other.background, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
    );
  }
}
