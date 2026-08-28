import 'dart:ui';

import 'package:flutter/material.dart';

class AppShellTheme extends ThemeExtension<AppShellTheme> {
  const AppShellTheme({
    required this.background,
    required this.elevatedBackground,
    required this.navigationBackground,
    required this.divider,
    required this.accent,
    required this.desktopBreakpoint,
    required this.contentMaxWidth,
    required this.pagePaddingCompact,
    required this.pagePaddingDesktop,
    required this.headingGap,
    required this.labelGap,
    required this.brandMarkWidth,
  });

  final Color background;
  final Color elevatedBackground;
  final Color navigationBackground;
  final Color divider;
  final Color accent;
  final double desktopBreakpoint;
  final double contentMaxWidth;
  final double pagePaddingCompact;
  final double pagePaddingDesktop;
  final double headingGap;
  final double labelGap;
  final double brandMarkWidth;

  @override
  AppShellTheme copyWith({
    Color? background,
    Color? elevatedBackground,
    Color? navigationBackground,
    Color? divider,
    Color? accent,
    double? desktopBreakpoint,
    double? contentMaxWidth,
    double? pagePaddingCompact,
    double? pagePaddingDesktop,
    double? headingGap,
    double? labelGap,
    double? brandMarkWidth,
  }) => AppShellTheme(
    background: background ?? this.background,
    elevatedBackground: elevatedBackground ?? this.elevatedBackground,
    navigationBackground: navigationBackground ?? this.navigationBackground,
    divider: divider ?? this.divider,
    accent: accent ?? this.accent,
    desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
    contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    pagePaddingCompact: pagePaddingCompact ?? this.pagePaddingCompact,
    pagePaddingDesktop: pagePaddingDesktop ?? this.pagePaddingDesktop,
    headingGap: headingGap ?? this.headingGap,
    labelGap: labelGap ?? this.labelGap,
    brandMarkWidth: brandMarkWidth ?? this.brandMarkWidth,
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
      accent: Color.lerp(accent, other.accent, t)!,
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
      pagePaddingDesktop: lerpDouble(
        pagePaddingDesktop,
        other.pagePaddingDesktop,
        t,
      )!,
      headingGap: lerpDouble(headingGap, other.headingGap, t)!,
      labelGap: lerpDouble(labelGap, other.labelGap, t)!,
      brandMarkWidth: lerpDouble(brandMarkWidth, other.brandMarkWidth, t)!,
    );
  }
}
