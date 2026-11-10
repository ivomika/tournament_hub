import 'package:flutter/material.dart';

class AppProgressMetrics extends ThemeExtension<AppProgressMetrics> {
  const AppProgressMetrics({
    required this.height,
    required this.width,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.wavelength,
    required this.waveSpeed,
    required this.staticValue,
  });
  final double height;
  final double width;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double wavelength;
  final double waveSpeed;
  final double staticValue;
  @override
  AppProgressMetrics copyWith({
    double? height,
    double? width,
    double? strokeWidth,
    double? trackStrokeWidth,
    double? wavelength,
    double? waveSpeed,
    double? staticValue,
  }) => AppProgressMetrics(
    height: height ?? this.height,
    width: width ?? this.width,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    trackStrokeWidth: trackStrokeWidth ?? this.trackStrokeWidth,
    wavelength: wavelength ?? this.wavelength,
    waveSpeed: waveSpeed ?? this.waveSpeed,
    staticValue: staticValue ?? this.staticValue,
  );
  @override
  AppProgressMetrics lerp(
    covariant AppProgressMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppProgressMetrics(
      height: height + (other.height - height) * interpolationAmount,
      width: width + (other.width - width) * interpolationAmount,
      strokeWidth:
          strokeWidth + (other.strokeWidth - strokeWidth) * interpolationAmount,
      trackStrokeWidth:
          trackStrokeWidth +
          (other.trackStrokeWidth - trackStrokeWidth) * interpolationAmount,
      wavelength:
          wavelength + (other.wavelength - wavelength) * interpolationAmount,
      waveSpeed:
          waveSpeed + (other.waveSpeed - waveSpeed) * interpolationAmount,
      staticValue:
          staticValue + (other.staticValue - staticValue) * interpolationAmount,
    );
  }
}
