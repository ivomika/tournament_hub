import 'dart:ui';

import 'package:flutter/material.dart';

class QrQuietZoneTheme extends ThemeExtension<QrQuietZoneTheme> {
  const QrQuietZoneTheme({
    required this.background,
    required this.modules,
    required this.radius,
  }) : assert(modules >= 4, 'QR quiet zone must be at least four modules');

  final Color background;
  final double modules;
  final double radius;

  @override
  QrQuietZoneTheme copyWith({
    Color? background,
    double? modules,
    double? radius,
  }) => QrQuietZoneTheme(
    background: background ?? this.background,
    modules: modules ?? this.modules,
    radius: radius ?? this.radius,
  );

  @override
  QrQuietZoneTheme lerp(covariant QrQuietZoneTheme? other, double t) {
    if (other == null) return this;
    return QrQuietZoneTheme(
      background: Color.lerp(background, other.background, t)!,
      modules: lerpDouble(modules, other.modules, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
    );
  }
}
