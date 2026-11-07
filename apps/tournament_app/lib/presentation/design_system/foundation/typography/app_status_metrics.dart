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
  AppStatusMetrics lerp(covariant AppStatusMetrics? other, double t) =>
      other == null
      ? this
      : AppStatusMetrics(
          inlineHeightBehavior: t < .5
              ? inlineHeightBehavior
              : other.inlineHeightBehavior,
        );
}
