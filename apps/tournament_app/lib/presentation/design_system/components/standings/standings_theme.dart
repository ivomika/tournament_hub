import 'dart:ui';

import 'package:flutter/material.dart';

class StandingsTheme extends ThemeExtension<StandingsTheme> {
  const StandingsTheme({required this.gap, required this.rankWidth});

  final double gap;
  final double rankWidth;

  @override
  StandingsTheme copyWith({double? gap, double? rankWidth}) => StandingsTheme(
    gap: gap ?? this.gap,
    rankWidth: rankWidth ?? this.rankWidth,
  );

  @override
  StandingsTheme lerp(covariant StandingsTheme? other, double t) {
    if (other == null) return this;
    return StandingsTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      rankWidth: lerpDouble(rankWidth, other.rankWidth, t)!,
    );
  }
}
