import 'dart:ui';

import 'package:flutter/material.dart';

class BracketTheme extends ThemeExtension<BracketTheme> {
  const BracketTheme({required this.gap, required this.itemWidth});

  final double gap;
  final double itemWidth;

  @override
  BracketTheme copyWith({double? gap, double? itemWidth}) => BracketTheme(
    gap: gap ?? this.gap,
    itemWidth: itemWidth ?? this.itemWidth,
  );

  @override
  BracketTheme lerp(covariant BracketTheme? other, double t) {
    if (other == null) return this;
    return BracketTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      itemWidth: lerpDouble(itemWidth, other.itemWidth, t)!,
    );
  }
}
