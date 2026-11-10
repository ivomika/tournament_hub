import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class FoundationLayout extends ThemeExtension<FoundationLayout> {
  const FoundationLayout({
    required this.pagePadding,
    required this.tilePadding,
    required this.smallGap,
    required this.gap,
    required this.sectionGap,
    required this.tileWidth,
    required this.colorTileHeight,
    required this.swatchSize,
    required this.borderWidth,
    required this.cornerRadius,
    required this.swatchRadius,
    required this.fullWidth,
    required this.textAlignment,
    required this.centered,
  });
  final EdgeInsets pagePadding;
  final EdgeInsets tilePadding;
  final double smallGap;
  final double gap;
  final double sectionGap;
  final double tileWidth;
  final double colorTileHeight;
  final double swatchSize;
  final double borderWidth;
  final BorderRadius cornerRadius;
  final BorderRadius swatchRadius;
  final double fullWidth;
  final CrossAxisAlignment textAlignment;
  final MainAxisAlignment centered;
  @override
  FoundationLayout copyWith({
    EdgeInsets? pagePadding,
    EdgeInsets? tilePadding,
    double? smallGap,
    double? gap,
    double? sectionGap,
    double? tileWidth,
    double? colorTileHeight,
    double? swatchSize,
    double? borderWidth,
    BorderRadius? cornerRadius,
    BorderRadius? swatchRadius,
    double? fullWidth,
    CrossAxisAlignment? textAlignment,
    MainAxisAlignment? centered,
  }) => FoundationLayout(
    pagePadding: pagePadding ?? this.pagePadding,
    tilePadding: tilePadding ?? this.tilePadding,
    smallGap: smallGap ?? this.smallGap,
    gap: gap ?? this.gap,
    sectionGap: sectionGap ?? this.sectionGap,
    tileWidth: tileWidth ?? this.tileWidth,
    colorTileHeight: colorTileHeight ?? this.colorTileHeight,
    swatchSize: swatchSize ?? this.swatchSize,
    borderWidth: borderWidth ?? this.borderWidth,
    cornerRadius: cornerRadius ?? this.cornerRadius,
    swatchRadius: swatchRadius ?? this.swatchRadius,
    fullWidth: fullWidth ?? this.fullWidth,
    textAlignment: textAlignment ?? this.textAlignment,
    centered: centered ?? this.centered,
  );
  @override
  FoundationLayout lerp(
    covariant FoundationLayout? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return FoundationLayout(
      pagePadding: EdgeInsets.lerp(
        pagePadding,
        other.pagePadding,
        interpolationAmount,
      )!,
      tilePadding: EdgeInsets.lerp(
        tilePadding,
        other.tilePadding,
        interpolationAmount,
      )!,
      smallGap: smallGap == other.smallGap
          ? smallGap
          : lerpDouble(smallGap, other.smallGap, interpolationAmount)!,
      gap: gap == other.gap
          ? gap
          : lerpDouble(gap, other.gap, interpolationAmount)!,
      sectionGap: sectionGap == other.sectionGap
          ? sectionGap
          : lerpDouble(sectionGap, other.sectionGap, interpolationAmount)!,
      tileWidth: tileWidth == other.tileWidth
          ? tileWidth
          : lerpDouble(tileWidth, other.tileWidth, interpolationAmount)!,
      colorTileHeight: colorTileHeight == other.colorTileHeight
          ? colorTileHeight
          : lerpDouble(
              colorTileHeight,
              other.colorTileHeight,
              interpolationAmount,
            )!,
      swatchSize: swatchSize == other.swatchSize
          ? swatchSize
          : lerpDouble(swatchSize, other.swatchSize, interpolationAmount)!,
      borderWidth: borderWidth == other.borderWidth
          ? borderWidth
          : lerpDouble(borderWidth, other.borderWidth, interpolationAmount)!,
      cornerRadius: BorderRadius.lerp(
        cornerRadius,
        other.cornerRadius,
        interpolationAmount,
      )!,
      swatchRadius: BorderRadius.lerp(
        swatchRadius,
        other.swatchRadius,
        interpolationAmount,
      )!,
      fullWidth: fullWidth == other.fullWidth
          ? fullWidth
          : lerpDouble(fullWidth, other.fullWidth, interpolationAmount)!,
      textAlignment: interpolationAmount < 0.5
          ? textAlignment
          : other.textAlignment,
      centered: interpolationAmount < 0.5 ? centered : other.centered,
    );
  }
}
