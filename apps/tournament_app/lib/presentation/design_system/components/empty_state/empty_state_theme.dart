import 'dart:ui';

import 'package:flutter/material.dart';

class EmptyStateTheme extends ThemeExtension<EmptyStateTheme> {
  const EmptyStateTheme({
    required this.foreground,
    required this.error,
    required this.iconSize,
    required this.maxWidth,
    required this.gap,
  });

  final Color foreground;
  final Color error;
  final double iconSize;
  final double maxWidth;
  final double gap;

  @override
  EmptyStateTheme copyWith({
    Color? foreground,
    Color? error,
    double? iconSize,
    double? maxWidth,
    double? gap,
  }) => EmptyStateTheme(
    foreground: foreground ?? this.foreground,
    error: error ?? this.error,
    iconSize: iconSize ?? this.iconSize,
    maxWidth: maxWidth ?? this.maxWidth,
    gap: gap ?? this.gap,
  );

  @override
  EmptyStateTheme lerp(covariant EmptyStateTheme? other, double t) {
    if (other == null) return this;
    return EmptyStateTheme(
      foreground: Color.lerp(foreground, other.foreground, t)!,
      error: Color.lerp(error, other.error, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
    );
  }
}
