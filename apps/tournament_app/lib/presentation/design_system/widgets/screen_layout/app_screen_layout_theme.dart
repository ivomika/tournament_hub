import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';

class AppScreenLayoutTheme {
  AppScreenLayoutTheme.of(BuildContext context) {
    final theme = Theme.of(context),
        runtimeSpacing = theme.extension<AppSpacing>()!,
        runtimeResponsive = theme.extension<AppResponsive>()!,
        runtimeScreenMetrics = theme.extension<AppScreenMetrics>()!;
    start = runtimeScreenMetrics.start;
    stretch = runtimeScreenMetrics.stretch;
    centerCross = runtimeScreenMetrics.centerCross;
    centerMain = runtimeScreenMetrics.centerMain;
    startMain = runtimeScreenMetrics.startMain;
    spaceBetween = runtimeScreenMetrics.spaceBetween;
    centerAlign = runtimeScreenMetrics.centerAlign;
    rightAlign = runtimeScreenMetrics.rightAlign;
    topLeft = runtimeScreenMetrics.topLeft;
    min = runtimeScreenMetrics.min;
    max = runtimeScreenMetrics.max;
    centerText = runtimeScreenMetrics.centerText;
    leftText = runtimeScreenMetrics.leftText;
    fullWidth = theme.extension<FoundationLayout>()!.fullWidth;
    bottomAlign = runtimeScreenMetrics.bottomAlign;
    homeTitleWidth = runtimeScreenMetrics.homeTitleWidth;
    homeActionHeight = runtimeScreenMetrics.homeActionHeight;
    homeMetaSize = runtimeScreenMetrics.homeMetaSize;
    homePrimaryFlex = runtimeScreenMetrics.homePrimaryFlex;
    homeSecondaryFlex = runtimeScreenMetrics.homeSecondaryFlex;
    profileLinkHeight = runtimeScreenMetrics.profileLinkHeight;
    profileNameSize = runtimeScreenMetrics.profileNameSize;
    simpleWidth = runtimeScreenMetrics.simpleWidth;
    simplePadding = runtimeScreenMetrics.simplePadding;
    simpleIntroFlex = runtimeScreenMetrics.simpleIntroFlex;
    simpleFormFlex = runtimeScreenMetrics.simpleFormFlex;
    settingsHeight = runtimeScreenMetrics.settingsHeight;
    secondaryHeroSize = runtimeScreenMetrics.secondaryHeroSize;
    aboutHeight = runtimeScreenMetrics.aboutHeight;
    aboutVersionHeight = runtimeScreenMetrics.aboutVersionHeight;
    aboutRulesHeight = runtimeScreenMetrics.aboutRulesHeight;
    gridColumns = runtimeScreenMetrics.gridColumns;
    stackColumns = runtimeScreenMetrics.stackColumns;
    historyFeatureHeight = runtimeScreenMetrics.historyFeatureHeight;
    historyCardHeight = runtimeScreenMetrics.historyCardHeight;
    historyProminentHeight = runtimeScreenMetrics.historyProminentHeight;
    widePaneFlex = runtimeScreenMetrics.widePaneFlex;
    narrowPaneFlex = runtimeScreenMetrics.narrowPaneFlex;
    rosterContextHeight = runtimeScreenMetrics.rosterContextHeight;
    modalSheetWidth = runtimeScreenMetrics.modalSheetWidth;
    modalViewportInset = runtimeScreenMetrics.modalViewportInset;
    modalMobileMinHeight = runtimeScreenMetrics.modalMobileMinHeight;
    matchDesktopNameSize = runtimeScreenMetrics.matchDesktopNameSize;
    matchMobileNameFactor = runtimeScreenMetrics.matchMobileNameFactor;
    matchDesktopAvatar = runtimeScreenMetrics.matchDesktopAvatar;
    matchMobileAvatar = runtimeScreenMetrics.matchMobileAvatar;
    bracketGrid = runtimeScreenMetrics.bracketGrid;
    bracketDot = runtimeScreenMetrics.bracketDot;
    bracketStroke = runtimeScreenMetrics.bracketStroke;
    bracketScaleMin = runtimeScreenMetrics.bracketScaleMin;
    bracketScaleMax = runtimeScreenMetrics.bracketScaleMax;
    bracketScaleStep = runtimeScreenMetrics.bracketScaleStep;
    bracketNodeHalf = runtimeScreenMetrics.bracketNodeHalf;
    bracketNodeHalfHeight = runtimeScreenMetrics.bracketNodeHalfHeight;
    resultDesktopAvatar = runtimeScreenMetrics.resultDesktopAvatar;
    resultContentWidth = runtimeScreenMetrics.resultContentWidth;
    resultOutcomeFactor = runtimeScreenMetrics.resultOutcomeFactor;
    championDesktopAvatar = runtimeScreenMetrics.championDesktopAvatar;
    championMobileAvatar = runtimeScreenMetrics.championMobileAvatar;
    championDesktopNameSize = runtimeScreenMetrics.championDesktopNameSize;
    championMobileNameSize = runtimeScreenMetrics.championMobileNameSize;
    championHeight = runtimeScreenMetrics.championHeight;
    championContextTitleSize = runtimeScreenMetrics.championContextTitleSize;
    rankFeaturedHeight = runtimeScreenMetrics.rankFeaturedHeight;
    rankRegularHeight = runtimeScreenMetrics.rankRegularHeight;
    rankFeaturedName = runtimeScreenMetrics.rankFeaturedName;
    rankFeaturedValue = runtimeScreenMetrics.rankFeaturedValue;
    resultsContextTitleSize = runtimeScreenMetrics.resultsContextTitleSize;
    screenBrandSize = runtimeScreenMetrics.screenBrandSize;
    screenBrandLine = runtimeScreenMetrics.screenBrandLine;
    screenBrandTracking = runtimeScreenMetrics.screenBrandTracking;
    desktopContentMinHeight = runtimeScreenMetrics.desktopContentMinHeight;
    desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    inset = EdgeInsets.all(
      desktop ? runtimeSpacing.space32 : runtimeSpacing.space24,
    );
    brandInset = EdgeInsets.symmetric(horizontal: runtimeSpacing.space32);
    tileInset = EdgeInsets.all(
      desktop ? runtimeSpacing.space24 : runtimeSpacing.space0,
    );
    gap = desktop ? runtimeSpacing.space20 : runtimeSpacing.space24;
    small = runtimeSpacing.space16;
    zero = runtimeSpacing.space0;
    background = theme.scaffoldBackgroundColor;
    surface = theme.colorScheme.surface;
    raised = theme.colorScheme.surfaceContainerHigh;
    radius = theme.extension<AppShape>()!.surface;
    hero = theme.textTheme.displayLarge!.copyWith(
      fontSize: desktop
          ? runtimeScreenMetrics.desktopHero
          : runtimeScreenMetrics.mobileHero,
      height: runtimeScreenMetrics.heroLine,
      letterSpacing:
          (desktop
              ? runtimeScreenMetrics.desktopHero
              : runtimeScreenMetrics.mobileHero) *
          runtimeScreenMetrics.heroTracking,
    );
    accentHero = hero.copyWith(color: theme.colorScheme.primary);
    heading = theme.textTheme.headlineLarge!;
    title = theme.textTheme.titleLarge!;
    body = theme.textTheme.bodyMedium!;
    muted = body.copyWith(color: theme.colorScheme.onSurfaceVariant);
    caption = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    textScaleFactor =
        MediaQuery.textScalerOf(context)
            .scale(theme.textTheme.bodyMedium!.fontSize!) /
        theme.textTheme.bodyMedium!.fontSize!;
    scaledDesktopContentMinHeight =
        runtimeScreenMetrics.desktopContentMinHeight * textScaleFactor;
    brand = theme.textTheme.headlineLarge!.copyWith(
      fontSize: runtimeScreenMetrics.screenBrandSize,
      height: runtimeScreenMetrics.screenBrandLine,
      letterSpacing:
          runtimeScreenMetrics.screenBrandSize *
          runtimeScreenMetrics.screenBrandTracking,
    );
    brandBorder = Border(
      bottom: BorderSide(
        color: theme.colorScheme.outline,
        width: theme.extension<AppBorderMetrics>()!.hairline,
      ),
    );
    accentBrand = brand.copyWith(color: theme.colorScheme.primary);
    utilityWidth = runtimeScreenMetrics.utilityWidth;
    utilityHeight = runtimeScreenMetrics.utilityHeight;
    utilityTop = runtimeScreenMetrics.utilityTop;
    utilityReserve = runtimeScreenMetrics.utilityReserve;
    utilityAction = runtimeScreenMetrics.utilityAction;
    primaryFlex = runtimeScreenMetrics.primaryFlex;
    secondaryFlex = runtimeScreenMetrics.secondaryFlex;
    brandHeight = runtimeScreenMetrics.brandHeight;
    formWidth = runtimeScreenMetrics.formWidth;
  }
  late final double scaledDesktopContentMinHeight, textScaleFactor;
  late final Border brandBorder;
  late final CrossAxisAlignment start;
  late final CrossAxisAlignment stretch;
  late final CrossAxisAlignment centerCross;
  late final MainAxisAlignment centerMain;
  late final MainAxisAlignment startMain;
  late final MainAxisAlignment spaceBetween;
  late final Alignment centerAlign;
  late final Alignment rightAlign;
  late final Alignment topLeft;
  late final MainAxisSize min;
  late final MainAxisSize max;
  late final TextAlign centerText;
  late final TextAlign leftText;
  late final Alignment bottomAlign;
  late final double fullWidth;
  late final double homeTitleWidth;
  late final double homeActionHeight;
  late final double homeMetaSize;
  late final int homePrimaryFlex;
  late final int homeSecondaryFlex;
  late final double profileLinkHeight;
  late final double profileNameSize;
  late final double simpleWidth;
  late final double simplePadding;
  late final int simpleIntroFlex;
  late final int simpleFormFlex;
  late final double settingsHeight;
  late final double secondaryHeroSize;
  late final double aboutHeight;
  late final double aboutVersionHeight;
  late final double aboutRulesHeight;
  late final int gridColumns;
  late final int stackColumns;
  late final double historyFeatureHeight;
  late final double historyCardHeight;
  late final double historyProminentHeight;
  late final int widePaneFlex;
  late final int narrowPaneFlex;
  late final double rosterContextHeight;
  late final double modalSheetWidth;
  late final double modalViewportInset;
  late final double modalMobileMinHeight;
  late final double matchDesktopNameSize;
  late final double matchMobileNameFactor;
  late final double matchDesktopAvatar;
  late final double matchMobileAvatar;
  late final double bracketGrid;
  late final double bracketDot;
  late final double bracketStroke;
  late final double bracketScaleMin;
  late final double bracketScaleMax;
  late final double bracketScaleStep;
  late final double bracketNodeHalf;
  late final double bracketNodeHalfHeight;
  late final double resultDesktopAvatar;
  late final double resultContentWidth;
  late final double resultOutcomeFactor;
  late final double championDesktopAvatar;
  late final double championMobileAvatar;
  late final double championDesktopNameSize;
  late final double championMobileNameSize;
  late final double championHeight;
  late final double championContextTitleSize;
  late final double rankFeaturedHeight;
  late final double rankRegularHeight;
  late final double rankFeaturedName;
  late final double rankFeaturedValue;
  late final double resultsContextTitleSize;
  late final double screenBrandSize;
  late final double screenBrandLine;
  late final double screenBrandTracking;
  late final double desktopContentMinHeight;
  late final bool desktop;
  late final EdgeInsets inset, tileInset, brandInset;
  late final double utilityWidth,
      utilityHeight,
      utilityTop,
      utilityReserve,
      utilityAction,
      gap,
      small,
      zero,
      brandHeight,
      formWidth;
  late final Color background, surface, raised;
  late final BorderRadius radius;
  late final TextStyle hero,
      accentHero,
      heading,
      title,
      body,
      muted,
      caption,
      brand,
      accentBrand;
  late final int primaryFlex, secondaryFlex;
}
