import 'dart:ui';

import 'package:flutter/material.dart';

class DsSectionTheme extends ThemeExtension<DsSectionTheme> {
  const DsSectionTheme({
    required this.compactGap,
    required this.gap,
    required this.presentationGap,
  });

  final double compactGap;
  final double gap;
  final double presentationGap;

  @override
  DsSectionTheme copyWith({
    double? compactGap,
    double? gap,
    double? presentationGap,
  }) => DsSectionTheme(
    compactGap: compactGap ?? this.compactGap,
    gap: gap ?? this.gap,
    presentationGap: presentationGap ?? this.presentationGap,
  );

  @override
  DsSectionTheme lerp(covariant DsSectionTheme? other, double t) {
    if (other == null) return this;
    return DsSectionTheme(
      compactGap: lerpDouble(compactGap, other.compactGap, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      presentationGap: lerpDouble(presentationGap, other.presentationGap, t)!,
    );
  }
}
