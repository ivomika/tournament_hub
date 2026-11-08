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
    required this.rightAlign,
    required this.topLeft,
    required this.min,
    required this.max,
    required this.centerText,
    required this.leftText,
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
  final Alignment rightAlign;
  final Alignment topLeft;
  final MainAxisSize min;
  final MainAxisSize max;
  final TextAlign centerText;
  final TextAlign leftText;
  final double utilityWidth,
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
    Alignment? rightAlign,
    Alignment? topLeft,
    MainAxisSize? min,
    MainAxisSize? max,
    TextAlign? centerText,
    TextAlign? leftText,
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
    rightAlign: rightAlign ?? this.rightAlign,
    topLeft: topLeft ?? this.topLeft,
    min: min ?? this.min,
    max: max ?? this.max,
    centerText: centerText ?? this.centerText,
    leftText: leftText ?? this.leftText,
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
          rightAlign: rightAlign,
          topLeft: topLeft,
          min: min,
          max: max,
          centerText: centerText,
          leftText: leftText,
          utilityWidth: lerpDouble(utilityWidth, other.utilityWidth, t)!,
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
