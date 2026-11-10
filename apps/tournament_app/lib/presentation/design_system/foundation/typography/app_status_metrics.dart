import 'package:flutter/material.dart';

class AppStatusMetrics extends ThemeExtension<AppStatusMetrics> {
  const AppStatusMetrics({required this.inlineHeightBehavior});
  final TextHeightBehavior inlineHeightBehavior;
  @override
  AppStatusMetrics copyWith({TextHeightBehavior? inlineHeightBehavior}) =>
      AppStatusMetrics(
        inlineHeightBehavior: inlineHeightBehavior ?? this.inlineHeightBehavior,
      );
  @override
  AppStatusMetrics lerp(
    covariant AppStatusMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppStatusMetrics(
      inlineHeightBehavior: interpolationAmount < .5
          ? inlineHeightBehavior
          : other.inlineHeightBehavior,
    );
  }
}
