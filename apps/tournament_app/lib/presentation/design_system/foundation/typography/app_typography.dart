import 'package:flutter/material.dart';

/// Готовые color-neutral TextStyle. Цвет назначает component theme.
abstract final class AppTypography {
  static const interfaceFamily = 'Inter';
  static const displayFamily = 'RobotoCondensed';
  static const display = TextStyle(
    fontFamily: displayFamily,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.05,
    fontVariations: [FontVariation('wght', 700)],
  );
  static const heading = TextStyle(
    fontFamily: displayFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.15,
    fontVariations: [FontVariation('wght', 700)],
  );
  static const title = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.25,
    fontVariations: [FontVariation('wght', 600)],
  );
  static const bodyLarge = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const body = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const label = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    fontVariations: [FontVariation('wght', 600)],
  );
  static const caption = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontVariations: [FontVariation('wght', 400)],
  );
  static const score = TextStyle(
    fontFamily: interfaceFamily,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.1,
    fontVariations: [FontVariation('wght', 700)],
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
