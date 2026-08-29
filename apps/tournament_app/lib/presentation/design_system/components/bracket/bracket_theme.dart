import 'dart:ui';

import 'package:flutter/material.dart';

class BracketTheme extends ThemeExtension<BracketTheme> {
  const BracketTheme({required this.gap, required this.desktopBreakpoint});

  final double gap;
  final double desktopBreakpoint;

  @override
  BracketTheme copyWith({double? gap, double? desktopBreakpoint}) =>
      BracketTheme(
        gap: gap ?? this.gap,
        desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
      );

  @override
  BracketTheme lerp(covariant BracketTheme? other, double t) {
    if (other == null) return this;
    return BracketTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      desktopBreakpoint: lerpDouble(
        desktopBreakpoint,
        other.desktopBreakpoint,
        t,
      )!,
    );
  }
}
