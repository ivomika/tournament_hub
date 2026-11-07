import 'package:flutter/material.dart';

class AppScoreMetrics extends ThemeExtension<AppScoreMetrics> {
  const AppScoreMetrics({required this.desktopSize, required this.lineHeight});
  final double desktopSize, lineHeight;
  @override
  AppScoreMetrics copyWith({double? desktopSize, double? lineHeight}) =>
      AppScoreMetrics(
        desktopSize: desktopSize ?? this.desktopSize,
        lineHeight: lineHeight ?? this.lineHeight,
      );
  @override
  AppScoreMetrics lerp(covariant AppScoreMetrics? other, double t) =>
      other == null
      ? this
      : AppScoreMetrics(
          desktopSize: desktopSize + (other.desktopSize - desktopSize) * t,
          lineHeight: lineHeight + (other.lineHeight - lineHeight) * t,
        );
}
