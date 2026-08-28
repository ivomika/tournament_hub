import 'dart:ui';

import 'package:flutter/material.dart';

class ChampionHeroTheme extends ThemeExtension<ChampionHeroTheme> {
  const ChampionHeroTheme({
    required this.iconColor,
    required this.iconSize,
    required this.gap,
  });

  final Color iconColor;
  final double iconSize;
  final double gap;

  @override
  ChampionHeroTheme copyWith({
    Color? iconColor,
    double? iconSize,
    double? gap,
  }) => ChampionHeroTheme(
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    gap: gap ?? this.gap,
  );

  @override
  ChampionHeroTheme lerp(covariant ChampionHeroTheme? other, double t) {
    if (other == null) return this;
    return ChampionHeroTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
    );
  }
}
