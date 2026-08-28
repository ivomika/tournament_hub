import 'dart:ui';

import 'package:flutter/material.dart';

class DsSectionTheme extends ThemeExtension<DsSectionTheme> {
  const DsSectionTheme({required this.gap});

  final double gap;

  @override
  DsSectionTheme copyWith({double? gap}) =>
      DsSectionTheme(gap: gap ?? this.gap);

  @override
  DsSectionTheme lerp(covariant DsSectionTheme? other, double t) {
    if (other == null) return this;
    return DsSectionTheme(gap: lerpDouble(gap, other.gap, t)!);
  }
}
