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
        m = ThemeExtensions.require<AppIconMetrics>(Theme.of(context)),
        g = ThemeExtensions.require<AppGlyphMetrics>(Theme.of(context));
    return AppIconTheme(
      extent: switch (size) {
        AppIconSize.small => m.small,
        AppIconSize.medium => m.medium,
        AppIconSize.standard => m.standard,
        AppIconSize.large => m.large,
        AppIconSize.display => m.display,
        AppIconSize.hero => m.hero,
      },
      color: switch (tone) {
        AppIconTone.primary => theme.colorScheme.onSurface,
        AppIconTone.secondary => theme.colorScheme.onSurfaceVariant,
        AppIconTone.onAccent => theme.colorScheme.onPrimary,
        AppIconTone.error => theme.colorScheme.error,
      },
      stroke: g.stroke,
      grid: g.grid,
    );
  }
  final double extent, stroke, grid;
  final Color color;
}
