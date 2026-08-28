import 'dart:ui';

import 'package:flutter/material.dart';

class MatchCardTheme extends ThemeExtension<MatchCardTheme> {
  const MatchCardTheme({required this.gap, required this.divider});

  final double gap;
  final Color divider;

  @override
  MatchCardTheme copyWith({double? gap, Color? divider}) =>
      MatchCardTheme(gap: gap ?? this.gap, divider: divider ?? this.divider);

  @override
  MatchCardTheme lerp(covariant MatchCardTheme? other, double t) {
    if (other == null) return this;
    return MatchCardTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
