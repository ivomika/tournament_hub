import 'package:flutter/material.dart';

/// Geometry owned by visual foundation showcases, separate from product tokens.
class FoundationSampleMetrics extends ThemeExtension<FoundationSampleMetrics> {
  const FoundationSampleMetrics({
    required this.barHeight,
    required this.barRadius,
    required this.shapeExtent,
    required this.fontSize,
    required this.center,
  });
  final double barHeight, shapeExtent, fontSize;
  final BorderRadius barRadius;
  final Alignment center;
  @override
  FoundationSampleMetrics copyWith({
    double? barHeight,
    BorderRadius? barRadius,
    double? shapeExtent,
    double? fontSize,
    Alignment? center,
  }) => FoundationSampleMetrics(
    barHeight: barHeight ?? this.barHeight,
    barRadius: barRadius ?? this.barRadius,
    shapeExtent: shapeExtent ?? this.shapeExtent,
    fontSize: fontSize ?? this.fontSize,
    center: center ?? this.center,
  );
  @override
  FoundationSampleMetrics lerp(
    covariant FoundationSampleMetrics? other,
    double t,
  ) => other == null
      ? this
      : FoundationSampleMetrics(
          barHeight: barHeight + (other.barHeight - barHeight) * t,
          barRadius: BorderRadius.lerp(barRadius, other.barRadius, t)!,
          shapeExtent: shapeExtent + (other.shapeExtent - shapeExtent) * t,
          fontSize: fontSize + (other.fontSize - fontSize) * t,
          center: Alignment.lerp(center, other.center, t)!,
        );
}
