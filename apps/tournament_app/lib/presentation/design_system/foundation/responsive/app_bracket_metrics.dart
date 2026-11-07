import 'package:flutter/material.dart';

class AppBracketMetrics extends ThemeExtension<AppBracketMetrics> {
  const AppBracketMetrics({
    required this.width,
    required this.minHeight,
    required this.labelSize,
    required this.smallSize,
    required this.unknownSize,
  });
  final double width;
  final double minHeight;
  final double labelSize;
  final double smallSize;
  final double unknownSize;
  @override
  AppBracketMetrics copyWith({
    double? width,
    double? minHeight,
    double? labelSize,
    double? smallSize,
    double? unknownSize,
  }) => AppBracketMetrics(
    width: width ?? this.width,
    minHeight: minHeight ?? this.minHeight,
    labelSize: labelSize ?? this.labelSize,
    smallSize: smallSize ?? this.smallSize,
    unknownSize: unknownSize ?? this.unknownSize,
  );
  @override
  AppBracketMetrics lerp(covariant AppBracketMetrics? other, double t) =>
      other == null
      ? this
      : AppBracketMetrics(
          width: width + (other.width - width) * t,
          minHeight: minHeight + (other.minHeight - minHeight) * t,
          labelSize: labelSize + (other.labelSize - labelSize) * t,
          smallSize: smallSize + (other.smallSize - smallSize) * t,
          unknownSize: unknownSize + (other.unknownSize - unknownSize) * t,
        );
}
