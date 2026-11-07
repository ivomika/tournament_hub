import 'package:flutter/material.dart';

/// Исходные const styles доступны только сборке основной Flutter TextTheme.
abstract final class TypographyPrimitives {
  static const compactHeaderLine = 1.4;
  static const comfortableHeaderLine = 1.3;
  static const normalTracking = 0.0;
  static const interfaceFamily = 'Inter';
  static const displayFamily = 'RobotoCondensed';
  static const display = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: displayFamily,
    fontSize: 60,
    letterSpacing: -2.4,
    fontWeight: FontWeight.w700,
    height: 1.05,
    fontVariations: [FontVariation('wght', 700)],
  );
  static const heading = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: displayFamily,
    fontSize: 40,
    letterSpacing: -1,
    fontWeight: FontWeight.w700,
    height: 1.15,
    fontVariations: [FontVariation('wght', 700)],
  );
  static const title = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: interfaceFamily,
    fontSize: 26,
    letterSpacing: -0.91,
    fontWeight: FontWeight.w600,
    height: 1.25,
    fontVariations: [FontVariation('wght', 600)],
  );
  static const bodyLarge = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: interfaceFamily,
    fontSize: 20,
    letterSpacing: normalTracking,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const body = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: interfaceFamily,
    fontSize: 18,
    letterSpacing: normalTracking,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const label = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: interfaceFamily,
    fontSize: 16,
    letterSpacing: normalTracking,
    fontWeight: FontWeight.w600,
    height: 1.5,
    fontVariations: [FontVariation('wght', 600)],
  );
  static const caption = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: interfaceFamily,
    fontSize: 14,
    letterSpacing: normalTracking,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const score = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
    fontFamily: displayFamily,
    fontSize: 60,
    letterSpacing: normalTracking,
    fontWeight: FontWeight.w700,
    height: 1,
    fontVariations: [FontVariation('wght', 700)],
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
