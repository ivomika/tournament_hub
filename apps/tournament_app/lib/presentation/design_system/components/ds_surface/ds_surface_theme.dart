import 'dart:ui';

import 'package:flutter/material.dart';

class DsSurfaceTheme extends ThemeExtension<DsSurfaceTheme> {
  const DsSurfaceTheme({
    required this.background,
    required this.elevatedBackground,
    required this.accentBackground,
    required this.border,
    required this.accentBorder,
    required this.radius,
    required this.compactPadding,
    required this.padding,
    required this.presentationPadding,
  });

  final Color background;
  final Color elevatedBackground;
  final Color accentBackground;
  final Color border;
  final Color accentBorder;
  final double radius;
  final double compactPadding;
  final double padding;
  final double presentationPadding;

  @override
  DsSurfaceTheme copyWith({
    Color? background,
    Color? elevatedBackground,
    Color? accentBackground,
    Color? border,
    Color? accentBorder,
    double? radius,
    double? compactPadding,
    double? padding,
    double? presentationPadding,
  }) => DsSurfaceTheme(
    background: background ?? this.background,
    elevatedBackground: elevatedBackground ?? this.elevatedBackground,
    accentBackground: accentBackground ?? this.accentBackground,
    border: border ?? this.border,
    accentBorder: accentBorder ?? this.accentBorder,
    radius: radius ?? this.radius,
    compactPadding: compactPadding ?? this.compactPadding,
    padding: padding ?? this.padding,
    presentationPadding: presentationPadding ?? this.presentationPadding,
  );

  @override
  DsSurfaceTheme lerp(covariant DsSurfaceTheme? other, double t) {
    if (other == null) return this;
    return DsSurfaceTheme(
      background: Color.lerp(background, other.background, t)!,
      elevatedBackground: Color.lerp(
        elevatedBackground,
        other.elevatedBackground,
        t,
      )!,
      accentBackground: Color.lerp(
        accentBackground,
        other.accentBackground,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      accentBorder: Color.lerp(accentBorder, other.accentBorder, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      compactPadding: lerpDouble(compactPadding, other.compactPadding, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      presentationPadding: lerpDouble(
        presentationPadding,
        other.presentationPadding,
        t,
      )!,
    );
  }
}
