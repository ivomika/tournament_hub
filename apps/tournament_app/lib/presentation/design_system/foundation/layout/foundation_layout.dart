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
  FoundationLayout lerp(covariant FoundationLayout? other, double t) {
    if (other == null) return this;
    return FoundationLayout(
      pagePadding: EdgeInsets.lerp(pagePadding, other.pagePadding, t)!,
      tilePadding: EdgeInsets.lerp(tilePadding, other.tilePadding, t)!,
      smallGap: smallGap == other.smallGap
          ? smallGap
          : lerpDouble(smallGap, other.smallGap, t)!,
      gap: gap == other.gap ? gap : lerpDouble(gap, other.gap, t)!,
      sectionGap: sectionGap == other.sectionGap
          ? sectionGap
          : lerpDouble(sectionGap, other.sectionGap, t)!,
      tileWidth: tileWidth == other.tileWidth
          ? tileWidth
          : lerpDouble(tileWidth, other.tileWidth, t)!,
      colorTileHeight: colorTileHeight == other.colorTileHeight
          ? colorTileHeight
          : lerpDouble(colorTileHeight, other.colorTileHeight, t)!,
      swatchSize: swatchSize == other.swatchSize
          ? swatchSize
          : lerpDouble(swatchSize, other.swatchSize, t)!,
      borderWidth: borderWidth == other.borderWidth
          ? borderWidth
          : lerpDouble(borderWidth, other.borderWidth, t)!,
      cornerRadius: BorderRadius.lerp(cornerRadius, other.cornerRadius, t)!,
      swatchRadius: BorderRadius.lerp(swatchRadius, other.swatchRadius, t)!,
      fullWidth: fullWidth == other.fullWidth
          ? fullWidth
          : lerpDouble(fullWidth, other.fullWidth, t)!,
      textAlignment: t < 0.5 ? textAlignment : other.textAlignment,
      centered: t < 0.5 ? centered : other.centered,
    );
  }
}
