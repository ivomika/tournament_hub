import 'package:flutter/material.dart';

class AppTypeRoles extends ThemeExtension<AppTypeRoles> {
  const AppTypeRoles({required this.normalTracking, required this.score});
  final TextStyle score;
  final double normalTracking;
  @override
  AppTypeRoles copyWith({double? normalTracking, TextStyle? score}) =>
      AppTypeRoles(
        normalTracking: normalTracking ?? this.normalTracking,
        score: score ?? this.score,
      );
  @override
  AppTypeRoles lerp(covariant AppTypeRoles? other, double t) {
    if (other == null) return this;
    return AppTypeRoles(
      normalTracking:
          normalTracking + (other.normalTracking - normalTracking) * t,
      score: TextStyle.lerp(score, other.score, t)!,
    );
  }
}
