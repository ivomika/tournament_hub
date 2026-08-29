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
    required this.pagePaddingDesktop,
    required this.contentGap,
  });

  final Color background;
  final Color elevatedBackground;
  final Color navigationBackground;
  final Color divider;
  final double desktopBreakpoint;
  final double contentMaxWidth;
  final double pagePaddingCompact;
  final double pagePaddingDesktop;
  final double contentGap;

  @override
  AppShellTheme copyWith({
    Color? background,
    Color? elevatedBackground,
    Color? navigationBackground,
    Color? divider,
    double? desktopBreakpoint,
    double? contentMaxWidth,
    double? pagePaddingCompact,
    double? pagePaddingDesktop,
    double? contentGap,
  }) => AppShellTheme(
    background: background ?? this.background,
    elevatedBackground: elevatedBackground ?? this.elevatedBackground,
    navigationBackground: navigationBackground ?? this.navigationBackground,
    divider: divider ?? this.divider,
    desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
    contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    pagePaddingCompact: pagePaddingCompact ?? this.pagePaddingCompact,
    pagePaddingDesktop: pagePaddingDesktop ?? this.pagePaddingDesktop,
    contentGap: contentGap ?? this.contentGap,
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
      pagePaddingDesktop: lerpDouble(
        pagePaddingDesktop,
        other.pagePaddingDesktop,
        t,
      )!,
      contentGap: lerpDouble(contentGap, other.contentGap, t)!,
    );
  }
}
