import 'package:flutter/material.dart';

class AppTypeRoles extends ThemeExtension<AppTypeRoles> {
  const AppTypeRoles({
    required this.interfaceStyle,
    required this.normalTracking,
    required this.score,
  });
  final TextStyle Function(TextStyle) interfaceStyle;
  final TextStyle score;
  final double normalTracking;
  @override
  AppTypeRoles copyWith({
    TextStyle Function(TextStyle)? interfaceStyle,
    double? normalTracking,
    TextStyle? score,
  }) => AppTypeRoles(
    interfaceStyle: interfaceStyle ?? this.interfaceStyle,
    normalTracking: normalTracking ?? this.normalTracking,
    score: score ?? this.score,
  );
  @override
  AppTypeRoles lerp(covariant AppTypeRoles? other, double t) {
    if (other == null) return this;
    return AppTypeRoles(
      interfaceStyle: t < 0.5 ? interfaceStyle : other.interfaceStyle,
      normalTracking:
          normalTracking + (other.normalTracking - normalTracking) * t,
      score: TextStyle.lerp(score, other.score, t)!,
    );
  }
}
