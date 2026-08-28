import 'package:flutter/material.dart';

class DsActionTheme extends ThemeExtension<DsActionTheme> {
  const DsActionTheme({
    required this.primary,
    required this.secondary,
    required this.text,
    required this.contentGap,
  });

  final ButtonStyle primary;
  final ButtonStyle secondary;
  final ButtonStyle text;
  final double contentGap;

  @override
  DsActionTheme copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? text,
    double? contentGap,
  }) => DsActionTheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    text: text ?? this.text,
    contentGap: contentGap ?? this.contentGap,
  );

  @override
  DsActionTheme lerp(covariant DsActionTheme? other, double t) {
    if (other == null) return this;
    return DsActionTheme(
      primary: ButtonStyle.lerp(primary, other.primary, t)!,
      secondary: ButtonStyle.lerp(secondary, other.secondary, t)!,
      text: ButtonStyle.lerp(text, other.text, t)!,
      contentGap: contentGap + (other.contentGap - contentGap) * t,
    );
  }
}
