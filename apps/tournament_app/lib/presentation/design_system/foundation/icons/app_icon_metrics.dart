import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppIconMetrics extends ThemeExtension<AppIconMetrics> {
  const AppIconMetrics({
    required this.small,
    required this.medium,
    required this.standard,
    required this.large,
    required this.display,
    required this.hero,
  });
  final double small;
  final double medium;
  final double standard;
  final double large;
  final double display;
  final double hero;
  @override
  AppIconMetrics copyWith({
    double? small,
    double? medium,
    double? standard,
    double? large,
    double? display,
    double? hero,
  }) => AppIconMetrics(
    small: small ?? this.small,
    medium: medium ?? this.medium,
    standard: standard ?? this.standard,
    large: large ?? this.large,
    display: display ?? this.display,
    hero: hero ?? this.hero,
  );
  @override
  AppIconMetrics lerp(covariant AppIconMetrics? other, double t) {
    if (other == null) return this;
    return AppIconMetrics(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      standard: lerpDouble(standard, other.standard, t)!,
      large: lerpDouble(large, other.large, t)!,
      display: lerpDouble(display, other.display, t)!,
      hero: lerpDouble(hero, other.hero, t)!,
    );
  }
}
