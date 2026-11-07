import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_theme_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/require_theme_extension.dart';

class TypographyCatalogTheme {
  const TypographyCatalogTheme(this.theme);
  factory TypographyCatalogTheme.of(BuildContext context) =>
      TypographyCatalogTheme(Theme.of(context));
  final ThemeData theme;
  AppThemeColors get colors => AppThemeColors(theme);
  FoundationLayout get layout => requireThemeExtension<FoundationLayout>(theme);
  TextStyle get heading => theme.textTheme.headlineLarge!;
  TextStyle get description => theme.textTheme.bodyMedium!.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
  TextStyle get label =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary);
  TextStyle get details => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
  TextStyle sampleStyle(TextStyle base) =>
      base.copyWith(color: theme.colorScheme.onSurface);
}
