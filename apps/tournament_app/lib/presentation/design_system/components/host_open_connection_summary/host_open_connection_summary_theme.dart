import 'package:flutter/material.dart';

class HostOpenConnectionSummaryTheme
    extends ThemeExtension<HostOpenConnectionSummaryTheme> {
  const HostOpenConnectionSummaryTheme({required this.gap});

  final double gap;

  @override
  HostOpenConnectionSummaryTheme copyWith({double? gap}) =>
      HostOpenConnectionSummaryTheme(gap: gap ?? this.gap);

  @override
  HostOpenConnectionSummaryTheme lerp(
    covariant HostOpenConnectionSummaryTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return HostOpenConnectionSummaryTheme(gap: gap + (other.gap - gap) * t);
  }
}
