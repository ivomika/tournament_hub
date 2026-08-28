import 'dart:ui';

import 'package:flutter/material.dart';

class DsInfoRowTheme extends ThemeExtension<DsInfoRowTheme> {
  const DsInfoRowTheme({required this.gap, required this.iconColor});

  final double gap;
  final Color iconColor;

  @override
  DsInfoRowTheme copyWith({double? gap, Color? iconColor}) => DsInfoRowTheme(
    gap: gap ?? this.gap,
    iconColor: iconColor ?? this.iconColor,
  );

  @override
  DsInfoRowTheme lerp(covariant DsInfoRowTheme? other, double t) {
    if (other == null) return this;
    return DsInfoRowTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
    );
  }
}
