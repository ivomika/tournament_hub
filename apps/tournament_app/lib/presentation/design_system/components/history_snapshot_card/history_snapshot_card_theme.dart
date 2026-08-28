import 'dart:ui';

import 'package:flutter/material.dart';

class HistorySnapshotCardTheme
    extends ThemeExtension<HistorySnapshotCardTheme> {
  const HistorySnapshotCardTheme({
    required this.gap,
    required this.contentPadding,
    required this.compactBreakpoint,
    required this.radius,
    required this.iconColor,
  });

  final double gap;
  final double contentPadding;
  final double compactBreakpoint;
  final double radius;
  final Color iconColor;

  @override
  HistorySnapshotCardTheme copyWith({
    double? gap,
    double? contentPadding,
    double? compactBreakpoint,
    double? radius,
    Color? iconColor,
  }) => HistorySnapshotCardTheme(
    gap: gap ?? this.gap,
    contentPadding: contentPadding ?? this.contentPadding,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    radius: radius ?? this.radius,
    iconColor: iconColor ?? this.iconColor,
  );

  @override
  HistorySnapshotCardTheme lerp(
    covariant HistorySnapshotCardTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return HistorySnapshotCardTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      contentPadding: lerpDouble(contentPadding, other.contentPadding, t)!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
      radius: lerpDouble(radius, other.radius, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
    );
  }
}
