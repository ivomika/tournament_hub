import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppResponsive extends ThemeExtension<AppResponsive> {
  const AppResponsive({
    required this.mobileToDesktopWidth,
    required this.compactDesktopWidth,
    required this.wideCompositionWidth,
    required this.compactControlHeight,
    required this.touchControlHeight,
    required this.avatarExtraSmall,
    required this.avatarSmall,
    required this.avatarMedium,
    required this.avatarLarge,
    required this.avatarProfile,
    required this.avatarPortrait,
    required this.avatarHero,
  });
  final double mobileToDesktopWidth;
  final double compactDesktopWidth;
  final double wideCompositionWidth;
  final double compactControlHeight;
  final double touchControlHeight;
  final double avatarExtraSmall;
  final double avatarSmall;
  final double avatarMedium;
  final double avatarLarge;
  final double avatarProfile;
  final double avatarPortrait;
  final double avatarHero;
  @override
  AppResponsive copyWith({
    double? mobileToDesktopWidth,
    double? compactDesktopWidth,
    double? wideCompositionWidth,
    double? compactControlHeight,
    double? touchControlHeight,
    double? avatarExtraSmall,
    double? avatarSmall,
    double? avatarMedium,
    double? avatarLarge,
    double? avatarProfile,
    double? avatarPortrait,
    double? avatarHero,
  }) => AppResponsive(
    mobileToDesktopWidth: mobileToDesktopWidth ?? this.mobileToDesktopWidth,
    compactDesktopWidth: compactDesktopWidth ?? this.compactDesktopWidth,
    wideCompositionWidth: wideCompositionWidth ?? this.wideCompositionWidth,
    compactControlHeight: compactControlHeight ?? this.compactControlHeight,
    touchControlHeight: touchControlHeight ?? this.touchControlHeight,
    avatarExtraSmall: avatarExtraSmall ?? this.avatarExtraSmall,
    avatarSmall: avatarSmall ?? this.avatarSmall,
    avatarMedium: avatarMedium ?? this.avatarMedium,
    avatarLarge: avatarLarge ?? this.avatarLarge,
    avatarProfile: avatarProfile ?? this.avatarProfile,
    avatarPortrait: avatarPortrait ?? this.avatarPortrait,
    avatarHero: avatarHero ?? this.avatarHero,
  );
  @override
  AppResponsive lerp(covariant AppResponsive? other, double t) {
    if (other == null) return this;
    return AppResponsive(
      mobileToDesktopWidth: lerpDouble(
        mobileToDesktopWidth,
        other.mobileToDesktopWidth,
        t,
      )!,
      compactDesktopWidth: lerpDouble(
        compactDesktopWidth,
        other.compactDesktopWidth,
        t,
      )!,
      wideCompositionWidth: lerpDouble(
        wideCompositionWidth,
        other.wideCompositionWidth,
        t,
      )!,
      compactControlHeight: lerpDouble(
        compactControlHeight,
        other.compactControlHeight,
        t,
      )!,
      touchControlHeight: lerpDouble(
        touchControlHeight,
        other.touchControlHeight,
        t,
      )!,
      avatarExtraSmall: lerpDouble(
        avatarExtraSmall,
        other.avatarExtraSmall,
        t,
      )!,
      avatarSmall: lerpDouble(avatarSmall, other.avatarSmall, t)!,
      avatarMedium: lerpDouble(avatarMedium, other.avatarMedium, t)!,
      avatarLarge: lerpDouble(avatarLarge, other.avatarLarge, t)!,
      avatarProfile: lerpDouble(avatarProfile, other.avatarProfile, t)!,
      avatarPortrait: lerpDouble(avatarPortrait, other.avatarPortrait, t)!,
      avatarHero: lerpDouble(avatarHero, other.avatarHero, t)!,
    );
  }
}
