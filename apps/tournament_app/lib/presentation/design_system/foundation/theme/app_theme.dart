import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph_metrics.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/foundation_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_motion.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_status_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/color_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/color_roles_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/typography_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/metric_primitives.dart';

/// Единственная сборка primitive const в runtime Flutter ThemeData.
abstract final class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: ColorRolesPrimitives.accent,
      onPrimary: ColorRolesPrimitives.onAccent,
      primaryContainer: ColorRolesPrimitives.accentContainer,
      onPrimaryContainer: ColorRolesPrimitives.onAccentContainer,
      secondary: ColorRolesPrimitives.information,
      onSecondary: ColorRolesPrimitives.background,
      secondaryContainer: ColorRolesPrimitives.informationContainer,
      onSecondaryContainer: ColorRolesPrimitives.onInformationContainer,
      surface: ColorRolesPrimitives.surface,
      surfaceContainerHigh: ColorRolesPrimitives.surfaceRaised,
      onSurface: ColorRolesPrimitives.textPrimary,
      onSurfaceVariant: ColorRolesPrimitives.textSecondary,
      error: ColorRolesPrimitives.danger,
      onError: ColorRolesPrimitives.background,
      errorContainer: ColorRolesPrimitives.dangerContainer,
      onErrorContainer: ColorRolesPrimitives.onDangerContainer,
      outline: ColorRolesPrimitives.borderStrong,
      outlineVariant: ColorRolesPrimitives.border,
    );
    final text = const TextTheme(
      displayLarge: TypographyPrimitives.display,
      displayMedium: TypographyPrimitives.display,
      displaySmall: TypographyPrimitives.heading,
      headlineLarge: TypographyPrimitives.heading,
      headlineMedium: TypographyPrimitives.heading,
      headlineSmall: TypographyPrimitives.title,
      titleLarge: TypographyPrimitives.title,
      titleMedium: TypographyPrimitives.bodyLarge,
      titleSmall: TypographyPrimitives.label,
      bodyLarge: TypographyPrimitives.bodyLarge,
      bodyMedium: TypographyPrimitives.body,
      bodySmall: TypographyPrimitives.caption,
      labelLarge: TypographyPrimitives.label,
      labelMedium: TypographyPrimitives.label,
      labelSmall: TypographyPrimitives.caption,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: ColorRolesPrimitives.background,
      disabledColor: ColorRolesPrimitives.disabledContent,
      hoverColor: ColorRolesPrimitives.accentHovered,
      highlightColor: ColorRolesPrimitives.accentPressed,
      focusColor: ColorRolesPrimitives.focus,
      fontFamily: TypographyPrimitives.interfaceFamily,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        // SDK still defaults to the older M3 appearance; opt into current M3.
        // ignore: deprecated_member_use
        year2023: false,
      ),
      extensions: [
        const AppGlyphMetrics(
          stroke: MetricPrimitives.glyphStroke,
          grid: MetricPrimitives.glyphGrid,
        ),
        const AppAvatarMetrics(
          contentAlignment: FoundationPrimitives.avatarContentAlignment,
          leadingDistribution: FoundationPrimitives.avatarLeadingDistribution,
          avatarFont28: MetricPrimitives.avatarFont28,
          avatarFont40: MetricPrimitives.avatarFont40,
          avatarFont48: MetricPrimitives.avatarFont48,
          avatarFont64: MetricPrimitives.avatarFont64,
          avatarFont96: MetricPrimitives.avatarFont96,
          avatarFont112: MetricPrimitives.avatarFont112,
          avatarFont128: MetricPrimitives.avatarFont128,
          avatarRadius28: MetricPrimitives.avatarRadius28,
          avatarRadius40: MetricPrimitives.avatarRadius40,
          avatarRadius48: MetricPrimitives.avatarRadius48,
          avatarRadius64: MetricPrimitives.avatarRadius64,
          avatarRadius96: MetricPrimitives.avatarRadius96,
          avatarRadius112: MetricPrimitives.avatarRadius112,
          avatarRadius128: MetricPrimitives.avatarRadius128,
          avatarLineHeight: MetricPrimitives.avatarLineHeight,
          avatarTracking: MetricPrimitives.avatarTracking,
        ),
        const AppSpacing(
          space0: MetricPrimitives.spacingSpace0,
          space4: MetricPrimitives.spacingSpace4,
          space8: MetricPrimitives.spacingSpace8,
          space12: MetricPrimitives.spacingSpace12,
          space16: MetricPrimitives.spacingSpace16,
          space20: MetricPrimitives.spacingSpace20,
          space24: MetricPrimitives.spacingSpace24,
          space28: MetricPrimitives.spacingSpace28,
          space32: MetricPrimitives.spacingSpace32,
          space48: MetricPrimitives.spacingSpace48,
          space64: MetricPrimitives.spacingSpace64,
        ),
        const AppBorderMetrics(
          hairline: MetricPrimitives.borderMetricsHairline,
          emphasis: MetricPrimitives.borderMetricsEmphasis,
          highContrastFocus: MetricPrimitives.borderMetricsHighContrastFocus,
          focusOffset: MetricPrimitives.borderMetricsFocusOffset,
        ),
        const AppResponsive(
          mobileToDesktopWidth: MetricPrimitives.responsiveMobileToDesktopWidth,
          compactDesktopWidth: MetricPrimitives.responsiveCompactDesktopWidth,
          wideCompositionWidth: MetricPrimitives.responsiveWideCompositionWidth,
          compactControlHeight: MetricPrimitives.responsiveCompactControlHeight,
          touchControlHeight: MetricPrimitives.responsiveTouchControlHeight,
          avatarExtraSmall: MetricPrimitives.responsiveAvatarExtraSmall,
          avatarSmall: MetricPrimitives.responsiveAvatarSmall,
          avatarMedium: MetricPrimitives.responsiveAvatarMedium,
          avatarLarge: MetricPrimitives.responsiveAvatarLarge,
          avatarProfile: MetricPrimitives.responsiveAvatarProfile,
          avatarPortrait: MetricPrimitives.responsiveAvatarPortrait,
          avatarHero: MetricPrimitives.responsiveAvatarHero,
        ),
        const AppIconMetrics(
          small: MetricPrimitives.iconMetricsSmall,
          medium: MetricPrimitives.iconMetricsMedium,
          standard: MetricPrimitives.iconMetricsStandard,
          large: MetricPrimitives.iconMetricsLarge,
          display: MetricPrimitives.iconMetricsDisplay,
          hero: MetricPrimitives.iconMetricsHero,
        ),
        const AppShape(
          control: FoundationPrimitives.shapeControl,
          nested: FoundationPrimitives.shapeNested,
          desktopSurface: FoundationPrimitives.shapeDesktopSurface,
          avatarTile: FoundationPrimitives.shapeAvatarTile,
          surface: FoundationPrimitives.shapeSurface,
          panel: FoundationPrimitives.shapePanel,
          pill: FoundationPrimitives.shapePill,
          sheet: FoundationPrimitives.shapeSheet,
        ),
        const AppMotion(
          reveal: FoundationPrimitives.motionReveal,
          reduced: FoundationPrimitives.motionReduced,
          curve: FoundationPrimitives.motionCurve,
        ),
        const AppElevation(
          floating: FoundationPrimitives.elevationFloating,
          sheet: FoundationPrimitives.elevationSheet,
          dialog: FoundationPrimitives.elevationDialog,
        ),
        const AppStatusColors(
          success: ColorRolesPrimitives.success,
          successContainer: ColorRolesPrimitives.successContainer,
          onSuccessContainer: ColorRolesPrimitives.onSuccessContainer,
          warning: ColorRolesPrimitives.warning,
          warningContainer: ColorRolesPrimitives.warningContainer,
          onWarningContainer: ColorRolesPrimitives.onWarningContainer,
          characterIce: ColorPrimitives.characterIce,
          characterFan: ColorPrimitives.characterFan,
          characterStorm: ColorPrimitives.characterStorm,
        ),
        const AppTypeRoles(
          normalTracking: TypographyPrimitives.normalTracking,
          score: TypographyPrimitives.score,
        ),
        const FoundationLayout(
          pagePadding: FoundationPrimitives.layoutPagePadding,
          tilePadding: FoundationPrimitives.layoutTilePadding,
          smallGap: FoundationPrimitives.layoutSmallGap,
          gap: FoundationPrimitives.layoutGap,
          sectionGap: FoundationPrimitives.layoutSectionGap,
          tileWidth: FoundationPrimitives.layoutTileWidth,
          colorTileHeight: FoundationPrimitives.layoutColorTileHeight,
          swatchSize: FoundationPrimitives.layoutSwatchSize,
          borderWidth: FoundationPrimitives.layoutBorderWidth,
          cornerRadius: FoundationPrimitives.layoutCornerRadius,
          swatchRadius: FoundationPrimitives.layoutSwatchRadius,
          fullWidth: FoundationPrimitives.layoutFullWidth,
          textAlignment: FoundationPrimitives.layoutTextAlignment,
          centered: FoundationPrimitives.layoutCentered,
        ),
      ],
    );
  }
}
