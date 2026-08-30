import 'dart:ui';

import 'package:flutter/material.dart';

class BracketTheme extends ThemeExtension<BracketTheme> {
  const BracketTheme({required this.gap});

  final double gap;

  @override
  BracketTheme copyWith({double? gap}) => BracketTheme(gap: gap ?? this.gap);

  @override
  BracketTheme lerp(covariant BracketTheme? other, double t) {
    if (other == null) return this;
    return BracketTheme(gap: lerpDouble(gap, other.gap, t)!);
  }
}
