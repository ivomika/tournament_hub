import 'package:flutter/material.dart';

class DsFieldTheme extends ThemeExtension<DsFieldTheme> {
  const DsFieldTheme({required this.decoration});

  final InputDecoration decoration;

  @override
  DsFieldTheme copyWith({InputDecoration? decoration}) =>
      DsFieldTheme(decoration: decoration ?? this.decoration);

  @override
  DsFieldTheme lerp(covariant DsFieldTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}
