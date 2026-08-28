import 'dart:ui';

import 'package:flutter/material.dart';

class AdaptiveSplitTheme extends ThemeExtension<AdaptiveSplitTheme> {
  const AdaptiveSplitTheme({
    required this.breakpoint,
    required this.gap,
    required this.primaryFlex,
    required this.secondaryFlex,
  });

  final double breakpoint;
  final double gap;
  final int primaryFlex;
  final int secondaryFlex;

  @override
  AdaptiveSplitTheme copyWith({
    double? breakpoint,
    double? gap,
    int? primaryFlex,
    int? secondaryFlex,
  }) => AdaptiveSplitTheme(
    breakpoint: breakpoint ?? this.breakpoint,
    gap: gap ?? this.gap,
    primaryFlex: primaryFlex ?? this.primaryFlex,
    secondaryFlex: secondaryFlex ?? this.secondaryFlex,
  );

  @override
  AdaptiveSplitTheme lerp(covariant AdaptiveSplitTheme? other, double t) {
    if (other == null) return this;
    return AdaptiveSplitTheme(
      breakpoint: lerpDouble(breakpoint, other.breakpoint, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      primaryFlex: t < 0.5 ? primaryFlex : other.primaryFlex,
      secondaryFlex: t < 0.5 ? secondaryFlex : other.secondaryFlex,
    );
  }
}
