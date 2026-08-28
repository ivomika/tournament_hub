import 'dart:ui';

import 'package:flutter/material.dart';

class MatchCardTheme extends ThemeExtension<MatchCardTheme> {
  const MatchCardTheme({
    required this.gap,
    required this.divider,
    required this.accent,
    required this.versusBackground,
    required this.compactBreakpoint,
    required this.versusSize,
  });

  final double gap;
  final Color divider;
  final Color accent;
  final Color versusBackground;
  final double compactBreakpoint;
  final double versusSize;

  @override
  MatchCardTheme copyWith({
    double? gap,
    Color? divider,
    Color? accent,
    Color? versusBackground,
    double? compactBreakpoint,
    double? versusSize,
  }) => MatchCardTheme(
    gap: gap ?? this.gap,
    divider: divider ?? this.divider,
    accent: accent ?? this.accent,
    versusBackground: versusBackground ?? this.versusBackground,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    versusSize: versusSize ?? this.versusSize,
  );

  @override
  MatchCardTheme lerp(covariant MatchCardTheme? other, double t) {
    if (other == null) return this;
    return MatchCardTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      versusBackground: Color.lerp(
        versusBackground,
        other.versusBackground,
        t,
      )!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
      versusSize: lerpDouble(versusSize, other.versusSize, t)!,
    );
  }
}
