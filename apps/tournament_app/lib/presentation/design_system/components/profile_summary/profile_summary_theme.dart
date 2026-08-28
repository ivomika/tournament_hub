import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileSummaryTheme extends ThemeExtension<ProfileSummaryTheme> {
  const ProfileSummaryTheme({
    required this.gap,
    required this.iconSize,
    required this.iconColor,
    required this.iconBackground,
    required this.compactBreakpoint,
  });

  final double gap;
  final double iconSize;
  final Color iconColor;
  final Color iconBackground;
  final double compactBreakpoint;

  @override
  ProfileSummaryTheme copyWith({
    double? gap,
    double? iconSize,
    Color? iconColor,
    Color? iconBackground,
    double? compactBreakpoint,
  }) => ProfileSummaryTheme(
    gap: gap ?? this.gap,
    iconSize: iconSize ?? this.iconSize,
    iconColor: iconColor ?? this.iconColor,
    iconBackground: iconBackground ?? this.iconBackground,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
  );

  @override
  ProfileSummaryTheme lerp(covariant ProfileSummaryTheme? other, double t) {
    if (other == null) return this;
    return ProfileSummaryTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      iconBackground: Color.lerp(iconBackground, other.iconBackground, t)!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
    );
  }
}
