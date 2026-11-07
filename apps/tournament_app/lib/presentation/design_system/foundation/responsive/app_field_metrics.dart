import 'package:flutter/material.dart';

class AppFieldMetrics extends ThemeExtension<AppFieldMetrics> {
  const AppFieldMetrics({
    required this.mobileMessageHeight,
    required this.desktopMessageHeight,
    required this.singleLine,
    required this.centerLeft,
    required this.stretch,
    required this.start,
  });
  final double mobileMessageHeight, desktopMessageHeight;
  final int singleLine;
  final Alignment centerLeft;
  final CrossAxisAlignment stretch, start;
  @override
  AppFieldMetrics copyWith({
    double? mobileMessageHeight,
    double? desktopMessageHeight,
    int? singleLine,
    Alignment? centerLeft,
    CrossAxisAlignment? stretch,
    CrossAxisAlignment? start,
  }) => AppFieldMetrics(
    mobileMessageHeight: mobileMessageHeight ?? this.mobileMessageHeight,
    desktopMessageHeight: desktopMessageHeight ?? this.desktopMessageHeight,
    singleLine: singleLine ?? this.singleLine,
    centerLeft: centerLeft ?? this.centerLeft,
    stretch: stretch ?? this.stretch,
    start: start ?? this.start,
  );
  @override
  AppFieldMetrics lerp(covariant AppFieldMetrics? other, double t) =>
      other == null
      ? this
      : AppFieldMetrics(
          mobileMessageHeight:
              mobileMessageHeight +
              (other.mobileMessageHeight - mobileMessageHeight) * t,
          desktopMessageHeight:
              desktopMessageHeight +
              (other.desktopMessageHeight - desktopMessageHeight) * t,
          singleLine: t < .5 ? singleLine : other.singleLine,
          centerLeft: Alignment.lerp(centerLeft, other.centerLeft, t)!,
          stretch: t < .5 ? stretch : other.stretch,
          start: t < .5 ? start : other.start,
        );
}
