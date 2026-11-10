import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppBorderMetrics extends ThemeExtension<AppBorderMetrics> {
  const AppBorderMetrics({
    required this.hairline,
    required this.emphasis,
    required this.highContrastFocus,
    required this.focusOffset,
  });
  final double hairline;
  final double emphasis;
  final double highContrastFocus;
  final double focusOffset;
  @override
  AppBorderMetrics copyWith({
    double? hairline,
    double? emphasis,
    double? highContrastFocus,
    double? focusOffset,
  }) => AppBorderMetrics(
    hairline: hairline ?? this.hairline,
    emphasis: emphasis ?? this.emphasis,
    highContrastFocus: highContrastFocus ?? this.highContrastFocus,
    focusOffset: focusOffset ?? this.focusOffset,
  );
  @override
  AppBorderMetrics lerp(
    covariant AppBorderMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppBorderMetrics(
      hairline: lerpDouble(hairline, other.hairline, interpolationAmount)!,
      emphasis: lerpDouble(emphasis, other.emphasis, interpolationAmount)!,
      highContrastFocus: lerpDouble(
        highContrastFocus,
        other.highContrastFocus,
        interpolationAmount,
      )!,
      focusOffset: lerpDouble(
        focusOffset,
        other.focusOffset,
        interpolationAmount,
      )!,
    );
  }
}
