import 'package:flutter/material.dart';

class DsFieldTheme extends ThemeExtension<DsFieldTheme> {
  const DsFieldTheme({
    required this.decoration,
    required this.success,
    required this.indicatorSize,
    required this.indicatorStrokeWidth,
  });

  final InputDecoration decoration;
  final Color success;
  final double indicatorSize;
  final double indicatorStrokeWidth;

  @override
  DsFieldTheme copyWith({
    InputDecoration? decoration,
    Color? success,
    double? indicatorSize,
    double? indicatorStrokeWidth,
  }) => DsFieldTheme(
    decoration: decoration ?? this.decoration,
    success: success ?? this.success,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    indicatorStrokeWidth: indicatorStrokeWidth ?? this.indicatorStrokeWidth,
  );

  @override
  DsFieldTheme lerp(covariant DsFieldTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}
