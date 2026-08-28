import 'dart:ui';

import 'package:flutter/material.dart';

class OutcomePickerTheme extends ThemeExtension<OutcomePickerTheme> {
  const OutcomePickerTheme({
    required this.gap,
    required this.compactBreakpoint,
  });

  final double gap;
  final double compactBreakpoint;

  @override
  OutcomePickerTheme copyWith({double? gap, double? compactBreakpoint}) =>
      OutcomePickerTheme(
        gap: gap ?? this.gap,
        compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
      );

  @override
  OutcomePickerTheme lerp(covariant OutcomePickerTheme? other, double t) {
    if (other == null) return this;
    return OutcomePickerTheme(
      gap: lerpDouble(gap, other.gap, t)!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
    );
  }
}
