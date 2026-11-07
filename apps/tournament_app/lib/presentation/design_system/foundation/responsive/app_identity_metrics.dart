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
  AppIdentityMetrics lerp(covariant AppIdentityMetrics? other, double t) =>
      other == null
      ? this
      : AppIdentityMetrics(
          leading: t < 0.5 ? leading : other.leading,
          stretch: t < 0.5 ? stretch : other.stretch,
          start: t < 0.5 ? start : other.start,
          textLeading: t < 0.5 ? textLeading : other.textLeading,
          participantLine:
              participantLine + (other.participantLine - participantLine) * t,
          cardNameSize: cardNameSize + (other.cardNameSize - cardNameSize) * t,
          cardAvatarFont:
              cardAvatarFont + (other.cardAvatarFont - cardAvatarFont) * t,
          cardAvatarRadius:
              cardAvatarRadius +
              (other.cardAvatarRadius - cardAvatarRadius) * t,
          stackedLine: stackedLine + (other.stackedLine - stackedLine) * t,
          containerFactor:
              containerFactor + (other.containerFactor - containerFactor) * t,
        );
}
