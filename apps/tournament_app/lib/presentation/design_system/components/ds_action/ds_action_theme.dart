import 'package:flutter/material.dart';

class DsActionTheme extends ThemeExtension<DsActionTheme> {
  const DsActionTheme({
    required this.primary,
    required this.secondary,
    required this.text,
    required this.danger,
    required this.contentGap,
  });

  final ButtonStyle primary;
  final ButtonStyle secondary;
  final ButtonStyle text;
  final ButtonStyle danger;
  final double contentGap;

  @override
  DsActionTheme copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? text,
    ButtonStyle? danger,
    double? contentGap,
  }) => DsActionTheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    text: text ?? this.text,
    danger: danger ?? this.danger,
    contentGap: contentGap ?? this.contentGap,
  );

  @override
  DsActionTheme lerp(covariant DsActionTheme? other, double t) {
    if (other == null) return this;
    return DsActionTheme(
      primary: ButtonStyle.lerp(primary, other.primary, t)!,
      secondary: ButtonStyle.lerp(secondary, other.secondary, t)!,
      text: ButtonStyle.lerp(text, other.text, t)!,
      danger: ButtonStyle.lerp(danger, other.danger, t)!,
      contentGap: contentGap + (other.contentGap - contentGap) * t,
    );
  }
}
