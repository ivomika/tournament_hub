import 'package:flutter/material.dart';

class DsSelectTheme extends ThemeExtension<DsSelectTheme> {
  const DsSelectTheme({required this.decoration, required this.menuMaxHeight});

  final InputDecoration decoration;
  final double menuMaxHeight;

  @override
  DsSelectTheme copyWith({
    InputDecoration? decoration,
    double? menuMaxHeight,
  }) => DsSelectTheme(
    decoration: decoration ?? this.decoration,
    menuMaxHeight: menuMaxHeight ?? this.menuMaxHeight,
  );

  @override
  DsSelectTheme lerp(covariant DsSelectTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}
