import 'package:flutter/material.dart';

class AppTextMetrics extends ThemeExtension<AppTextMetrics> {
  const AppTextMetrics({
    required this.compactHeaderLine,
    required this.comfortableHeaderLine,
  });
  final double compactHeaderLine, comfortableHeaderLine;
  @override
  AppTextMetrics copyWith({
    double? compactHeaderLine,
    double? comfortableHeaderLine,
  }) => AppTextMetrics(
    compactHeaderLine: compactHeaderLine ?? this.compactHeaderLine,
    comfortableHeaderLine: comfortableHeaderLine ?? this.comfortableHeaderLine,
  );
  @override
  AppTextMetrics lerp(covariant AppTextMetrics? other, double t) =>
      other == null
      ? this
      : AppTextMetrics(
          compactHeaderLine:
              compactHeaderLine +
              (other.compactHeaderLine - compactHeaderLine) * t,
          comfortableHeaderLine:
              comfortableHeaderLine +
              (other.comfortableHeaderLine - comfortableHeaderLine) * t,
        );
}
