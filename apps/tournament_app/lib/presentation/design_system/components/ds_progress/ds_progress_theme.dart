import 'dart:ui';

import 'package:flutter/material.dart';

class DsProgressTheme extends ThemeExtension<DsProgressTheme> {
  const DsProgressTheme({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  DsProgressTheme copyWith({Color? color, double? size}) =>
      DsProgressTheme(color: color ?? this.color, size: size ?? this.size);

  @override
  DsProgressTheme lerp(covariant DsProgressTheme? other, double t) {
    if (other == null) return this;
    return DsProgressTheme(
      color: Color.lerp(color, other.color, t)!,
      size: lerpDouble(size, other.size, t)!,
    );
  }
}
