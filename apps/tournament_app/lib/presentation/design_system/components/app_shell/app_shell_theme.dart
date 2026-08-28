import 'dart:ui';

import 'package:flutter/material.dart';

class AppShellTheme extends ThemeExtension<AppShellTheme> {
  const AppShellTheme({
    required this.background,
    required this.navigationBackground,
    required this.divider,
    required this.desktopBreakpoint,
    required this.contentMaxWidth,
    required this.pagePadding,
    required this.headingGap,
  });

  final Color background;
  final Color navigationBackground;
  final Color divider;
  final double desktopBreakpoint;
  final double contentMaxWidth;
  final double pagePadding;
  final double headingGap;

  @override
  AppShellTheme copyWith({
    Color? background,
    Color? navigationBackground,
    Color? divider,
    double? desktopBreakpoint,
    double? contentMaxWidth,
    double? pagePadding,
    double? headingGap,
  }) => AppShellTheme(
    background: background ?? this.background,
    navigationBackground: navigationBackground ?? this.navigationBackground,
    divider: divider ?? this.divider,
    desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
    contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    pagePadding: pagePadding ?? this.pagePadding,
    headingGap: headingGap ?? this.headingGap,
  );

  @override
  AppShellTheme lerp(covariant AppShellTheme? other, double t) {
    if (other == null) return this;
    return AppShellTheme(
      background: Color.lerp(background, other.background, t)!,
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
      pagePadding: lerpDouble(pagePadding, other.pagePadding, t)!,
      headingGap: lerpDouble(headingGap, other.headingGap, t)!,
    );
  }
}
