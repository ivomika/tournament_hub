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
  AppMetricMetrics lerp(
    covariant AppMetricMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppMetricMetrics(
      desktopAchievementSize:
          desktopAchievementSize +
          (other.desktopAchievementSize - desktopAchievementSize) *
              interpolationAmount,
      achievementLine:
          achievementLine +
          (other.achievementLine - achievementLine) * interpolationAmount,
      achievementMinHeight:
          achievementMinHeight +
          (other.achievementMinHeight - achievementMinHeight) *
              interpolationAmount,
      plainMinHeight:
          plainMinHeight +
          (other.plainMinHeight - plainMinHeight) * interpolationAmount,
      labelCharacters:
          labelCharacters +
          (other.labelCharacters - labelCharacters) * interpolationAmount,
      iconOpacity:
          iconOpacity + (other.iconOpacity - iconOpacity) * interpolationAmount,
      centerText: interpolationAmount < .5 ? centerText : other.centerText,
    );
  }
}
