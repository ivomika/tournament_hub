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
    required this.bracketGrid,required this.bracketDot,required this.bracketStroke,required this.bracketScaleMin,required this.bracketScaleMax,required this.bracketScaleStep,required this.bracketNodeHalf,required this.bracketNodeHalfHeight,required this.resultDesktopAvatar,required this.resultContentWidth,required this.resultOutcomeFactor,required this.championDesktopAvatar,required this.championMobileAvatar,required this.championDesktopNameSize,required this.championMobileNameSize,required this.championHeight,required this.championContextTitleSize,required this.utilityWidth,
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
final double bracketGrid;final double bracketDot;final double bracketStroke;final double bracketScaleMin;final double bracketScaleMax;final double bracketScaleStep;final double bracketNodeHalf;final double bracketNodeHalfHeight;final double resultDesktopAvatar;final double resultContentWidth;final double resultOutcomeFactor;final double championDesktopAvatar;final double championMobileAvatar;final double championDesktopNameSize;final double championMobileNameSize;final double championHeight;final double championContextTitleSize;  final double matchDesktopNameSize;
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
    double? bracketGrid,double? bracketDot,double? bracketStroke,double? bracketScaleMin,double? bracketScaleMax,double? bracketScaleStep,double? bracketNodeHalf,double? bracketNodeHalfHeight,double? resultDesktopAvatar,double? resultContentWidth,double? resultOutcomeFactor,double? championDesktopAvatar,double? championMobileAvatar,double? championDesktopNameSize,double? championMobileNameSize,double? championHeight,double? championContextTitleSize,double? utilityWidth,
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
    bracketGrid:bracketGrid??this.bracketGrid,bracketDot:bracketDot??this.bracketDot,bracketStroke:bracketStroke??this.bracketStroke,bracketScaleMin:bracketScaleMin??this.bracketScaleMin,bracketScaleMax:bracketScaleMax??this.bracketScaleMax,bracketScaleStep:bracketScaleStep??this.bracketScaleStep,bracketNodeHalf:bracketNodeHalf??this.bracketNodeHalf,bracketNodeHalfHeight:bracketNodeHalfHeight??this.bracketNodeHalfHeight,resultDesktopAvatar:resultDesktopAvatar??this.resultDesktopAvatar,resultContentWidth:resultContentWidth??this.resultContentWidth,resultOutcomeFactor:resultOutcomeFactor??this.resultOutcomeFactor,championDesktopAvatar:championDesktopAvatar??this.championDesktopAvatar,championMobileAvatar:championMobileAvatar??this.championMobileAvatar,championDesktopNameSize:championDesktopNameSize??this.championDesktopNameSize,championMobileNameSize:championMobileNameSize??this.championMobileNameSize,championHeight:championHeight??this.championHeight,championContextTitleSize:championContextTitleSize??this.championContextTitleSize,utilityWidth: utilityWidth ?? this.utilityWidth,
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
  AppScreenMetrics lerp(covariant AppScreenMetrics? other, double t) =>
      other == null
      ? this
      : AppScreenMetrics(
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
          bootTop: lerpDouble(bootTop, other.bootTop, t)!,
          bootBrandHeight: lerpDouble(
            bootBrandHeight,
            other.bootBrandHeight,
            t,
          )!,
          bootCueHeight: lerpDouble(bootCueHeight, other.bootCueHeight, t)!,
          bootFont: lerpDouble(bootFont, other.bootFont, t)!,
          bootGap: lerpDouble(bootGap, other.bootGap, t)!,
          homeTitleWidth: lerpDouble(homeTitleWidth, other.homeTitleWidth, t)!,
          homeActionHeight: lerpDouble(
            homeActionHeight,
            other.homeActionHeight,
            t,
          )!,
          homeMetaSize: lerpDouble(homeMetaSize, other.homeMetaSize, t)!,
          homePrimaryFlex: t < 0.5 ? homePrimaryFlex : other.homePrimaryFlex,
          homeSecondaryFlex: t < 0.5
              ? homeSecondaryFlex
              : other.homeSecondaryFlex,
          profileLinkHeight: lerpDouble(
            profileLinkHeight,
            other.profileLinkHeight,
            t,
          )!,
          profileNameSize: lerpDouble(
            profileNameSize,
            other.profileNameSize,
            t,
          )!,
          simpleWidth: lerpDouble(simpleWidth, other.simpleWidth, t)!,
          simplePadding: lerpDouble(simplePadding, other.simplePadding, t)!,
          simpleIntroFlex: t < 0.5 ? simpleIntroFlex : other.simpleIntroFlex,
          simpleFormFlex: t < 0.5 ? simpleFormFlex : other.simpleFormFlex,
          settingsHeight: lerpDouble(settingsHeight, other.settingsHeight, t)!,
          secondaryHeroSize: lerpDouble(
            secondaryHeroSize,
            other.secondaryHeroSize,
            t,
          )!,
          aboutHeight: lerpDouble(aboutHeight, other.aboutHeight, t)!,
          aboutVersionHeight: lerpDouble(
            aboutVersionHeight,
            other.aboutVersionHeight,
            t,
          )!,
          aboutRulesHeight: lerpDouble(
            aboutRulesHeight,
            other.aboutRulesHeight,
            t,
          )!,
          gridColumns: t < 0.5 ? gridColumns : other.gridColumns,
          stackColumns: t < 0.5 ? stackColumns : other.stackColumns,
          historyFeatureHeight: lerpDouble(
            historyFeatureHeight,
            other.historyFeatureHeight,
            t,
          )!,
          historyCardHeight: lerpDouble(
            historyCardHeight,
            other.historyCardHeight,
            t,
          )!,
          historyProminentHeight: lerpDouble(
            historyProminentHeight,
            other.historyProminentHeight,
            t,
          )!,
          widePaneFlex: t < 0.5 ? widePaneFlex : other.widePaneFlex,
          narrowPaneFlex: t < 0.5 ? narrowPaneFlex : other.narrowPaneFlex,
          rosterContextHeight: lerpDouble(
            rosterContextHeight,
            other.rosterContextHeight,
            t,
          )!,
          modalSheetWidth: lerpDouble(
            modalSheetWidth,
            other.modalSheetWidth,
            t,
          )!,
          modalViewportInset: lerpDouble(
            modalViewportInset,
            other.modalViewportInset,
            t,
          )!,
          modalMobileMinHeight: lerpDouble(
            modalMobileMinHeight,
            other.modalMobileMinHeight,
            t,
          )!,
          matchDesktopNameSize: lerpDouble(
            matchDesktopNameSize,
            other.matchDesktopNameSize,
            t,
          )!,
          matchMobileNameFactor: lerpDouble(
            matchMobileNameFactor,
            other.matchMobileNameFactor,
            t,
          )!,
          matchDesktopAvatar: lerpDouble(
            matchDesktopAvatar,
            other.matchDesktopAvatar,
            t,
          )!,
          matchMobileAvatar: lerpDouble(
            matchMobileAvatar,
            other.matchMobileAvatar,
            t,
          )!,
          bracketGrid:lerpDouble(bracketGrid,other.bracketGrid,t)!,bracketDot:lerpDouble(bracketDot,other.bracketDot,t)!,bracketStroke:lerpDouble(bracketStroke,other.bracketStroke,t)!,bracketScaleMin:lerpDouble(bracketScaleMin,other.bracketScaleMin,t)!,bracketScaleMax:lerpDouble(bracketScaleMax,other.bracketScaleMax,t)!,bracketScaleStep:lerpDouble(bracketScaleStep,other.bracketScaleStep,t)!,bracketNodeHalf:lerpDouble(bracketNodeHalf,other.bracketNodeHalf,t)!,bracketNodeHalfHeight:lerpDouble(bracketNodeHalfHeight,other.bracketNodeHalfHeight,t)!,resultDesktopAvatar:lerpDouble(resultDesktopAvatar,other.resultDesktopAvatar,t)!,resultContentWidth:lerpDouble(resultContentWidth,other.resultContentWidth,t)!,resultOutcomeFactor:lerpDouble(resultOutcomeFactor,other.resultOutcomeFactor,t)!,championDesktopAvatar:lerpDouble(championDesktopAvatar,other.championDesktopAvatar,t)!,championMobileAvatar:lerpDouble(championMobileAvatar,other.championMobileAvatar,t)!,championDesktopNameSize:lerpDouble(championDesktopNameSize,other.championDesktopNameSize,t)!,championMobileNameSize:lerpDouble(championMobileNameSize,other.championMobileNameSize,t)!,championHeight:lerpDouble(championHeight,other.championHeight,t)!,championContextTitleSize:lerpDouble(championContextTitleSize,other.championContextTitleSize,t)!,utilityWidth: lerpDouble(utilityWidth, other.utilityWidth, t)!,
          utilityHeight: lerpDouble(utilityHeight, other.utilityHeight, t)!,
          utilityTop: lerpDouble(utilityTop, other.utilityTop, t)!,
          utilityReserve: lerpDouble(utilityReserve, other.utilityReserve, t)!,
          utilityAction: lerpDouble(utilityAction, other.utilityAction, t)!,
          desktopHero: lerpDouble(desktopHero, other.desktopHero, t)!,
          mobileHero: lerpDouble(mobileHero, other.mobileHero, t)!,
          heroLine: lerpDouble(heroLine, other.heroLine, t)!,
          heroTracking: lerpDouble(heroTracking, other.heroTracking, t)!,
          primaryFlex: primaryFlex,
          secondaryFlex: secondaryFlex,
          brandHeight: lerpDouble(brandHeight, other.brandHeight, t)!,
          formWidth: lerpDouble(formWidth, other.formWidth, t)!,
        );
}
