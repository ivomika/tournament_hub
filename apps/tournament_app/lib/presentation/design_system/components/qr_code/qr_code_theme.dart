import 'dart:ui';

import 'package:flutter/material.dart';

class QrCodeTheme extends ThemeExtension<QrCodeTheme> {
  const QrCodeTheme({
    required this.foreground,
    required this.fallbackBackground,
    required this.fallbackForeground,
    required this.moduleRoundFactor,
    required this.finderOuterRadiusFactor,
    required this.finderCenterRadiusFactor,
    required this.compactSize,
    required this.standardSize,
    required this.largeSize,
    required this.minimumModulePitch,
    required this.fallbackIconSize,
  });

  final Color foreground;
  final Color fallbackBackground;
  final Color fallbackForeground;
  final double moduleRoundFactor;
  final double finderOuterRadiusFactor;
  final double finderCenterRadiusFactor;
  final double compactSize;
  final double standardSize;
  final double largeSize;
  final double minimumModulePitch;
  final double fallbackIconSize;

  @override
  QrCodeTheme copyWith({
    Color? foreground,
    Color? fallbackBackground,
    Color? fallbackForeground,
    double? moduleRoundFactor,
    double? finderOuterRadiusFactor,
    double? finderCenterRadiusFactor,
    double? compactSize,
    double? standardSize,
    double? largeSize,
    double? minimumModulePitch,
    double? fallbackIconSize,
  }) => QrCodeTheme(
    foreground: foreground ?? this.foreground,
    fallbackBackground: fallbackBackground ?? this.fallbackBackground,
    fallbackForeground: fallbackForeground ?? this.fallbackForeground,
    moduleRoundFactor: moduleRoundFactor ?? this.moduleRoundFactor,
    finderOuterRadiusFactor:
        finderOuterRadiusFactor ?? this.finderOuterRadiusFactor,
    finderCenterRadiusFactor:
        finderCenterRadiusFactor ?? this.finderCenterRadiusFactor,
    compactSize: compactSize ?? this.compactSize,
    standardSize: standardSize ?? this.standardSize,
    largeSize: largeSize ?? this.largeSize,
    minimumModulePitch: minimumModulePitch ?? this.minimumModulePitch,
    fallbackIconSize: fallbackIconSize ?? this.fallbackIconSize,
  );

  @override
  QrCodeTheme lerp(covariant QrCodeTheme? other, double t) {
    if (other == null) return this;
    return QrCodeTheme(
      foreground: Color.lerp(foreground, other.foreground, t)!,
      fallbackBackground: Color.lerp(
        fallbackBackground,
        other.fallbackBackground,
        t,
      )!,
      fallbackForeground: Color.lerp(
        fallbackForeground,
        other.fallbackForeground,
        t,
      )!,
      moduleRoundFactor: lerpDouble(
        moduleRoundFactor,
        other.moduleRoundFactor,
        t,
      )!,
      finderOuterRadiusFactor: lerpDouble(
        finderOuterRadiusFactor,
        other.finderOuterRadiusFactor,
        t,
      )!,
      finderCenterRadiusFactor: lerpDouble(
        finderCenterRadiusFactor,
        other.finderCenterRadiusFactor,
        t,
      )!,
      compactSize: lerpDouble(compactSize, other.compactSize, t)!,
      standardSize: lerpDouble(standardSize, other.standardSize, t)!,
      largeSize: lerpDouble(largeSize, other.largeSize, t)!,
      minimumModulePitch: lerpDouble(
        minimumModulePitch,
        other.minimumModulePitch,
        t,
      )!,
      fallbackIconSize: lerpDouble(
        fallbackIconSize,
        other.fallbackIconSize,
        t,
      )!,
    );
  }
}
