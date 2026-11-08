import 'package:tournament_app/presentation/design_system/foundation/primitives/screen_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/progress_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_progress_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/qr_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_qr_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/dialog_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_dialog_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/bracket_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_bracket_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/table_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_table_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/status_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_status_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/metric_component_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_metric_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/score_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_score_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/stepper_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_stepper_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/select_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/field_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/roster_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_roster_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/identity_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/control_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
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
  // CSS font-optical-sizing:auto. Inter opsz supports14..32; wght follows the
  // current TextTheme rather than a captured const style in a widget.
  static TextStyle _interfaceStyle(TextStyle style) => style.copyWith(
    fontVariations: [
      ...?style.fontVariations?.where(
        (axis) => axis.axis != 'opsz' && axis.axis != 'wght',
      ),
      FontVariation('opsz', (style.fontSize ?? 14).clamp(14, 32)),
      FontVariation('wght', (style.fontWeight?.value ?? 400).toDouble()),
    ],
  );

  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      scrim: ColorPrimitives.scrim,
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
        const AppScreenMetrics(
          modalSheetWidth: ScreenPrimitives.modalSheetWidth,
          modalViewportInset: ScreenPrimitives.modalViewportInset,
          modalMobileMinHeight: ScreenPrimitives.modalMobileMinHeight,
          rosterContextHeight: ScreenPrimitives.rosterContextHeight,
          widePaneFlex: ScreenPrimitives.widePaneFlex,
          narrowPaneFlex: ScreenPrimitives.narrowPaneFlex,
          gridColumns: ScreenPrimitives.gridColumns,
          stackColumns: ScreenPrimitives.stackColumns,
          historyFeatureHeight: ScreenPrimitives.historyFeatureHeight,
          historyCardHeight: ScreenPrimitives.historyCardHeight,
          historyProminentHeight: ScreenPrimitives.historyProminentHeight,
          aboutVersionHeight: ScreenPrimitives.aboutVersionHeight,
          aboutRulesHeight: ScreenPrimitives.aboutRulesHeight,
          aboutHeight: ScreenPrimitives.aboutHeight,
          settingsHeight: ScreenPrimitives.settingsHeight,
          secondaryHeroSize: ScreenPrimitives.secondaryHeroSize,
          simpleWidth: ScreenPrimitives.simpleWidth,
          simplePadding: ScreenPrimitives.simplePadding,
          simpleIntroFlex: ScreenPrimitives.simpleIntroFlex,
          simpleFormFlex: ScreenPrimitives.simpleFormFlex,
          profileLinkHeight: ScreenPrimitives.profileLinkHeight,
          profileNameSize: ScreenPrimitives.profileNameSize,
          homeMetaSize: ScreenPrimitives.homeMetaSize,
          homePrimaryFlex: ScreenPrimitives.homePrimaryFlex,
          homeSecondaryFlex: ScreenPrimitives.homeSecondaryFlex,
          homeTitleWidth: ScreenPrimitives.homeTitleWidth,
          homeActionHeight: ScreenPrimitives.homeActionHeight,
          bootTop: ScreenPrimitives.bootTop,
          bootBrandHeight: ScreenPrimitives.bootBrandHeight,
          bootCueHeight: ScreenPrimitives.bootCueHeight,
          bootFont: ScreenPrimitives.bootFont,
          bootGap: ScreenPrimitives.bootGap,
          start: CrossAxisAlignment.start,
          stretch: CrossAxisAlignment.stretch,
          centerCross: CrossAxisAlignment.center,
          centerMain: MainAxisAlignment.center,
          startMain: MainAxisAlignment.start,
          spaceBetween: MainAxisAlignment.spaceBetween,
          centerAlign: Alignment.center,
          bottomAlign: Alignment.bottomRight,
          rightAlign: Alignment.centerRight,
          topLeft: Alignment.topLeft,
          min: MainAxisSize.min,
          max: MainAxisSize.max,
          centerText: TextAlign.center,
          leftText: TextAlign.left,
          utilityWidth: ScreenPrimitives.utilityWidth,
          utilityHeight: ScreenPrimitives.utilityHeight,
          utilityTop: ScreenPrimitives.utilityTop,
          utilityReserve: ScreenPrimitives.utilityReserve,
          utilityAction: ScreenPrimitives.utilityAction,
          desktopHero: ScreenPrimitives.desktopHero,
          mobileHero: ScreenPrimitives.mobileHero,
          heroLine: ScreenPrimitives.heroLine,
          heroTracking: ScreenPrimitives.heroTracking,
          primaryFlex: ScreenPrimitives.primaryFlex,
          secondaryFlex: ScreenPrimitives.secondaryFlex,
          brandHeight: ScreenPrimitives.brandHeight,
          formWidth: ScreenPrimitives.formWidth,
        ),
        const AppProgressMetrics(
          height: ProgressPrimitives.height,
          width: ProgressPrimitives.width,
          strokeWidth: ProgressPrimitives.strokeWidth,
          trackStrokeWidth: ProgressPrimitives.trackStrokeWidth,
          wavelength: ProgressPrimitives.wavelength,
          waveSpeed: ProgressPrimitives.waveSpeed,
          staticValue: ProgressPrimitives.staticValue,
        ),
        const FoundationSampleMetrics(
          barHeight: FoundationPrimitives.sampleBarHeight,
          barRadius: FoundationPrimitives.sampleBarRadius,
          shapeExtent: FoundationPrimitives.sampleShapeExtent,
          fontSize: FoundationPrimitives.sampleFontSize,
          center: FoundationPrimitives.sampleCenter,
        ),
        const AppTextMetrics(
          compactHeaderLine: TypographyPrimitives.compactHeaderLine,
          comfortableHeaderLine: TypographyPrimitives.comfortableHeaderLine,
        ),
        const AppQrMetrics(
          moduleRadius: QrPrimitives.moduleRadius,
          finderOuterRadius: QrPrimitives.finderOuterRadius,
          finderGapRadius: QrPrimitives.finderGapRadius,
          finderCenterRadius: QrPrimitives.finderCenterRadius,
          quietZone: QrPrimitives.quietZone,

          mobileExtent: QrPrimitives.mobileExtent,
          desktopExtent: QrPrimitives.desktopExtent,
          aspectRatio: QrPrimitives.aspectRatio,
          codeLine: QrPrimitives.codeLine,
          codeFit: QrPrimitives.codeFit,
          blendMode: QrPrimitives.blendMode,
        ),
        const AppDialogMetrics(
          desktopInset: DialogPrimitives.desktopInset,
          maxWidth: DialogPrimitives.maxWidth,
          mobileTitleLine: DialogPrimitives.mobileTitleLine,
          desktopTitleLine: DialogPrimitives.desktopTitleLine,
          desktopTitleSize: DialogPrimitives.desktopTitleSize,
        ),
        const AppBracketMetrics(
          width: BracketPrimitives.width,
          minHeight: BracketPrimitives.minHeight,
          labelSize: BracketPrimitives.labelSize,
          smallSize: BracketPrimitives.smallSize,
          unknownSize: BracketPrimitives.unknownSize,
        ),
        const AppTableMetrics(
          trailing: TablePrimitives.trailing,
          verticalAlignment: TablePrimitives.verticalAlignment,
        ),
        const AppStatusMetrics(
          inlineHeightBehavior: StatusPrimitives.inlineHeightBehavior,
        ),
        const AppMetricMetrics(
          desktopAchievementSize:
              MetricComponentPrimitives.desktopAchievementSize,
          achievementLine: MetricComponentPrimitives.achievementLine,
          achievementMinHeight: MetricComponentPrimitives.achievementMinHeight,
          plainMinHeight: MetricComponentPrimitives.plainMinHeight,
          labelCharacters: MetricComponentPrimitives.labelCharacters,
          iconOpacity: MetricComponentPrimitives.iconOpacity,
          centerText: MetricComponentPrimitives.centerText,
        ),
        const AppScoreMetrics(
          desktopSize: ScorePrimitives.desktopSize,
          lineHeight: ScorePrimitives.lineHeight,
        ),
        const AppStepperMetrics(
          labelStackWidth: StepperPrimitives.labelStackWidth,
          disabledOpacity: StepperPrimitives.disabledOpacity,
          valueAlignment: StepperPrimitives.valueAlignment,
          center: StepperPrimitives.center,
          numericFeatures: StepperPrimitives.numericFeatures,
        ),
        const AppSelectMetrics(
          chevronTurns: SelectPrimitives.chevronTurns,
          sheetMaxWidth: SelectPrimitives.sheetMaxWidth,
          closeExtent: SelectPrimitives.closeExtent,
          handleWidth: SelectPrimitives.handleWidth,
          handleHeight: SelectPrimitives.handleHeight,
          sheetBottom: SelectPrimitives.sheetBottom,
          sheetTitleSize: SelectPrimitives.sheetTitleSize,
          sheetTitleLine: SelectPrimitives.sheetTitleLine,
          desktopLine: SelectPrimitives.desktopLine,
          optionWeight: SelectPrimitives.optionWeight,
          selectedWeight: SelectPrimitives.selectedWeight,
        ),
        const AppFieldMetrics(
          mobileMessageHeight: FieldPrimitives.mobileMessageHeight,
          desktopMessageHeight: FieldPrimitives.desktopMessageHeight,
          singleLine: FieldPrimitives.singleLine,
          centerLeft: FieldPrimitives.centerLeft,
          stretch: FieldPrimitives.stretch,
          start: FieldPrimitives.start,
        ),
        const AppRosterMetrics(
          cardHeight: RosterPrimitives.cardHeight,
          swipeThreshold: RosterPrimitives.swipeThreshold,
        ),
        const AppIdentityMetrics(
          leading: IdentityPrimitives.leading,
          stretch: IdentityPrimitives.stretch,
          start: IdentityPrimitives.start,
          textLeading: IdentityPrimitives.textLeading,
          participantLine: IdentityPrimitives.participantLine,
          cardNameSize: IdentityPrimitives.cardNameSize,
          cardAvatarFont: IdentityPrimitives.cardAvatarFont,
          cardAvatarRadius: IdentityPrimitives.cardAvatarRadius,
          stackedLine: IdentityPrimitives.stackedLine,
          containerFactor: IdentityPrimitives.containerFactor,
        ),
        const AppControlMetrics(
          half: ControlPrimitives.half,
          regularWeight: ControlPrimitives.regularWeight,
          regularVariations: ControlPrimitives.regularVariations,
          regularLine: ControlPrimitives.regularLine,
          spaceBetween: ControlPrimitives.spaceBetween,
          center: ControlPrimitives.center,
          centerCross: ControlPrimitives.centerCross,
          topLeft: ControlPrimitives.topLeft,
          zero: ControlPrimitives.zero,
          transparent: ControlPrimitives.transparent,
          removeWidth: ControlPrimitives.removeWidth,
          removeHeight: ControlPrimitives.removeHeight,
          removeIconExtent: ControlPrimitives.removeIconExtent,
        ),
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
        AppTypeRoles(
          interfaceStyle: _interfaceStyle,
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
