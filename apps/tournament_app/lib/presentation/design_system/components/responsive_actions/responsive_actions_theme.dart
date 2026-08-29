import 'dart:ui';

import 'package:flutter/material.dart';

class ResponsiveActionsTheme extends ThemeExtension<ResponsiveActionsTheme> {
  const ResponsiveActionsTheme({
    required this.background,
    required this.divider,
    required this.gap,
    required this.sectionGap,
    required this.padding,
    required this.horizontalBreakpoint,
  });

  final Color background;
  final Color divider;
  final double gap;
  final double sectionGap;
  final double padding;
  final double horizontalBreakpoint;

  @override
  ResponsiveActionsTheme copyWith({
    Color? background,
    Color? divider,
    double? gap,
    double? sectionGap,
    double? padding,
    double? horizontalBreakpoint,
  }) => ResponsiveActionsTheme(
    background: background ?? this.background,
    divider: divider ?? this.divider,
    gap: gap ?? this.gap,
    sectionGap: sectionGap ?? this.sectionGap,
    padding: padding ?? this.padding,
    horizontalBreakpoint: horizontalBreakpoint ?? this.horizontalBreakpoint,
  );

  @override
  ResponsiveActionsTheme lerp(
    covariant ResponsiveActionsTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return ResponsiveActionsTheme(
      background: Color.lerp(background, other.background, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      sectionGap: lerpDouble(sectionGap, other.sectionGap, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      horizontalBreakpoint: lerpDouble(
        horizontalBreakpoint,
        other.horizontalBreakpoint,
        t,
      )!,
    );
  }
}
