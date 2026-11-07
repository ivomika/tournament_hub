import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_status_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/require_theme_extension.dart';

class AppThemeColors {
  const AppThemeColors(this.theme);
  final ThemeData theme;
  Color get background => theme.scaffoldBackgroundColor;
  Color get surface => theme.colorScheme.surface;
  Color get surfaceRaised => theme.colorScheme.surfaceContainerHigh;
  Color get border => theme.colorScheme.outlineVariant;
  Color get borderStrong => theme.colorScheme.outline;
  Color get textPrimary => theme.colorScheme.onSurface;
  Color get textSecondary => theme.colorScheme.onSurfaceVariant;
  Color get textMuted => theme.disabledColor;
  Color get disabledSurface => theme.colorScheme.surfaceContainerHigh;
  Color get disabledContent => theme.disabledColor;
  Color get accent => theme.colorScheme.primary;
  Color get accentHovered => theme.hoverColor;
  Color get accentPressed => theme.highlightColor;
  Color get focus => theme.focusColor;
  Color get onAccent => theme.colorScheme.onPrimary;
  Color get accentContainer => theme.colorScheme.primaryContainer;
  Color get onAccentContainer => theme.colorScheme.onPrimaryContainer;
  Color get danger => theme.colorScheme.error;
  Color get dangerContainer => theme.colorScheme.errorContainer;
  Color get onDangerContainer => theme.colorScheme.onErrorContainer;
  Color get information => theme.colorScheme.secondary;
  Color get informationContainer => theme.colorScheme.secondaryContainer;
  Color get onInformationContainer => theme.colorScheme.onSecondaryContainer;
  Color get success => requireThemeExtension<AppStatusColors>(theme).success;
  Color get successContainer =>
      requireThemeExtension<AppStatusColors>(theme).successContainer;
  Color get onSuccessContainer =>
      requireThemeExtension<AppStatusColors>(theme).onSuccessContainer;
  Color get warning => requireThemeExtension<AppStatusColors>(theme).warning;
  Color get warningContainer =>
      requireThemeExtension<AppStatusColors>(theme).warningContainer;
  Color get onWarningContainer =>
      requireThemeExtension<AppStatusColors>(theme).onWarningContainer;
  Color get characterIce =>
      requireThemeExtension<AppStatusColors>(theme).characterIce;
  Color get characterFan =>
      requireThemeExtension<AppStatusColors>(theme).characterFan;
  Color get characterStorm =>
      requireThemeExtension<AppStatusColors>(theme).characterStorm;
}
