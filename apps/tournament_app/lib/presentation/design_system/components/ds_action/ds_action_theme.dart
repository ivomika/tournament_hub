import 'package:flutter/material.dart';

class DsActionTheme extends ThemeExtension<DsActionTheme> {
  const DsActionTheme({
    required this.primary,
    required this.secondary,
    required this.text,
    required this.danger,
    required this.contentGap,
    required this.success,
    required this.indicatorSize,
    required this.indicatorStrokeWidth,
  });

  final ButtonStyle primary;
  final ButtonStyle secondary;
  final ButtonStyle text;
  final ButtonStyle danger;
  final double contentGap;
  final Color success;
  final double indicatorSize;
  final double indicatorStrokeWidth;

  @override
  DsActionTheme copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? text,
    ButtonStyle? danger,
    double? contentGap,
    Color? success,
    double? indicatorSize,
    double? indicatorStrokeWidth,
  }) => DsActionTheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    text: text ?? this.text,
    danger: danger ?? this.danger,
    contentGap: contentGap ?? this.contentGap,
    success: success ?? this.success,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    indicatorStrokeWidth: indicatorStrokeWidth ?? this.indicatorStrokeWidth,
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
      success: Color.lerp(success, other.success, t)!,
      indicatorSize: indicatorSize + (other.indicatorSize - indicatorSize) * t,
      indicatorStrokeWidth:
          indicatorStrokeWidth +
          (other.indicatorStrokeWidth - indicatorStrokeWidth) * t,
    );
  }
}
