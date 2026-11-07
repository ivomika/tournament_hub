import 'package:flutter/material.dart';

class AppGlyphMetrics extends ThemeExtension<AppGlyphMetrics> {
  const AppGlyphMetrics({required this.stroke, required this.grid});
  final double stroke, grid;
  @override
  AppGlyphMetrics copyWith({double? stroke, double? grid}) =>
      AppGlyphMetrics(stroke: stroke ?? this.stroke, grid: grid ?? this.grid);
  @override
  AppGlyphMetrics lerp(covariant AppGlyphMetrics? other, double t) =>
      other == null
      ? this
      : AppGlyphMetrics(
          stroke: stroke + (other.stroke - stroke) * t,
          grid: grid + (other.grid - grid) * t,
        );
}
