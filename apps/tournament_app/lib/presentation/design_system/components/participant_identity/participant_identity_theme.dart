import 'dart:ui';

import 'package:flutter/material.dart';

class ParticipantIdentityTheme
    extends ThemeExtension<ParticipantIdentityTheme> {
  const ParticipantIdentityTheme({
    required this.compactGap,
    required this.standardGap,
    required this.prominentGap,
  });

  final double compactGap;
  final double standardGap;
  final double prominentGap;

  @override
  ParticipantIdentityTheme copyWith({
    double? compactGap,
    double? standardGap,
    double? prominentGap,
  }) => ParticipantIdentityTheme(
    compactGap: compactGap ?? this.compactGap,
    standardGap: standardGap ?? this.standardGap,
    prominentGap: prominentGap ?? this.prominentGap,
  );

  @override
  ParticipantIdentityTheme lerp(
    covariant ParticipantIdentityTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return ParticipantIdentityTheme(
      compactGap: lerpDouble(compactGap, other.compactGap, t)!,
      standardGap: lerpDouble(standardGap, other.standardGap, t)!,
      prominentGap: lerpDouble(prominentGap, other.prominentGap, t)!,
    );
  }
}
