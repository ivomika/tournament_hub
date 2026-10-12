import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_typography.dart';

class AppFoundation {
  const AppFoundation.dark();

  final colors = const AppColors.dark();
  final layout = const FoundationLayout();

  ThemeData get materialTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: colors.background,
    fontFamily: AppTypography.interfaceFamily,
    colorScheme: ColorScheme.dark(
      primary: colors.accent,
      onPrimary: colors.onAccent,
      primaryContainer: colors.accentContainer,
      onPrimaryContainer: colors.onAccentContainer,
      secondary: colors.information,
      onSecondary: colors.background,
      secondaryContainer: colors.informationContainer,
      onSecondaryContainer: colors.onInformationContainer,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      error: colors.danger,
      onError: colors.background,
      errorContainer: colors.dangerContainer,
      onErrorContainer: colors.onDangerContainer,
      outline: colors.borderStrong,
      outlineVariant: colors.border,
      onSurfaceVariant: colors.textSecondary,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.display,
      headlineLarge: AppTypography.heading,
      titleLarge: AppTypography.title,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      labelLarge: AppTypography.label,
      bodySmall: AppTypography.caption,
    ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary),
  );
}
