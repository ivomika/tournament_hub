import 'package:flutter/material.dart';

class AppControlMetrics extends ThemeExtension<AppControlMetrics> {
  const AppControlMetrics({
    required this.half,
    required this.regularWeight,
    required this.regularVariations,
    required this.regularLine,
    required this.spaceBetween,
    required this.center,
    required this.centerCross,
    required this.topLeft,
    required this.zero,
    required this.transparent,
    required this.removeWidth,
    required this.removeHeight,
    required this.removeIconExtent,
  });
  final double half;
  final FontWeight regularWeight;
  final List<FontVariation> regularVariations;
  final double regularLine;
  final MainAxisAlignment spaceBetween;
  final MainAxisAlignment center;
  final CrossAxisAlignment centerCross;
  final Alignment topLeft;
  final double zero;
  final Color transparent;
  final double removeWidth;
  final double removeHeight;
  final double removeIconExtent;
  @override
  AppControlMetrics copyWith({
    double? half,
    FontWeight? regularWeight,
    List<FontVariation>? regularVariations,
    double? regularLine,
    MainAxisAlignment? spaceBetween,
    MainAxisAlignment? center,
    CrossAxisAlignment? centerCross,
    Alignment? topLeft,
    double? zero,
    Color? transparent,
    double? removeWidth,
    double? removeHeight,
    double? removeIconExtent,
  }) => AppControlMetrics(
    half: half ?? this.half,
    regularWeight: regularWeight ?? this.regularWeight,
    regularVariations: regularVariations ?? this.regularVariations,
    regularLine: regularLine ?? this.regularLine,
    spaceBetween: spaceBetween ?? this.spaceBetween,
    center: center ?? this.center,
    centerCross: centerCross ?? this.centerCross,
    topLeft: topLeft ?? this.topLeft,
    zero: zero ?? this.zero,
    transparent: transparent ?? this.transparent,
    removeWidth: removeWidth ?? this.removeWidth,
    removeHeight: removeHeight ?? this.removeHeight,
    removeIconExtent: removeIconExtent ?? this.removeIconExtent,
  );
  @override
  AppControlMetrics lerp(covariant AppControlMetrics? other, double t) =>
      other == null
      ? this
      : AppControlMetrics(
          half: half + (other.half - half) * t,
          regularWeight: t < 0.5 ? regularWeight : other.regularWeight,
          regularVariations: t < 0.5
              ? regularVariations
              : other.regularVariations,
          regularLine: regularLine + (other.regularLine - regularLine) * t,
          spaceBetween: t < 0.5 ? spaceBetween : other.spaceBetween,
          center: t < 0.5 ? center : other.center,
          centerCross: t < 0.5 ? centerCross : other.centerCross,
          topLeft: t < 0.5 ? topLeft : other.topLeft,
          zero: zero + (other.zero - zero) * t,
          transparent: t < 0.5 ? transparent : other.transparent,
          removeWidth: removeWidth + (other.removeWidth - removeWidth) * t,
          removeHeight: removeHeight + (other.removeHeight - removeHeight) * t,
          removeIconExtent:
              removeIconExtent +
              (other.removeIconExtent - removeIconExtent) * t,
        );
}
