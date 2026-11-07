import 'package:flutter/material.dart';

class AppRosterMetrics extends ThemeExtension<AppRosterMetrics> {
  const AppRosterMetrics({
    required this.cardHeight,
    required this.swipeThreshold,
    required this.reveal,
    required this.curve,
  });
  final double cardHeight, swipeThreshold;
  final Duration reveal;
  final Curve curve;
  @override
  AppRosterMetrics copyWith({
    double? cardHeight,
    double? swipeThreshold,
    Duration? reveal,
    Curve? curve,
  }) => AppRosterMetrics(
    cardHeight: cardHeight ?? this.cardHeight,
    swipeThreshold: swipeThreshold ?? this.swipeThreshold,
    reveal: reveal ?? this.reveal,
    curve: curve ?? this.curve,
  );
  @override
  AppRosterMetrics lerp(covariant AppRosterMetrics? other, double t) =>
      other == null
      ? this
      : AppRosterMetrics(
          cardHeight: cardHeight + (other.cardHeight - cardHeight) * t,
          swipeThreshold:
              swipeThreshold + (other.swipeThreshold - swipeThreshold) * t,
          reveal: t < 0.5 ? reveal : other.reveal,
          curve: t < 0.5 ? curve : other.curve,
        );
}
