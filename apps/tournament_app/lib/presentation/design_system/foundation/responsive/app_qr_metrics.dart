import 'package:flutter/material.dart';

class AppQrMetrics extends ThemeExtension<AppQrMetrics> {
  const AppQrMetrics({
    required this.moduleRadius,
    required this.finderOuterRadius,
    required this.finderGapRadius,
    required this.finderCenterRadius,
    required this.quietZone,
    required this.mobileExtent,
    required this.desktopExtent,
    required this.aspectRatio,
    required this.codeLine,
    required this.codeFit,
    required this.blendMode,
  });
  final double moduleRadius,
      finderOuterRadius,
      finderGapRadius,
      finderCenterRadius,
      quietZone;
  final double mobileExtent;
  final double desktopExtent;
  final double aspectRatio;
  final double codeLine;
  final BoxFit codeFit;
  final BlendMode blendMode;
  @override
  AppQrMetrics copyWith({
    double? moduleRadius,
    double? finderOuterRadius,
    double? finderGapRadius,
    double? finderCenterRadius,
    double? quietZone,
    double? mobileExtent,
    double? desktopExtent,
    double? aspectRatio,
    double? codeLine,
    BoxFit? codeFit,
    BlendMode? blendMode,
  }) => AppQrMetrics(
    moduleRadius: moduleRadius ?? this.moduleRadius,
    finderOuterRadius: finderOuterRadius ?? this.finderOuterRadius,
    finderGapRadius: finderGapRadius ?? this.finderGapRadius,
    finderCenterRadius: finderCenterRadius ?? this.finderCenterRadius,
    quietZone: quietZone ?? this.quietZone,
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
          moduleRadius: moduleRadius + (other.moduleRadius - moduleRadius) * t,
          finderOuterRadius:
              finderOuterRadius +
              (other.finderOuterRadius - finderOuterRadius) * t,
          finderGapRadius:
              finderGapRadius + (other.finderGapRadius - finderGapRadius) * t,
          finderCenterRadius:
              finderCenterRadius +
              (other.finderCenterRadius - finderCenterRadius) * t,
          quietZone: quietZone + (other.quietZone - quietZone) * t,
          mobileExtent: mobileExtent + (other.mobileExtent - mobileExtent) * t,
          desktopExtent:
              desktopExtent + (other.desktopExtent - desktopExtent) * t,
          aspectRatio: aspectRatio + (other.aspectRatio - aspectRatio) * t,
          codeLine: codeLine + (other.codeLine - codeLine) * t,
          codeFit: t < .5 ? codeFit : other.codeFit,
          blendMode: t < .5 ? blendMode : other.blendMode,
        );
}
