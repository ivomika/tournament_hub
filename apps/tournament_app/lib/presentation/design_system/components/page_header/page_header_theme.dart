import 'dart:ui';

import 'package:flutter/material.dart';

class PageHeaderTheme extends ThemeExtension<PageHeaderTheme> {
  const PageHeaderTheme({
    required this.accent,
    required this.gap,
    required this.labelGap,
    required this.markerWidth,
    required this.markerHeight,
    required this.trailingBreakpoint,
  });

  final Color accent;
  final double gap;
  final double labelGap;
  final double markerWidth;
  final double markerHeight;
  final double trailingBreakpoint;

  @override
  PageHeaderTheme copyWith({
    Color? accent,
    double? gap,
    double? labelGap,
    double? markerWidth,
    double? markerHeight,
    double? trailingBreakpoint,
  }) => PageHeaderTheme(
    accent: accent ?? this.accent,
    gap: gap ?? this.gap,
    labelGap: labelGap ?? this.labelGap,
    markerWidth: markerWidth ?? this.markerWidth,
    markerHeight: markerHeight ?? this.markerHeight,
    trailingBreakpoint: trailingBreakpoint ?? this.trailingBreakpoint,
  );

  @override
  PageHeaderTheme lerp(covariant PageHeaderTheme? other, double t) {
    if (other == null) return this;
    return PageHeaderTheme(
      accent: Color.lerp(accent, other.accent, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      labelGap: lerpDouble(labelGap, other.labelGap, t)!,
      markerWidth: lerpDouble(markerWidth, other.markerWidth, t)!,
      markerHeight: lerpDouble(markerHeight, other.markerHeight, t)!,
      trailingBreakpoint: lerpDouble(
        trailingBreakpoint,
        other.trailingBreakpoint,
        t,
      )!,
    );
  }
}
