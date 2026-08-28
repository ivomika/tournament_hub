import 'dart:ui';

import 'package:flutter/material.dart';

class ConnectionBannerTheme extends ThemeExtension<ConnectionBannerTheme> {
  const ConnectionBannerTheme({required this.gap, required this.compactWidth});

  final double gap;
  final double compactWidth;

  @override
  ConnectionBannerTheme copyWith({double? gap, double? compactWidth}) =>
      ConnectionBannerTheme(
        gap: gap ?? this.gap,
        compactWidth: compactWidth ?? this.compactWidth,
      );

  @override
  ConnectionBannerTheme lerp(covariant ConnectionBannerTheme? other, double t) {
    if (other == null) return this;
    return ConnectionBannerTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      compactWidth: lerpDouble(compactWidth, other.compactWidth, t)!,
    );
  }
}
