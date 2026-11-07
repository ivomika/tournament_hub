import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_theme_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';

class PaletteTheme {
  const PaletteTheme(this.theme);
  factory PaletteTheme.of(BuildContext context) =>
      PaletteTheme(Theme.of(context));
  final ThemeData theme;
  AppThemeColors get colors => AppThemeColors(theme);
  FoundationLayout get layout =>
      ThemeExtensions.require<FoundationLayout>(theme);
  TextStyle get heading => theme.textTheme.headlineLarge!;
  TextStyle get description => theme.textTheme.bodyMedium!.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
  TextStyle get tokenLabel => theme.textTheme.labelLarge!;
  TextStyle get tokenValue => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
}
