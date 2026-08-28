import 'dart:ui';

import 'package:flutter/material.dart';

class DangerZoneTheme extends ThemeExtension<DangerZoneTheme> {
  const DangerZoneTheme({required this.gap, required this.iconColor});

  final double gap;
  final Color iconColor;

  @override
  DangerZoneTheme copyWith({double? gap, Color? iconColor}) => DangerZoneTheme(
    gap: gap ?? this.gap,
    iconColor: iconColor ?? this.iconColor,
  );

  @override
  DangerZoneTheme lerp(covariant DangerZoneTheme? other, double t) {
    if (other == null) return this;
    return DangerZoneTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
    );
  }
}
