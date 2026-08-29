import 'package:flutter/material.dart';

class ParticipantInviteCardTheme
    extends ThemeExtension<ParticipantInviteCardTheme> {
  const ParticipantInviteCardTheme({
    required this.background,
    required this.border,
    required this.accent,
    required this.warning,
    required this.danger,
    required this.radius,
    required this.padding,
    required this.gap,
    required this.compactGap,
    required this.compactBreakpoint,
    required this.codeStyle,
  });

  final Color background;
  final Color border;
  final Color accent;
  final Color warning;
  final Color danger;
  final double radius;
  final double padding;
  final double gap;
  final double compactGap;
  final double compactBreakpoint;
  final TextStyle codeStyle;

  @override
  ParticipantInviteCardTheme copyWith({
    Color? background,
    Color? border,
    Color? accent,
    Color? warning,
    Color? danger,
    double? radius,
    double? padding,
    double? gap,
    double? compactGap,
    double? compactBreakpoint,
    TextStyle? codeStyle,
  }) => ParticipantInviteCardTheme(
    background: background ?? this.background,
    border: border ?? this.border,
    accent: accent ?? this.accent,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    compactGap: compactGap ?? this.compactGap,
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    codeStyle: codeStyle ?? this.codeStyle,
  );

  @override
  ParticipantInviteCardTheme lerp(
    covariant ParticipantInviteCardTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return ParticipantInviteCardTheme(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      radius: radius + (other.radius - radius) * t,
      padding: padding + (other.padding - padding) * t,
      gap: gap + (other.gap - gap) * t,
      compactGap: compactGap + (other.compactGap - compactGap) * t,
      compactBreakpoint:
          compactBreakpoint + (other.compactBreakpoint - compactBreakpoint) * t,
      codeStyle: TextStyle.lerp(codeStyle, other.codeStyle, t)!,
    );
  }
}
