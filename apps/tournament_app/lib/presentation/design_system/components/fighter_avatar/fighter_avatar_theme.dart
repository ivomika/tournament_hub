import 'dart:ui';

import 'package:flutter/material.dart';

class FighterAvatarTheme extends ThemeExtension<FighterAvatarTheme> {
  const FighterAvatarTheme({
    required this.background,
    required this.foreground,
    required this.compactSize,
    required this.standardSize,
    required this.matchupSize,
    required this.heroSize,
    required this.compactPlaceholderSize,
    required this.standardPlaceholderSize,
    required this.matchupPlaceholderSize,
    required this.heroPlaceholderSize,
    required this.radius,
  });

  final Color background;
  final Color foreground;
  final double compactSize;
  final double standardSize;
  final double matchupSize;
  final double heroSize;
  final double compactPlaceholderSize;
  final double standardPlaceholderSize;
  final double matchupPlaceholderSize;
  final double heroPlaceholderSize;
  final double radius;

  @override
  FighterAvatarTheme copyWith({
    Color? background,
    Color? foreground,
    double? compactSize,
    double? standardSize,
    double? matchupSize,
    double? heroSize,
    double? compactPlaceholderSize,
    double? standardPlaceholderSize,
    double? matchupPlaceholderSize,
    double? heroPlaceholderSize,
    double? radius,
  }) => FighterAvatarTheme(
    background: background ?? this.background,
    foreground: foreground ?? this.foreground,
    compactSize: compactSize ?? this.compactSize,
    standardSize: standardSize ?? this.standardSize,
    matchupSize: matchupSize ?? this.matchupSize,
    heroSize: heroSize ?? this.heroSize,
    compactPlaceholderSize:
        compactPlaceholderSize ?? this.compactPlaceholderSize,
    standardPlaceholderSize:
        standardPlaceholderSize ?? this.standardPlaceholderSize,
    matchupPlaceholderSize:
        matchupPlaceholderSize ?? this.matchupPlaceholderSize,
    heroPlaceholderSize: heroPlaceholderSize ?? this.heroPlaceholderSize,
    radius: radius ?? this.radius,
  );

  @override
  FighterAvatarTheme lerp(covariant FighterAvatarTheme? other, double t) {
    if (other == null) return this;
    return FighterAvatarTheme(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      compactSize: lerpDouble(compactSize, other.compactSize, t)!,
      standardSize: lerpDouble(standardSize, other.standardSize, t)!,
      matchupSize: lerpDouble(matchupSize, other.matchupSize, t)!,
      heroSize: lerpDouble(heroSize, other.heroSize, t)!,
      compactPlaceholderSize: lerpDouble(
        compactPlaceholderSize,
        other.compactPlaceholderSize,
        t,
      )!,
      standardPlaceholderSize: lerpDouble(
        standardPlaceholderSize,
        other.standardPlaceholderSize,
        t,
      )!,
      matchupPlaceholderSize: lerpDouble(
        matchupPlaceholderSize,
        other.matchupPlaceholderSize,
        t,
      )!,
      heroPlaceholderSize: lerpDouble(
        heroPlaceholderSize,
        other.heroPlaceholderSize,
        t,
      )!,
      radius: lerpDouble(radius, other.radius, t)!,
    );
  }
}
