import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';

enum AppIconSize { small, medium, standard, large, display, hero }

enum AppIconTone { primary, secondary, onAccent, error }

class AppIconTheme {
  const AppIconTheme({
    required this.extent,
    required this.color,
    required this.stroke,
    required this.grid,
  });
  factory AppIconTheme.of(
    BuildContext context,
    AppIconSize size,
    AppIconTone tone,
  ) {
    final theme = Theme.of(context),
        iconMetrics = ThemeExtensions.require<AppIconMetrics>(
          Theme.of(context),
        ),
        glyphMetrics = ThemeExtensions.require<AppGlyphMetrics>(
          Theme.of(context),
        );
    return AppIconTheme(
      extent: switch (size) {
        AppIconSize.small => iconMetrics.small,
        AppIconSize.medium => iconMetrics.medium,
        AppIconSize.standard => iconMetrics.standard,
        AppIconSize.large => iconMetrics.large,
        AppIconSize.display => iconMetrics.display,
        AppIconSize.hero => iconMetrics.hero,
      },
      color: switch (tone) {
        AppIconTone.primary => theme.colorScheme.onSurface,
        AppIconTone.secondary => theme.colorScheme.onSurfaceVariant,
        AppIconTone.onAccent => theme.colorScheme.onPrimary,
        AppIconTone.error => theme.colorScheme.error,
      },
      stroke: glyphMetrics.stroke,
      grid: glyphMetrics.grid,
    );
  }
  final double extent, stroke, grid;
  final Color color;
}
