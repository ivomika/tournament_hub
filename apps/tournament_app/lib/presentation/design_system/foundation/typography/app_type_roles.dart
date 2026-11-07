import 'package:flutter/material.dart';

class AppTypeRoles extends ThemeExtension<AppTypeRoles> {
  const AppTypeRoles({required this.score});
  final TextStyle score;
  @override
  AppTypeRoles copyWith({TextStyle? score}) =>
      AppTypeRoles(score: score ?? this.score);
  @override
  AppTypeRoles lerp(covariant AppTypeRoles? other, double t) {
    if (other == null) return this;
    return AppTypeRoles(score: TextStyle.lerp(score, other.score, t)!);
  }
}
