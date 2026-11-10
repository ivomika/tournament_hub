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
  AppBracketMetrics lerp(
    covariant AppBracketMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppBracketMetrics(
      width: width + (other.width - width) * interpolationAmount,
      minHeight:
          minHeight + (other.minHeight - minHeight) * interpolationAmount,
      labelSize:
          labelSize + (other.labelSize - labelSize) * interpolationAmount,
      smallSize:
          smallSize + (other.smallSize - smallSize) * interpolationAmount,
      unknownSize:
          unknownSize + (other.unknownSize - unknownSize) * interpolationAmount,
    );
  }
}
