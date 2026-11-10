import 'package:flutter/material.dart';

class AppDialogMetrics extends ThemeExtension<AppDialogMetrics> {
  const AppDialogMetrics({
    required this.desktopInset,
    required this.maxWidth,
    required this.mobileTitleLine,
    required this.desktopTitleLine,
    required this.desktopTitleSize,
  });
  final double desktopInset;
  final double maxWidth;
  final double mobileTitleLine;
  final double desktopTitleLine;
  final double desktopTitleSize;
  @override
  AppDialogMetrics copyWith({
    double? desktopInset,
    double? maxWidth,
    double? mobileTitleLine,
    double? desktopTitleLine,
    double? desktopTitleSize,
  }) => AppDialogMetrics(
    desktopInset: desktopInset ?? this.desktopInset,
    maxWidth: maxWidth ?? this.maxWidth,
    mobileTitleLine: mobileTitleLine ?? this.mobileTitleLine,
    desktopTitleLine: desktopTitleLine ?? this.desktopTitleLine,
    desktopTitleSize: desktopTitleSize ?? this.desktopTitleSize,
  );
  @override
  AppDialogMetrics lerp(
    covariant AppDialogMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppDialogMetrics(
      desktopInset:
          desktopInset +
          (other.desktopInset - desktopInset) * interpolationAmount,
      maxWidth: maxWidth + (other.maxWidth - maxWidth) * interpolationAmount,
      mobileTitleLine:
          mobileTitleLine +
          (other.mobileTitleLine - mobileTitleLine) * interpolationAmount,
      desktopTitleLine:
          desktopTitleLine +
          (other.desktopTitleLine - desktopTitleLine) * interpolationAmount,
      desktopTitleSize:
          desktopTitleSize +
          (other.desktopTitleSize - desktopTitleSize) * interpolationAmount,
    );
  }
}
