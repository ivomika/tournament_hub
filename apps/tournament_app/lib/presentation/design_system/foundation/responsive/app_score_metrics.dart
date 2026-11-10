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
  AppScoreMetrics lerp(
    covariant AppScoreMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppScoreMetrics(
      desktopSize:
          desktopSize + (other.desktopSize - desktopSize) * interpolationAmount,
      lineHeight:
          lineHeight + (other.lineHeight - lineHeight) * interpolationAmount,
    );
  }
}
