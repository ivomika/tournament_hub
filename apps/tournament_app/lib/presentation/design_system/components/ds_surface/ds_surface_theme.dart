import 'dart:ui';

import 'package:flutter/material.dart';

class DsSurfaceTheme extends ThemeExtension<DsSurfaceTheme> {
  const DsSurfaceTheme({
    required this.background,
    required this.border,
    required this.radius,
    required this.padding,
  });

  final Color background;
  final Color border;
  final double radius;
  final double padding;

  @override
  DsSurfaceTheme copyWith({
    Color? background,
    Color? border,
    double? radius,
    double? padding,
  }) => DsSurfaceTheme(
    background: background ?? this.background,
    border: border ?? this.border,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
  );

  @override
  DsSurfaceTheme lerp(covariant DsSurfaceTheme? other, double t) {
    if (other == null) return this;
    return DsSurfaceTheme(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
    );
  }
}
