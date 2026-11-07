import 'package:flutter/material.dart';

class AppRosterMetrics extends ThemeExtension<AppRosterMetrics> {
  const AppRosterMetrics({
    required this.cardHeight,
    required this.swipeThreshold,
  });
  final double cardHeight, swipeThreshold;
  @override
  AppRosterMetrics copyWith({double? cardHeight, double? swipeThreshold}) =>
      AppRosterMetrics(
        cardHeight: cardHeight ?? this.cardHeight,
        swipeThreshold: swipeThreshold ?? this.swipeThreshold,
      );
  @override
  AppRosterMetrics lerp(covariant AppRosterMetrics? other, double t) =>
      other == null
      ? this
      : AppRosterMetrics(
          cardHeight: cardHeight + (other.cardHeight - cardHeight) * t,
          swipeThreshold:
              swipeThreshold + (other.swipeThreshold - swipeThreshold) * t,
        );
}
