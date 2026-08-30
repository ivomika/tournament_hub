import 'dart:ui';

import 'package:flutter/material.dart';

class HistorySnapshotCardTheme
    extends ThemeExtension<HistorySnapshotCardTheme> {
  const HistorySnapshotCardTheme({
    required this.compactGap,
    required this.gap,
    required this.presentationGap,
    required this.compactContentPadding,
    required this.contentPadding,
    required this.presentationContentPadding,
    required this.compactBreakpoint,
    required this.radius,
    required this.iconColor,
  });

  final double compactGap;
  final double gap;
  final double presentationGap;
  final double compactContentPadding;
  final double contentPadding;
  final double presentationContentPadding;
  final double compactBreakpoint;
  final double radius;
  final Color iconColor;

  @override
  HistorySnapshotCardTheme copyWith({
    double? compactGap,
    double? gap,
    double? presentationGap,
    double? compactContentPadding,
    double? contentPadding,
    double? presentationContentPadding,
    double? compactBreakpoint,
    double? radius,
    Color? iconColor,
  }) => HistorySnapshotCardTheme(
    compactGap: compactGap ?? this.compactGap,
    gap: gap ?? this.gap,
    presentationGap: presentationGap ?? this.presentationGap,
    compactContentPadding: compactContentPadding ?? this.compactContentPadding,
    contentPadding: contentPadding ?? this.contentPadding,
    presentationContentPadding:
        presentationContentPadding ?? this.presentationContentPadding,
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
      compactGap: lerpDouble(compactGap, other.compactGap, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      presentationGap: lerpDouble(presentationGap, other.presentationGap, t)!,
      compactContentPadding: lerpDouble(
        compactContentPadding,
        other.compactContentPadding,
        t,
      )!,
      contentPadding: lerpDouble(contentPadding, other.contentPadding, t)!,
      presentationContentPadding: lerpDouble(
        presentationContentPadding,
        other.presentationContentPadding,
        t,
      )!,
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
