import 'dart:ui';

import 'package:flutter/material.dart';

class DsSpacingTheme extends ThemeExtension<DsSpacingTheme> {
  const DsSpacingTheme({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.page,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double page;

  @override
  DsSpacingTheme copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? page,
  }) => DsSpacingTheme(
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    page: page ?? this.page,
  );

  @override
  DsSpacingTheme lerp(covariant DsSpacingTheme? other, double t) {
    if (other == null) return this;
    return DsSpacingTheme(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      page: lerpDouble(page, other.page, t)!,
    );
  }
}
