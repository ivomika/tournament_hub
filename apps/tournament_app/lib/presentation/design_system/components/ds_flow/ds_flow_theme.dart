import 'package:flutter/material.dart';

@immutable
class DsFlowTheme extends ThemeExtension<DsFlowTheme> {
  const DsFlowTheme({required this.gap});

  final double gap;

  @override
  DsFlowTheme copyWith({double? gap}) => DsFlowTheme(gap: gap ?? this.gap);

  @override
  DsFlowTheme lerp(covariant DsFlowTheme? other, double t) {
    if (other == null) return this;
    return DsFlowTheme(gap: gap + (other.gap - gap) * t);
  }
}
