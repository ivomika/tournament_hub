import 'dart:ui';

import 'package:flutter/material.dart';

class StandingsTheme extends ThemeExtension<StandingsTheme> {
  const StandingsTheme({
    required this.gap,
    required this.rankWidth,
    required this.desktopBreakpoint,
    required this.divider,
  });

  final double gap;
  final double rankWidth;
  final double desktopBreakpoint;
  final Color divider;

  @override
  StandingsTheme copyWith({
    double? gap,
    double? rankWidth,
    double? desktopBreakpoint,
    Color? divider,
  }) => StandingsTheme(
    gap: gap ?? this.gap,
    rankWidth: rankWidth ?? this.rankWidth,
    desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
    divider: divider ?? this.divider,
  );

  @override
  StandingsTheme lerp(covariant StandingsTheme? other, double t) {
    if (other == null) return this;
    return StandingsTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      rankWidth: lerpDouble(rankWidth, other.rankWidth, t)!,
      desktopBreakpoint: lerpDouble(
        desktopBreakpoint,
        other.desktopBreakpoint,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
