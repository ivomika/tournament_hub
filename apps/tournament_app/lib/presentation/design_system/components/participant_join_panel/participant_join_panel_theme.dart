import 'package:flutter/material.dart';

class ParticipantJoinPanelTheme
    extends ThemeExtension<ParticipantJoinPanelTheme> {
  const ParticipantJoinPanelTheme({
    required this.scannerBackground,
    required this.scannerBorder,
    required this.radius,
    required this.padding,
    required this.gap,
    required this.scannerHeight,
  });

  final Color scannerBackground;
  final Color scannerBorder;
  final double radius;
  final double padding;
  final double gap;
  final double scannerHeight;

  @override
  ParticipantJoinPanelTheme copyWith({
    Color? scannerBackground,
    Color? scannerBorder,
    double? radius,
    double? padding,
    double? gap,
    double? scannerHeight,
  }) => ParticipantJoinPanelTheme(
    scannerBackground: scannerBackground ?? this.scannerBackground,
    scannerBorder: scannerBorder ?? this.scannerBorder,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    scannerHeight: scannerHeight ?? this.scannerHeight,
  );

  @override
  ParticipantJoinPanelTheme lerp(
    covariant ParticipantJoinPanelTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return ParticipantJoinPanelTheme(
      scannerBackground: Color.lerp(
        scannerBackground,
        other.scannerBackground,
        t,
      )!,
      scannerBorder: Color.lerp(scannerBorder, other.scannerBorder, t)!,
      radius: radius + (other.radius - radius) * t,
      padding: padding + (other.padding - padding) * t,
      gap: gap + (other.gap - gap) * t,
      scannerHeight: scannerHeight + (other.scannerHeight - scannerHeight) * t,
    );
  }
}
