import 'package:flutter/material.dart';

class AppStepperMetrics extends ThemeExtension<AppStepperMetrics> {
  const AppStepperMetrics({
    required this.labelStackWidth,
    required this.disabledOpacity,
    required this.valueAlignment,
    required this.center,
    required this.numericFeatures,
  });
  final double labelStackWidth;
  final double disabledOpacity;
  final TextAlign valueAlignment;
  final Alignment center;
  final List<FontFeature> numericFeatures;
  @override
  AppStepperMetrics copyWith({
    double? labelStackWidth,
    double? disabledOpacity,
    TextAlign? valueAlignment,
    Alignment? center,
    List<FontFeature>? numericFeatures,
  }) => AppStepperMetrics(
    labelStackWidth: labelStackWidth ?? this.labelStackWidth,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    valueAlignment: valueAlignment ?? this.valueAlignment,
    center: center ?? this.center,
    numericFeatures: numericFeatures ?? this.numericFeatures,
  );
  @override
  AppStepperMetrics lerp(covariant AppStepperMetrics? other, double t) =>
      other == null
      ? this
      : AppStepperMetrics(
          labelStackWidth:
              labelStackWidth + (other.labelStackWidth - labelStackWidth) * t,
          disabledOpacity:
              disabledOpacity + (other.disabledOpacity - disabledOpacity) * t,
          valueAlignment: t < .5 ? valueAlignment : other.valueAlignment,
          center: t < .5 ? center : other.center,
          numericFeatures: t < .5 ? numericFeatures : other.numericFeatures,
        );
}
