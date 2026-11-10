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
  AppQrMetrics lerp(covariant AppQrMetrics? other, double interpolationAmount) {
    if (other == null) return this;
    return AppQrMetrics(
      moduleRadius:
          moduleRadius +
          (other.moduleRadius - moduleRadius) * interpolationAmount,
      finderOuterRadius:
          finderOuterRadius +
          (other.finderOuterRadius - finderOuterRadius) * interpolationAmount,
      finderGapRadius:
          finderGapRadius +
          (other.finderGapRadius - finderGapRadius) * interpolationAmount,
      finderCenterRadius:
          finderCenterRadius +
          (other.finderCenterRadius - finderCenterRadius) * interpolationAmount,
      quietZone:
          quietZone + (other.quietZone - quietZone) * interpolationAmount,
      mobileExtent:
          mobileExtent +
          (other.mobileExtent - mobileExtent) * interpolationAmount,
      desktopExtent:
          desktopExtent +
          (other.desktopExtent - desktopExtent) * interpolationAmount,
      aspectRatio:
          aspectRatio + (other.aspectRatio - aspectRatio) * interpolationAmount,
      codeLine: codeLine + (other.codeLine - codeLine) * interpolationAmount,
      codeFit: interpolationAmount < .5 ? codeFit : other.codeFit,
      blendMode: interpolationAmount < .5 ? blendMode : other.blendMode,
    );
  }
}
