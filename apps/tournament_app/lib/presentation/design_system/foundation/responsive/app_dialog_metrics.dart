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
  AppDialogMetrics lerp(covariant AppDialogMetrics? other, double t) =>
      other == null
      ? this
      : AppDialogMetrics(
          desktopInset: desktopInset + (other.desktopInset - desktopInset) * t,
          maxWidth: maxWidth + (other.maxWidth - maxWidth) * t,
          mobileTitleLine:
              mobileTitleLine + (other.mobileTitleLine - mobileTitleLine) * t,
          desktopTitleLine:
              desktopTitleLine +
              (other.desktopTitleLine - desktopTitleLine) * t,
          desktopTitleSize:
              desktopTitleSize +
              (other.desktopTitleSize - desktopTitleSize) * t,
        );
}
