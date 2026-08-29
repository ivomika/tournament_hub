import 'dart:ui';

import 'package:flutter/material.dart';

class ActionDockTheme extends ThemeExtension<ActionDockTheme> {
  const ActionDockTheme({
    required this.background,
    required this.divider,
    required this.foreground,
    required this.danger,
    required this.padding,
    required this.gap,
    required this.radius,
    required this.minimumHeight,
    required this.overflowSize,
    required this.portraitMaxFraction,
    required this.landscapeMaxFraction,
  });

  final Color background;
  final Color divider;
  final Color foreground;
  final Color danger;
  final double padding;
  final double gap;
  final double radius;
  final double minimumHeight;
  final double overflowSize;
  final double portraitMaxFraction;
  final double landscapeMaxFraction;

  @override
  ActionDockTheme copyWith({
    Color? background,
    Color? divider,
    Color? foreground,
    Color? danger,
    double? padding,
    double? gap,
    double? radius,
    double? minimumHeight,
    double? overflowSize,
    double? portraitMaxFraction,
    double? landscapeMaxFraction,
  }) => ActionDockTheme(
    background: background ?? this.background,
    divider: divider ?? this.divider,
    foreground: foreground ?? this.foreground,
    danger: danger ?? this.danger,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    radius: radius ?? this.radius,
    minimumHeight: minimumHeight ?? this.minimumHeight,
    overflowSize: overflowSize ?? this.overflowSize,
    portraitMaxFraction: portraitMaxFraction ?? this.portraitMaxFraction,
    landscapeMaxFraction: landscapeMaxFraction ?? this.landscapeMaxFraction,
  );

  @override
  ActionDockTheme lerp(covariant ActionDockTheme? other, double t) {
    if (other == null) return this;
    return ActionDockTheme(
      background: Color.lerp(background, other.background, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      minimumHeight: lerpDouble(minimumHeight, other.minimumHeight, t)!,
      overflowSize: lerpDouble(overflowSize, other.overflowSize, t)!,
      portraitMaxFraction: lerpDouble(
        portraitMaxFraction,
        other.portraitMaxFraction,
        t,
      )!,
      landscapeMaxFraction: lerpDouble(
        landscapeMaxFraction,
        other.landscapeMaxFraction,
        t,
      )!,
    );
  }
}
