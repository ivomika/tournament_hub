import 'package:flutter/material.dart';

import 'dart:ui' show lerpDouble;

class AppScreenMetrics extends ThemeExtension<AppScreenMetrics> {
  const AppScreenMetrics({
    required this.start,
    required this.stretch,
    required this.centerCross,
    required this.centerMain,
    required this.startMain,
    required this.spaceBetween,
    required this.centerAlign,
    required this.bottomAlign,
    required this.rightAlign,
    required this.topLeft,
    required this.min,
    required this.max,
    required this.centerText,
    required this.leftText,
    required this.bootTop,
    required this.bootBrandHeight,
    required this.bootCueHeight,
    required this.bootFont,
    required this.bootGap,
    required this.homeTitleWidth,
    required this.homeActionHeight,
    required this.homeMetaSize,
    required this.homePrimaryFlex,
    required this.homeSecondaryFlex,
    required this.profileLinkHeight,
    required this.profileNameSize,
    required this.simpleWidth,
    required this.simplePadding,
    required this.simpleIntroFlex,
    required this.simpleFormFlex,
    required this.settingsHeight,
    required this.secondaryHeroSize,
    required this.aboutHeight,
    required this.aboutVersionHeight,
    required this.aboutRulesHeight,
    required this.gridColumns,
    required this.stackColumns,
    required this.historyFeatureHeight,
    required this.historyCardHeight,
    required this.historyProminentHeight,
    required this.widePaneFlex,
    required this.narrowPaneFlex,
    required this.rosterContextHeight,
    required this.modalSheetWidth,
    required this.modalViewportInset,
    required this.modalMobileMinHeight,
    required this.matchDesktopNameSize,
    required this.matchMobileNameFactor,
    required this.matchDesktopAvatar,
    required this.matchMobileAvatar,
    required this.bracketGrid,
    required this.bracketDot,
    required this.bracketStroke,
    required this.bracketScaleMin,
    required this.bracketScaleMax,
    required this.bracketScaleStep,
    required this.bracketNodeHalf,
    required this.bracketNodeHalfHeight,
    required this.resultDesktopAvatar,
    required this.resultContentWidth,
    required this.resultOutcomeFactor,
    required this.championDesktopAvatar,
    required this.championMobileAvatar,
    required this.championDesktopNameSize,
    required this.championMobileNameSize,
    required this.championHeight,
    required this.championContextTitleSize,
    required this.rankFeaturedHeight,
    required this.rankRegularHeight,
    required this.rankFeaturedName,
    required this.rankFeaturedValue,
    required this.resultsContextTitleSize,
    required this.screenBrandSize,
    required this.screenBrandLine,
    required this.screenBrandTracking,
    required this.desktopContentMinHeight,
    required this.utilityWidth,
    required this.utilityHeight,
    required this.utilityTop,
    required this.utilityReserve,
    required this.utilityAction,
    required this.desktopHero,
    required this.mobileHero,
    required this.heroLine,
    required this.heroTracking,
    required this.primaryFlex,
    required this.secondaryFlex,
    required this.brandHeight,
    required this.formWidth,
  });
  final CrossAxisAlignment start;
  final CrossAxisAlignment stretch;
  final CrossAxisAlignment centerCross;
  final MainAxisAlignment centerMain;
  final MainAxisAlignment startMain;
  final MainAxisAlignment spaceBetween;
  final Alignment centerAlign;
  final Alignment bottomAlign;
  final Alignment rightAlign;
  final Alignment topLeft;
  final MainAxisSize min;
  final MainAxisSize max;
  final TextAlign centerText;
  final TextAlign leftText;
  final int gridColumns;
  final int stackColumns;
  final int widePaneFlex;
  final int narrowPaneFlex;
  final double desktopContentMinHeight;
  final double bracketGrid;
  final double bracketDot;
  final double bracketStroke;
  final double bracketScaleMin;
  final double bracketScaleMax;
  final double bracketScaleStep;
  final double bracketNodeHalf;
  final double bracketNodeHalfHeight;
  final double resultDesktopAvatar;
  final double resultContentWidth;
  final double resultOutcomeFactor;
  final double championDesktopAvatar;
  final double championMobileAvatar;
  final double championDesktopNameSize;
  final double championMobileNameSize;
  final double championHeight;
  final double championContextTitleSize;
  final double rankFeaturedHeight;
  final double rankRegularHeight;
  final double rankFeaturedName;
  final double rankFeaturedValue;
  final double resultsContextTitleSize;
  final double screenBrandSize;
  final double screenBrandLine;
  final double screenBrandTracking;
  final double matchDesktopNameSize;
  final double matchMobileNameFactor;
  final double matchDesktopAvatar;
  final double matchMobileAvatar;
  final double modalSheetWidth;
  final double modalViewportInset;
  final double modalMobileMinHeight;
  final double rosterContextHeight;
  final double historyFeatureHeight;
  final double historyCardHeight;
  final double historyProminentHeight;
  final double aboutVersionHeight;
  final double aboutRulesHeight;
  final double aboutHeight;
  final double settingsHeight;
  final double secondaryHeroSize;
  final double simpleWidth;
  final double simplePadding;
  final int simpleIntroFlex;
  final int simpleFormFlex;
  final double profileLinkHeight;
  final double profileNameSize;
  final double homeMetaSize;
  final int homePrimaryFlex;
  final int homeSecondaryFlex;
  final double homeTitleWidth;
  final double homeActionHeight;
  final double bootTop,
      bootBrandHeight,
      bootCueHeight,
      bootFont,
      bootGap,
      utilityWidth,
      utilityHeight,
      utilityTop,
      utilityReserve,
      utilityAction,
      desktopHero,
      mobileHero,
      heroLine,
      heroTracking,
      brandHeight,
      formWidth;
  final int primaryFlex, secondaryFlex;
  @override
  AppScreenMetrics copyWith({
    CrossAxisAlignment? start,
    CrossAxisAlignment? stretch,
    CrossAxisAlignment? centerCross,
    MainAxisAlignment? centerMain,
    MainAxisAlignment? startMain,
    MainAxisAlignment? spaceBetween,
    Alignment? centerAlign,
    Alignment? bottomAlign,
    Alignment? rightAlign,
    Alignment? topLeft,
    MainAxisSize? min,
    MainAxisSize? max,
    TextAlign? centerText,
    TextAlign? leftText,
    double? bootTop,
    double? bootBrandHeight,
    double? bootCueHeight,
    double? bootFont,
    double? bootGap,
    double? homeTitleWidth,
    double? homeActionHeight,
    double? homeMetaSize,
    int? homePrimaryFlex,
    int? homeSecondaryFlex,
    double? profileLinkHeight,
    double? profileNameSize,
    double? simpleWidth,
    double? simplePadding,
    int? simpleIntroFlex,
    int? simpleFormFlex,
    double? settingsHeight,
    double? secondaryHeroSize,
    double? aboutHeight,
    double? aboutVersionHeight,
    double? aboutRulesHeight,
    int? gridColumns,
    int? stackColumns,
    double? historyFeatureHeight,
    double? historyCardHeight,
    double? historyProminentHeight,
    int? widePaneFlex,
    int? narrowPaneFlex,
    double? rosterContextHeight,
    double? modalSheetWidth,
    double? modalViewportInset,
    double? modalMobileMinHeight,
    double? matchDesktopNameSize,
    double? matchMobileNameFactor,
    double? matchDesktopAvatar,
    double? matchMobileAvatar,
    double? bracketGrid,
    double? bracketDot,
    double? bracketStroke,
    double? bracketScaleMin,
    double? bracketScaleMax,
    double? bracketScaleStep,
    double? bracketNodeHalf,
    double? bracketNodeHalfHeight,
    double? resultDesktopAvatar,
    double? resultContentWidth,
    double? resultOutcomeFactor,
    double? championDesktopAvatar,
    double? championMobileAvatar,
    double? championDesktopNameSize,
    double? championMobileNameSize,
    double? championHeight,
    double? championContextTitleSize,
    double? rankFeaturedHeight,
    double? rankRegularHeight,
    double? rankFeaturedName,
    double? rankFeaturedValue,
    double? resultsContextTitleSize,
    double? screenBrandSize,
    double? screenBrandLine,
    double? screenBrandTracking,
    double? desktopContentMinHeight,
    double? utilityWidth,
    double? utilityHeight,
    double? utilityTop,
    double? utilityReserve,
    double? utilityAction,
    double? desktopHero,
    double? mobileHero,
    double? heroLine,
    double? heroTracking,
    int? primaryFlex,
    int? secondaryFlex,
    double? brandHeight,
    double? formWidth,
  }) => AppScreenMetrics(
    start: start ?? this.start,
    stretch: stretch ?? this.stretch,
    centerCross: centerCross ?? this.centerCross,
    centerMain: centerMain ?? this.centerMain,
    startMain: startMain ?? this.startMain,
    spaceBetween: spaceBetween ?? this.spaceBetween,
    centerAlign: centerAlign ?? this.centerAlign,
    bottomAlign: bottomAlign ?? this.bottomAlign,
    rightAlign: rightAlign ?? this.rightAlign,
    topLeft: topLeft ?? this.topLeft,
    min: min ?? this.min,
    max: max ?? this.max,
    centerText: centerText ?? this.centerText,
    leftText: leftText ?? this.leftText,
    bootTop: bootTop ?? this.bootTop,
    bootBrandHeight: bootBrandHeight ?? this.bootBrandHeight,
    bootCueHeight: bootCueHeight ?? this.bootCueHeight,
    bootFont: bootFont ?? this.bootFont,
    bootGap: bootGap ?? this.bootGap,
    homeTitleWidth: homeTitleWidth ?? this.homeTitleWidth,
    homeActionHeight: homeActionHeight ?? this.homeActionHeight,
    homeMetaSize: homeMetaSize ?? this.homeMetaSize,
    homePrimaryFlex: homePrimaryFlex ?? this.homePrimaryFlex,
    homeSecondaryFlex: homeSecondaryFlex ?? this.homeSecondaryFlex,
    profileLinkHeight: profileLinkHeight ?? this.profileLinkHeight,
    profileNameSize: profileNameSize ?? this.profileNameSize,
    simpleWidth: simpleWidth ?? this.simpleWidth,
    simplePadding: simplePadding ?? this.simplePadding,
    simpleIntroFlex: simpleIntroFlex ?? this.simpleIntroFlex,
    simpleFormFlex: simpleFormFlex ?? this.simpleFormFlex,
    settingsHeight: settingsHeight ?? this.settingsHeight,
    secondaryHeroSize: secondaryHeroSize ?? this.secondaryHeroSize,
    aboutHeight: aboutHeight ?? this.aboutHeight,
    aboutVersionHeight: aboutVersionHeight ?? this.aboutVersionHeight,
    aboutRulesHeight: aboutRulesHeight ?? this.aboutRulesHeight,
    gridColumns: gridColumns ?? this.gridColumns,
    stackColumns: stackColumns ?? this.stackColumns,
    historyFeatureHeight: historyFeatureHeight ?? this.historyFeatureHeight,
    historyCardHeight: historyCardHeight ?? this.historyCardHeight,
    historyProminentHeight:
        historyProminentHeight ?? this.historyProminentHeight,
    widePaneFlex: widePaneFlex ?? this.widePaneFlex,
    narrowPaneFlex: narrowPaneFlex ?? this.narrowPaneFlex,
    rosterContextHeight: rosterContextHeight ?? this.rosterContextHeight,
    modalSheetWidth: modalSheetWidth ?? this.modalSheetWidth,
    modalViewportInset: modalViewportInset ?? this.modalViewportInset,
    modalMobileMinHeight: modalMobileMinHeight ?? this.modalMobileMinHeight,
    matchDesktopNameSize: matchDesktopNameSize ?? this.matchDesktopNameSize,
    matchMobileNameFactor: matchMobileNameFactor ?? this.matchMobileNameFactor,
    matchDesktopAvatar: matchDesktopAvatar ?? this.matchDesktopAvatar,
    matchMobileAvatar: matchMobileAvatar ?? this.matchMobileAvatar,
    bracketGrid: bracketGrid ?? this.bracketGrid,
    bracketDot: bracketDot ?? this.bracketDot,
    bracketStroke: bracketStroke ?? this.bracketStroke,
    bracketScaleMin: bracketScaleMin ?? this.bracketScaleMin,
    bracketScaleMax: bracketScaleMax ?? this.bracketScaleMax,
    bracketScaleStep: bracketScaleStep ?? this.bracketScaleStep,
    bracketNodeHalf: bracketNodeHalf ?? this.bracketNodeHalf,
    bracketNodeHalfHeight: bracketNodeHalfHeight ?? this.bracketNodeHalfHeight,
    resultDesktopAvatar: resultDesktopAvatar ?? this.resultDesktopAvatar,
    resultContentWidth: resultContentWidth ?? this.resultContentWidth,
    resultOutcomeFactor: resultOutcomeFactor ?? this.resultOutcomeFactor,
    championDesktopAvatar: championDesktopAvatar ?? this.championDesktopAvatar,
    championMobileAvatar: championMobileAvatar ?? this.championMobileAvatar,
    championDesktopNameSize:
        championDesktopNameSize ?? this.championDesktopNameSize,
    championMobileNameSize:
        championMobileNameSize ?? this.championMobileNameSize,
    championHeight: championHeight ?? this.championHeight,
    championContextTitleSize:
        championContextTitleSize ?? this.championContextTitleSize,
    rankFeaturedHeight: rankFeaturedHeight ?? this.rankFeaturedHeight,
    rankRegularHeight: rankRegularHeight ?? this.rankRegularHeight,
    rankFeaturedName: rankFeaturedName ?? this.rankFeaturedName,
    rankFeaturedValue: rankFeaturedValue ?? this.rankFeaturedValue,
    resultsContextTitleSize:
        resultsContextTitleSize ?? this.resultsContextTitleSize,
    screenBrandSize: screenBrandSize ?? this.screenBrandSize,
    screenBrandLine: screenBrandLine ?? this.screenBrandLine,
    screenBrandTracking: screenBrandTracking ?? this.screenBrandTracking,
    desktopContentMinHeight:
        desktopContentMinHeight ?? this.desktopContentMinHeight,
    utilityWidth: utilityWidth ?? this.utilityWidth,
    utilityHeight: utilityHeight ?? this.utilityHeight,
    utilityTop: utilityTop ?? this.utilityTop,
    utilityReserve: utilityReserve ?? this.utilityReserve,
    utilityAction: utilityAction ?? this.utilityAction,
    desktopHero: desktopHero ?? this.desktopHero,
    mobileHero: mobileHero ?? this.mobileHero,
    heroLine: heroLine ?? this.heroLine,
    heroTracking: heroTracking ?? this.heroTracking,
    primaryFlex: primaryFlex ?? this.primaryFlex,
    secondaryFlex: secondaryFlex ?? this.secondaryFlex,
    brandHeight: brandHeight ?? this.brandHeight,
    formWidth: formWidth ?? this.formWidth,
  );
  @override
  AppScreenMetrics lerp(
    covariant AppScreenMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppScreenMetrics(
      start: start,
      stretch: stretch,
      centerCross: centerCross,
      centerMain: centerMain,
      startMain: startMain,
      spaceBetween: spaceBetween,
      centerAlign: centerAlign,
      bottomAlign: bottomAlign,
      rightAlign: rightAlign,
      topLeft: topLeft,
      min: min,
      max: max,
      centerText: centerText,
      leftText: leftText,
      bootTop: lerpDouble(bootTop, other.bootTop, interpolationAmount)!,
      bootBrandHeight: lerpDouble(
        bootBrandHeight,
        other.bootBrandHeight,
        interpolationAmount,
      )!,
      bootCueHeight: lerpDouble(
        bootCueHeight,
        other.bootCueHeight,
        interpolationAmount,
      )!,
      bootFont: lerpDouble(bootFont, other.bootFont, interpolationAmount)!,
      bootGap: lerpDouble(bootGap, other.bootGap, interpolationAmount)!,
      homeTitleWidth: lerpDouble(
        homeTitleWidth,
        other.homeTitleWidth,
        interpolationAmount,
      )!,
      homeActionHeight: lerpDouble(
        homeActionHeight,
        other.homeActionHeight,
        interpolationAmount,
      )!,
      homeMetaSize: lerpDouble(
        homeMetaSize,
        other.homeMetaSize,
        interpolationAmount,
      )!,
      homePrimaryFlex: interpolationAmount < 0.5
          ? homePrimaryFlex
          : other.homePrimaryFlex,
      homeSecondaryFlex: interpolationAmount < 0.5
          ? homeSecondaryFlex
          : other.homeSecondaryFlex,
      profileLinkHeight: lerpDouble(
        profileLinkHeight,
        other.profileLinkHeight,
        interpolationAmount,
      )!,
      profileNameSize: lerpDouble(
        profileNameSize,
        other.profileNameSize,
        interpolationAmount,
      )!,
      simpleWidth: lerpDouble(
        simpleWidth,
        other.simpleWidth,
        interpolationAmount,
      )!,
      simplePadding: lerpDouble(
        simplePadding,
        other.simplePadding,
        interpolationAmount,
      )!,
      simpleIntroFlex: interpolationAmount < 0.5
          ? simpleIntroFlex
          : other.simpleIntroFlex,
      simpleFormFlex: interpolationAmount < 0.5
          ? simpleFormFlex
          : other.simpleFormFlex,
      settingsHeight: lerpDouble(
        settingsHeight,
        other.settingsHeight,
        interpolationAmount,
      )!,
      secondaryHeroSize: lerpDouble(
        secondaryHeroSize,
        other.secondaryHeroSize,
        interpolationAmount,
      )!,
      aboutHeight: lerpDouble(
        aboutHeight,
        other.aboutHeight,
        interpolationAmount,
      )!,
      aboutVersionHeight: lerpDouble(
        aboutVersionHeight,
        other.aboutVersionHeight,
        interpolationAmount,
      )!,
      aboutRulesHeight: lerpDouble(
        aboutRulesHeight,
        other.aboutRulesHeight,
        interpolationAmount,
      )!,
      gridColumns: interpolationAmount < 0.5 ? gridColumns : other.gridColumns,
      stackColumns: interpolationAmount < 0.5
          ? stackColumns
          : other.stackColumns,
      historyFeatureHeight: lerpDouble(
        historyFeatureHeight,
        other.historyFeatureHeight,
        interpolationAmount,
      )!,
      historyCardHeight: lerpDouble(
        historyCardHeight,
        other.historyCardHeight,
        interpolationAmount,
      )!,
      historyProminentHeight: lerpDouble(
        historyProminentHeight,
        other.historyProminentHeight,
        interpolationAmount,
      )!,
      widePaneFlex: interpolationAmount < 0.5
          ? widePaneFlex
          : other.widePaneFlex,
      narrowPaneFlex: interpolationAmount < 0.5
          ? narrowPaneFlex
          : other.narrowPaneFlex,
      rosterContextHeight: lerpDouble(
        rosterContextHeight,
        other.rosterContextHeight,
        interpolationAmount,
      )!,
      modalSheetWidth: lerpDouble(
        modalSheetWidth,
        other.modalSheetWidth,
        interpolationAmount,
      )!,
      modalViewportInset: lerpDouble(
        modalViewportInset,
        other.modalViewportInset,
        interpolationAmount,
      )!,
      modalMobileMinHeight: lerpDouble(
        modalMobileMinHeight,
        other.modalMobileMinHeight,
        interpolationAmount,
      )!,
      matchDesktopNameSize: lerpDouble(
        matchDesktopNameSize,
        other.matchDesktopNameSize,
        interpolationAmount,
      )!,
      matchMobileNameFactor: lerpDouble(
        matchMobileNameFactor,
        other.matchMobileNameFactor,
        interpolationAmount,
      )!,
      matchDesktopAvatar: lerpDouble(
        matchDesktopAvatar,
        other.matchDesktopAvatar,
        interpolationAmount,
      )!,
      matchMobileAvatar: lerpDouble(
        matchMobileAvatar,
        other.matchMobileAvatar,
        interpolationAmount,
      )!,
      bracketGrid: lerpDouble(
        bracketGrid,
        other.bracketGrid,
        interpolationAmount,
      )!,
      bracketDot: lerpDouble(
        bracketDot,
        other.bracketDot,
        interpolationAmount,
      )!,
      bracketStroke: lerpDouble(
        bracketStroke,
        other.bracketStroke,
        interpolationAmount,
      )!,
      bracketScaleMin: lerpDouble(
        bracketScaleMin,
        other.bracketScaleMin,
        interpolationAmount,
      )!,
      bracketScaleMax: lerpDouble(
        bracketScaleMax,
        other.bracketScaleMax,
        interpolationAmount,
      )!,
      bracketScaleStep: lerpDouble(
        bracketScaleStep,
        other.bracketScaleStep,
        interpolationAmount,
      )!,
      bracketNodeHalf: lerpDouble(
        bracketNodeHalf,
        other.bracketNodeHalf,
        interpolationAmount,
      )!,
      bracketNodeHalfHeight: lerpDouble(
        bracketNodeHalfHeight,
        other.bracketNodeHalfHeight,
        interpolationAmount,
      )!,
      resultDesktopAvatar: lerpDouble(
        resultDesktopAvatar,
        other.resultDesktopAvatar,
        interpolationAmount,
      )!,
      resultContentWidth: lerpDouble(
        resultContentWidth,
        other.resultContentWidth,
        interpolationAmount,
      )!,
      resultOutcomeFactor: lerpDouble(
        resultOutcomeFactor,
        other.resultOutcomeFactor,
        interpolationAmount,
      )!,
      championDesktopAvatar: lerpDouble(
        championDesktopAvatar,
        other.championDesktopAvatar,
        interpolationAmount,
      )!,
      championMobileAvatar: lerpDouble(
        championMobileAvatar,
        other.championMobileAvatar,
        interpolationAmount,
      )!,
      championDesktopNameSize: lerpDouble(
        championDesktopNameSize,
        other.championDesktopNameSize,
        interpolationAmount,
      )!,
      championMobileNameSize: lerpDouble(
        championMobileNameSize,
        other.championMobileNameSize,
        interpolationAmount,
      )!,
      championHeight: lerpDouble(
        championHeight,
        other.championHeight,
        interpolationAmount,
      )!,
      championContextTitleSize: lerpDouble(
        championContextTitleSize,
        other.championContextTitleSize,
        interpolationAmount,
      )!,
      rankFeaturedHeight: lerpDouble(
        rankFeaturedHeight,
        other.rankFeaturedHeight,
        interpolationAmount,
      )!,
      rankRegularHeight: lerpDouble(
        rankRegularHeight,
        other.rankRegularHeight,
        interpolationAmount,
      )!,
      rankFeaturedName: lerpDouble(
        rankFeaturedName,
        other.rankFeaturedName,
        interpolationAmount,
      )!,
      rankFeaturedValue: lerpDouble(
        rankFeaturedValue,
        other.rankFeaturedValue,
        interpolationAmount,
      )!,
      resultsContextTitleSize: lerpDouble(
        resultsContextTitleSize,
        other.resultsContextTitleSize,
        interpolationAmount,
      )!,
      screenBrandSize: lerpDouble(
        screenBrandSize,
        other.screenBrandSize,
        interpolationAmount,
      )!,
      screenBrandLine: lerpDouble(
        screenBrandLine,
        other.screenBrandLine,
        interpolationAmount,
      )!,
      screenBrandTracking: lerpDouble(
        screenBrandTracking,
        other.screenBrandTracking,
        interpolationAmount,
      )!,
      desktopContentMinHeight: lerpDouble(
        desktopContentMinHeight,
        other.desktopContentMinHeight,
        interpolationAmount,
      )!,
      utilityWidth: lerpDouble(
        utilityWidth,
        other.utilityWidth,
        interpolationAmount,
      )!,
      utilityHeight: lerpDouble(
        utilityHeight,
        other.utilityHeight,
        interpolationAmount,
      )!,
      utilityTop: lerpDouble(
        utilityTop,
        other.utilityTop,
        interpolationAmount,
      )!,
      utilityReserve: lerpDouble(
        utilityReserve,
        other.utilityReserve,
        interpolationAmount,
      )!,
      utilityAction: lerpDouble(
        utilityAction,
        other.utilityAction,
        interpolationAmount,
      )!,
      desktopHero: lerpDouble(
        desktopHero,
        other.desktopHero,
        interpolationAmount,
      )!,
      mobileHero: lerpDouble(
        mobileHero,
        other.mobileHero,
        interpolationAmount,
      )!,
      heroLine: lerpDouble(heroLine, other.heroLine, interpolationAmount)!,
      heroTracking: lerpDouble(
        heroTracking,
        other.heroTracking,
        interpolationAmount,
      )!,
      primaryFlex: primaryFlex,
      secondaryFlex: secondaryFlex,
      brandHeight: lerpDouble(
        brandHeight,
        other.brandHeight,
        interpolationAmount,
      )!,
      formWidth: lerpDouble(formWidth, other.formWidth, interpolationAmount)!,
    );
  }
}
