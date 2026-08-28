import 'dart:ui';

import 'package:flutter/material.dart';

class TournamentSummaryTheme extends ThemeExtension<TournamentSummaryTheme> {
  const TournamentSummaryTheme({
    required this.gap,
    required this.compactBreakpoint,
    required this.accent,
    required this.divider,
  });

  final double gap;
  final double compactBreakpoint;
  final Color accent;
  final Color divider;

  @override
  TournamentSummaryTheme copyWith({
    double? gap,
    double? compactBreakpoint,
    Color? accent,
    Color? divider,
  }) => TournamentSummaryTheme(
    gap: gap ?? this.gap,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    accent: accent ?? this.accent,
    divider: divider ?? this.divider,
  );

  @override
  TournamentSummaryTheme lerp(
    covariant TournamentSummaryTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return TournamentSummaryTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
      accent: Color.lerp(accent, other.accent, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
