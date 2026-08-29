import 'dart:ui';

import 'package:flutter/material.dart';

class AppShellTheme extends ThemeExtension<AppShellTheme> {
  const AppShellTheme({
    required this.background,
    required this.elevatedBackground,
    required this.navigationBackground,
    required this.divider,
    required this.desktopBreakpoint,
    required this.contentMaxWidth,
    required this.pagePaddingCompact,
    required this.mediumBreakpoint,
    required this.pagePaddingMedium,
    required this.pagePaddingDesktop,
    required this.contentGap,
    required this.navigationHeight,
    required this.actionDockEstimatedHeight,
    required this.portraitFixedStackMaxFraction,
    required this.landscapeFixedStackMaxFraction,
    required this.navigationWithDockMaxTextScale,
  });

  final Color background;
  final Color elevatedBackground;
  final Color navigationBackground;
  final Color divider;
  final double desktopBreakpoint;
  final double contentMaxWidth;
  final double pagePaddingCompact;
  final double mediumBreakpoint;
  final double pagePaddingMedium;
  final double pagePaddingDesktop;
  final double contentGap;
  final double navigationHeight;
  final double actionDockEstimatedHeight;
  final double portraitFixedStackMaxFraction;
  final double landscapeFixedStackMaxFraction;
  final double navigationWithDockMaxTextScale;

  @override
  AppShellTheme copyWith({
    Color? background,
    Color? elevatedBackground,
    Color? navigationBackground,
    Color? divider,
    double? desktopBreakpoint,
    double? contentMaxWidth,
    double? pagePaddingCompact,
    double? mediumBreakpoint,
    double? pagePaddingMedium,
    double? pagePaddingDesktop,
    double? contentGap,
    double? navigationHeight,
    double? actionDockEstimatedHeight,
    double? portraitFixedStackMaxFraction,
    double? landscapeFixedStackMaxFraction,
    double? navigationWithDockMaxTextScale,
  }) => AppShellTheme(
    background: background ?? this.background,
    elevatedBackground: elevatedBackground ?? this.elevatedBackground,
    navigationBackground: navigationBackground ?? this.navigationBackground,
    divider: divider ?? this.divider,
    desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
    contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    pagePaddingCompact: pagePaddingCompact ?? this.pagePaddingCompact,
    mediumBreakpoint: mediumBreakpoint ?? this.mediumBreakpoint,
    pagePaddingMedium: pagePaddingMedium ?? this.pagePaddingMedium,
    pagePaddingDesktop: pagePaddingDesktop ?? this.pagePaddingDesktop,
    contentGap: contentGap ?? this.contentGap,
    navigationHeight: navigationHeight ?? this.navigationHeight,
    actionDockEstimatedHeight:
        actionDockEstimatedHeight ?? this.actionDockEstimatedHeight,
    portraitFixedStackMaxFraction:
        portraitFixedStackMaxFraction ?? this.portraitFixedStackMaxFraction,
    landscapeFixedStackMaxFraction:
        landscapeFixedStackMaxFraction ?? this.landscapeFixedStackMaxFraction,
    navigationWithDockMaxTextScale:
        navigationWithDockMaxTextScale ?? this.navigationWithDockMaxTextScale,
  );

  @override
  AppShellTheme lerp(covariant AppShellTheme? other, double t) {
    if (other == null) return this;
    return AppShellTheme(
      background: Color.lerp(background, other.background, t)!,
      elevatedBackground: Color.lerp(
        elevatedBackground,
        other.elevatedBackground,
        t,
      )!,
      navigationBackground: Color.lerp(
        navigationBackground,
        other.navigationBackground,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
      desktopBreakpoint: lerpDouble(
        desktopBreakpoint,
        other.desktopBreakpoint,
        t,
      )!,
      contentMaxWidth: lerpDouble(contentMaxWidth, other.contentMaxWidth, t)!,
      pagePaddingCompact: lerpDouble(
        pagePaddingCompact,
        other.pagePaddingCompact,
        t,
      )!,
      mediumBreakpoint: lerpDouble(
        mediumBreakpoint,
        other.mediumBreakpoint,
        t,
      )!,
      pagePaddingMedium: lerpDouble(
        pagePaddingMedium,
        other.pagePaddingMedium,
        t,
      )!,
      pagePaddingDesktop: lerpDouble(
        pagePaddingDesktop,
        other.pagePaddingDesktop,
        t,
      )!,
      contentGap: lerpDouble(contentGap, other.contentGap, t)!,
      navigationHeight: lerpDouble(
        navigationHeight,
        other.navigationHeight,
        t,
      )!,
      actionDockEstimatedHeight: lerpDouble(
        actionDockEstimatedHeight,
        other.actionDockEstimatedHeight,
        t,
      )!,
      portraitFixedStackMaxFraction: lerpDouble(
        portraitFixedStackMaxFraction,
        other.portraitFixedStackMaxFraction,
        t,
      )!,
      landscapeFixedStackMaxFraction: lerpDouble(
        landscapeFixedStackMaxFraction,
        other.landscapeFixedStackMaxFraction,
        t,
      )!,
      navigationWithDockMaxTextScale: lerpDouble(
        navigationWithDockMaxTextScale,
        other.navigationWithDockMaxTextScale,
        t,
      )!,
    );
  }
}
