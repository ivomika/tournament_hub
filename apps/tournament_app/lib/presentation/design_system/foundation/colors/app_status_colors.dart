import 'package:flutter/material.dart';

class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.characterIce,
    required this.characterFan,
    required this.characterStorm,
  });
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color characterIce;
  final Color characterFan;
  final Color characterStorm;
  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? characterIce,
    Color? characterFan,
    Color? characterStorm,
  }) => AppStatusColors(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    characterIce: characterIce ?? this.characterIce,
    characterFan: characterFan ?? this.characterFan,
    characterStorm: characterStorm ?? this.characterStorm,
  );
  @override
  AppStatusColors lerp(
    covariant AppStatusColors? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, interpolationAmount)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        interpolationAmount,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        interpolationAmount,
      )!,
      warning: Color.lerp(warning, other.warning, interpolationAmount)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        interpolationAmount,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        interpolationAmount,
      )!,
      characterIce: Color.lerp(
        characterIce,
        other.characterIce,
        interpolationAmount,
      )!,
      characterFan: Color.lerp(
        characterFan,
        other.characterFan,
        interpolationAmount,
      )!,
      characterStorm: Color.lerp(
        characterStorm,
        other.characterStorm,
        interpolationAmount,
      )!,
    );
  }
}
