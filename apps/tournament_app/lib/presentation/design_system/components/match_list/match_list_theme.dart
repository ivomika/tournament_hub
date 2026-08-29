import 'dart:ui';

import 'package:flutter/material.dart';

class MatchListTheme extends ThemeExtension<MatchListTheme> {
  const MatchListTheme({required this.gap});

  final double gap;

  @override
  MatchListTheme copyWith({double? gap}) =>
      MatchListTheme(gap: gap ?? this.gap);

  @override
  MatchListTheme lerp(covariant MatchListTheme? other, double t) {
    if (other == null) return this;
    return MatchListTheme(gap: lerpDouble(gap, other.gap, t)!);
  }
}
