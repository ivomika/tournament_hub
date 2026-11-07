import 'package:flutter/material.dart';

class AppQrMetrics extends ThemeExtension<AppQrMetrics> {
  const AppQrMetrics({
    required this.mobileExtent,
    required this.desktopExtent,
    required this.aspectRatio,
    required this.codeLine,
    required this.codeFit,
    required this.blendMode,
  });
  final double mobileExtent;
  final double desktopExtent;
  final double aspectRatio;
  final double codeLine;
  final BoxFit codeFit;
  final BlendMode blendMode;
  @override
  AppQrMetrics copyWith({
    double? mobileExtent,
    double? desktopExtent,
    double? aspectRatio,
    double? codeLine,
    BoxFit? codeFit,
    BlendMode? blendMode,
  }) => AppQrMetrics(
    mobileExtent: mobileExtent ?? this.mobileExtent,
    desktopExtent: desktopExtent ?? this.desktopExtent,
    aspectRatio: aspectRatio ?? this.aspectRatio,
    codeLine: codeLine ?? this.codeLine,
    codeFit: codeFit ?? this.codeFit,
    blendMode: blendMode ?? this.blendMode,
  );
  @override
  AppQrMetrics lerp(covariant AppQrMetrics? other, double t) => other == null
      ? this
      : AppQrMetrics(
          mobileExtent: mobileExtent + (other.mobileExtent - mobileExtent) * t,
          desktopExtent:
              desktopExtent + (other.desktopExtent - desktopExtent) * t,
          aspectRatio: aspectRatio + (other.aspectRatio - aspectRatio) * t,
          codeLine: codeLine + (other.codeLine - codeLine) * t,
          codeFit: t < .5 ? codeFit : other.codeFit,
          blendMode: t < .5 ? blendMode : other.blendMode,
        );
}
