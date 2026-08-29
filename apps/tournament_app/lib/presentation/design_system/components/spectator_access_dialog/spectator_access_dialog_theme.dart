import 'package:flutter/material.dart';

class SpectatorAccessDialogTheme
    extends ThemeExtension<SpectatorAccessDialogTheme> {
  const SpectatorAccessDialogTheme({
    required this.background,
    required this.maxContentWidth,
    required this.gap,
  });

  final Color background;
  final double maxContentWidth;
  final double gap;

  @override
  SpectatorAccessDialogTheme copyWith({
    Color? background,
    double? maxContentWidth,
    double? gap,
  }) => SpectatorAccessDialogTheme(
    background: background ?? this.background,
    maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    gap: gap ?? this.gap,
  );

  @override
  SpectatorAccessDialogTheme lerp(
    covariant SpectatorAccessDialogTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return SpectatorAccessDialogTheme(
      background: Color.lerp(background, other.background, t)!,
      maxContentWidth:
          maxContentWidth + (other.maxContentWidth - maxContentWidth) * t,
      gap: gap + (other.gap - gap) * t,
    );
  }
}
