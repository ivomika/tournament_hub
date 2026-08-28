import 'dart:ui';

import 'package:flutter/material.dart';

class TournamentStageTheme extends ThemeExtension<TournamentStageTheme> {
  const TournamentStageTheme({
    required this.gap,
    required this.accent,
    required this.divider,
  });

  final double gap;
  final Color accent;
  final Color divider;

  @override
  TournamentStageTheme copyWith({double? gap, Color? accent, Color? divider}) =>
      TournamentStageTheme(
        gap: gap ?? this.gap,
        accent: accent ?? this.accent,
        divider: divider ?? this.divider,
      );

  @override
  TournamentStageTheme lerp(covariant TournamentStageTheme? other, double t) {
    if (other == null) return this;
    return TournamentStageTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
