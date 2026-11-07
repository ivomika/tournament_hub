import 'package:flutter/material.dart';

class AppMetricMetrics extends ThemeExtension<AppMetricMetrics> {
  const AppMetricMetrics({
    required this.desktopAchievementSize,
    required this.achievementLine,
    required this.achievementMinHeight,
    required this.plainMinHeight,
    required this.labelCharacters,
    required this.iconOpacity,
    required this.centerText,
  });
  final double desktopAchievementSize;
  final double achievementLine;
  final double achievementMinHeight;
  final double plainMinHeight;
  final double labelCharacters;
  final double iconOpacity;
  final TextAlign centerText;
  @override
  AppMetricMetrics copyWith({
    double? desktopAchievementSize,
    double? achievementLine,
    double? achievementMinHeight,
    double? plainMinHeight,
    double? labelCharacters,
    double? iconOpacity,
    TextAlign? centerText,
  }) => AppMetricMetrics(
    desktopAchievementSize:
        desktopAchievementSize ?? this.desktopAchievementSize,
    achievementLine: achievementLine ?? this.achievementLine,
    achievementMinHeight: achievementMinHeight ?? this.achievementMinHeight,
    plainMinHeight: plainMinHeight ?? this.plainMinHeight,
    labelCharacters: labelCharacters ?? this.labelCharacters,
    iconOpacity: iconOpacity ?? this.iconOpacity,
    centerText: centerText ?? this.centerText,
  );
  @override
  AppMetricMetrics lerp(covariant AppMetricMetrics? other, double t) =>
      other == null
      ? this
      : AppMetricMetrics(
          desktopAchievementSize:
              desktopAchievementSize +
              (other.desktopAchievementSize - desktopAchievementSize) * t,
          achievementLine:
              achievementLine + (other.achievementLine - achievementLine) * t,
          achievementMinHeight:
              achievementMinHeight +
              (other.achievementMinHeight - achievementMinHeight) * t,
          plainMinHeight:
              plainMinHeight + (other.plainMinHeight - plainMinHeight) * t,
          labelCharacters:
              labelCharacters + (other.labelCharacters - labelCharacters) * t,
          iconOpacity: iconOpacity + (other.iconOpacity - iconOpacity) * t,
          centerText: t < .5 ? centerText : other.centerText,
        );
}
