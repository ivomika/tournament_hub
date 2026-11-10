import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppMotion extends ThemeExtension<AppMotion> {
  const AppMotion({
    required this.reveal,
    required this.reduced,
    required this.curve,
  });
  final Duration reveal;
  final Duration reduced;
  final Curve curve;
  @override
  AppMotion copyWith({Duration? reveal, Duration? reduced, Curve? curve}) =>
      AppMotion(
        reveal: reveal ?? this.reveal,
        reduced: reduced ?? this.reduced,
        curve: curve ?? this.curve,
      );
  @override
  AppMotion lerp(covariant AppMotion? other, double interpolationAmount) {
    if (other == null) return this;
    return AppMotion(
      reveal: Duration(
        microseconds: lerpDouble(
          reveal.inMicroseconds,
          other.reveal.inMicroseconds,
          interpolationAmount,
        )!.round(),
      ),
      reduced: Duration(
        microseconds: lerpDouble(
          reduced.inMicroseconds,
          other.reduced.inMicroseconds,
          interpolationAmount,
        )!.round(),
      ),
      curve: interpolationAmount < 0.5 ? curve : other.curve,
    );
  }
}
