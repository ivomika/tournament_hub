import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.space0,
    required this.space4,
    required this.space8,
    required this.space12,
    required this.space16,
    required this.space20,
    required this.space24,
    required this.space28,
    required this.space32,
    required this.space48,
    required this.space64,
  });
  final double space0;
  final double space4;
  final double space8;
  final double space12;
  final double space16;
  final double space20;
  final double space24;
  final double space28;
  final double space32;
  final double space48;
  final double space64;
  @override
  AppSpacing copyWith({
    double? space0,
    double? space4,
    double? space8,
    double? space12,
    double? space16,
    double? space20,
    double? space24,
    double? space28,
    double? space32,
    double? space48,
    double? space64,
  }) => AppSpacing(
    space0: space0 ?? this.space0,
    space4: space4 ?? this.space4,
    space8: space8 ?? this.space8,
    space12: space12 ?? this.space12,
    space16: space16 ?? this.space16,
    space20: space20 ?? this.space20,
    space24: space24 ?? this.space24,
    space28: space28 ?? this.space28,
    space32: space32 ?? this.space32,
    space48: space48 ?? this.space48,
    space64: space64 ?? this.space64,
  );
  @override
  AppSpacing lerp(covariant AppSpacing? other, double t) {
    if (other == null) return this;
    return AppSpacing(
      space0: lerpDouble(space0, other.space0, t)!,
      space4: lerpDouble(space4, other.space4, t)!,
      space8: lerpDouble(space8, other.space8, t)!,
      space12: lerpDouble(space12, other.space12, t)!,
      space16: lerpDouble(space16, other.space16, t)!,
      space20: lerpDouble(space20, other.space20, t)!,
      space24: lerpDouble(space24, other.space24, t)!,
      space28: lerpDouble(space28, other.space28, t)!,
      space32: lerpDouble(space32, other.space32, t)!,
      space48: lerpDouble(space48, other.space48, t)!,
      space64: lerpDouble(space64, other.space64, t)!,
    );
  }
}
