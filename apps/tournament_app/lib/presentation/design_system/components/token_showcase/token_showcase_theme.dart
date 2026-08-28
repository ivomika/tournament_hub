import 'package:flutter/material.dart';

@immutable
class TokenColorSample {
  const TokenColorSample(this.name, this.value);

  final String name;
  final Color value;
}

@immutable
class TokenMetricSample {
  const TokenMetricSample(this.name, this.value, this.unit);

  final String name;
  final Object value;
  final String unit;
}

@immutable
class TokenShowcaseTheme extends ThemeExtension<TokenShowcaseTheme> {
  const TokenShowcaseTheme({
    required this.colors,
    required this.spacing,
    required this.radii,
    required this.typography,
    required this.breakpoints,
    required this.layout,
    required this.controls,
    required this.artwork,
    required this.borders,
    required this.motion,
    required this.gap,
    required this.swatchSize,
    required this.swatchRadius,
  });

  final List<TokenColorSample> colors;
  final List<TokenMetricSample> spacing;
  final List<TokenMetricSample> radii;
  final List<TokenMetricSample> typography;
  final List<TokenMetricSample> breakpoints;
  final List<TokenMetricSample> layout;
  final List<TokenMetricSample> controls;
  final List<TokenMetricSample> artwork;
  final List<TokenMetricSample> borders;
  final List<TokenMetricSample> motion;
  final double gap;
  final double swatchSize;
  final double swatchRadius;

  @override
  TokenShowcaseTheme copyWith({
    List<TokenColorSample>? colors,
    List<TokenMetricSample>? spacing,
    List<TokenMetricSample>? radii,
    List<TokenMetricSample>? typography,
    List<TokenMetricSample>? breakpoints,
    List<TokenMetricSample>? layout,
    List<TokenMetricSample>? controls,
    List<TokenMetricSample>? artwork,
    List<TokenMetricSample>? borders,
    List<TokenMetricSample>? motion,
    double? gap,
    double? swatchSize,
    double? swatchRadius,
  }) => TokenShowcaseTheme(
    colors: colors ?? this.colors,
    spacing: spacing ?? this.spacing,
    radii: radii ?? this.radii,
    typography: typography ?? this.typography,
    breakpoints: breakpoints ?? this.breakpoints,
    layout: layout ?? this.layout,
    controls: controls ?? this.controls,
    artwork: artwork ?? this.artwork,
    borders: borders ?? this.borders,
    motion: motion ?? this.motion,
    gap: gap ?? this.gap,
    swatchSize: swatchSize ?? this.swatchSize,
    swatchRadius: swatchRadius ?? this.swatchRadius,
  );

  @override
  TokenShowcaseTheme lerp(covariant TokenShowcaseTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
