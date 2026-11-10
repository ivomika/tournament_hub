import 'package:flutter/material.dart';

class AppIdentityMetrics extends ThemeExtension<AppIdentityMetrics> {
  const AppIdentityMetrics({
    required this.leading,
    required this.stretch,
    required this.start,
    required this.textLeading,
    required this.participantLine,
    required this.cardNameSize,
    required this.cardAvatarFont,
    required this.cardAvatarRadius,
    required this.stackedLine,
    required this.containerFactor,
  });
  final CrossAxisAlignment leading;
  final CrossAxisAlignment stretch;
  final MainAxisAlignment start;
  final TextAlign textLeading;
  final double participantLine;
  final double cardNameSize;
  final double cardAvatarFont;
  final double cardAvatarRadius;
  final double stackedLine;
  final double containerFactor;
  @override
  AppIdentityMetrics copyWith({
    CrossAxisAlignment? leading,
    CrossAxisAlignment? stretch,
    MainAxisAlignment? start,
    TextAlign? textLeading,
    double? participantLine,
    double? cardNameSize,
    double? cardAvatarFont,
    double? cardAvatarRadius,
    double? stackedLine,
    double? containerFactor,
  }) => AppIdentityMetrics(
    leading: leading ?? this.leading,
    stretch: stretch ?? this.stretch,
    start: start ?? this.start,
    textLeading: textLeading ?? this.textLeading,
    participantLine: participantLine ?? this.participantLine,
    cardNameSize: cardNameSize ?? this.cardNameSize,
    cardAvatarFont: cardAvatarFont ?? this.cardAvatarFont,
    cardAvatarRadius: cardAvatarRadius ?? this.cardAvatarRadius,
    stackedLine: stackedLine ?? this.stackedLine,
    containerFactor: containerFactor ?? this.containerFactor,
  );
  @override
  AppIdentityMetrics lerp(
    covariant AppIdentityMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppIdentityMetrics(
      leading: interpolationAmount < 0.5 ? leading : other.leading,
      stretch: interpolationAmount < 0.5 ? stretch : other.stretch,
      start: interpolationAmount < 0.5 ? start : other.start,
      textLeading: interpolationAmount < 0.5 ? textLeading : other.textLeading,
      participantLine:
          participantLine +
          (other.participantLine - participantLine) * interpolationAmount,
      cardNameSize:
          cardNameSize +
          (other.cardNameSize - cardNameSize) * interpolationAmount,
      cardAvatarFont:
          cardAvatarFont +
          (other.cardAvatarFont - cardAvatarFont) * interpolationAmount,
      cardAvatarRadius:
          cardAvatarRadius +
          (other.cardAvatarRadius - cardAvatarRadius) * interpolationAmount,
      stackedLine:
          stackedLine + (other.stackedLine - stackedLine) * interpolationAmount,
      containerFactor:
          containerFactor +
          (other.containerFactor - containerFactor) * interpolationAmount,
    );
  }
}
