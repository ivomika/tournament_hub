import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AppAvatarMetrics extends ThemeExtension<AppAvatarMetrics> {
  const AppAvatarMetrics({
    required this.contentAlignment,
    required this.leadingDistribution,
    required this.avatarFont28,
    required this.avatarFont40,
    required this.avatarFont48,
    required this.avatarFont64,
    required this.avatarFont96,
    required this.avatarFont112,
    required this.avatarFont128,
    required this.avatarRadius28,
    required this.avatarRadius40,
    required this.avatarRadius48,
    required this.avatarRadius64,
    required this.avatarRadius96,
    required this.avatarRadius112,
    required this.avatarRadius128,
    required this.avatarLineHeight,
    required this.avatarTracking,
  });
  final TextLeadingDistribution leadingDistribution;
  final Alignment contentAlignment;
  final double avatarFont28;
  final double avatarFont40;
  final double avatarFont48;
  final double avatarFont64;
  final double avatarFont96;
  final double avatarFont112;
  final double avatarFont128;
  final double avatarRadius28;
  final double avatarRadius40;
  final double avatarRadius48;
  final double avatarRadius64;
  final double avatarRadius96;
  final double avatarRadius112;
  final double avatarRadius128;
  final double avatarLineHeight;
  final double avatarTracking;
  @override
  AppAvatarMetrics copyWith({
    TextLeadingDistribution? leadingDistribution,
    Alignment? contentAlignment,
    double? avatarFont28,
    double? avatarFont40,
    double? avatarFont48,
    double? avatarFont64,
    double? avatarFont96,
    double? avatarFont112,
    double? avatarFont128,
    double? avatarRadius28,
    double? avatarRadius40,
    double? avatarRadius48,
    double? avatarRadius64,
    double? avatarRadius96,
    double? avatarRadius112,
    double? avatarRadius128,
    double? avatarLineHeight,
    double? avatarTracking,
  }) => AppAvatarMetrics(
    leadingDistribution: leadingDistribution ?? this.leadingDistribution,
    contentAlignment: contentAlignment ?? this.contentAlignment,
    avatarFont28: avatarFont28 ?? this.avatarFont28,
    avatarFont40: avatarFont40 ?? this.avatarFont40,
    avatarFont48: avatarFont48 ?? this.avatarFont48,
    avatarFont64: avatarFont64 ?? this.avatarFont64,
    avatarFont96: avatarFont96 ?? this.avatarFont96,
    avatarFont112: avatarFont112 ?? this.avatarFont112,
    avatarFont128: avatarFont128 ?? this.avatarFont128,
    avatarRadius28: avatarRadius28 ?? this.avatarRadius28,
    avatarRadius40: avatarRadius40 ?? this.avatarRadius40,
    avatarRadius48: avatarRadius48 ?? this.avatarRadius48,
    avatarRadius64: avatarRadius64 ?? this.avatarRadius64,
    avatarRadius96: avatarRadius96 ?? this.avatarRadius96,
    avatarRadius112: avatarRadius112 ?? this.avatarRadius112,
    avatarRadius128: avatarRadius128 ?? this.avatarRadius128,
    avatarLineHeight: avatarLineHeight ?? this.avatarLineHeight,
    avatarTracking: avatarTracking ?? this.avatarTracking,
  );
  @override
  AppAvatarMetrics lerp(covariant AppAvatarMetrics? other, double t) {
    if (other == null) return this;
    return AppAvatarMetrics(
      leadingDistribution: t < 0.5
          ? leadingDistribution
          : other.leadingDistribution,
      contentAlignment: Alignment.lerp(
        contentAlignment,
        other.contentAlignment,
        t,
      )!,
      avatarFont28: lerpDouble(avatarFont28, other.avatarFont28, t)!,
      avatarFont40: lerpDouble(avatarFont40, other.avatarFont40, t)!,
      avatarFont48: lerpDouble(avatarFont48, other.avatarFont48, t)!,
      avatarFont64: lerpDouble(avatarFont64, other.avatarFont64, t)!,
      avatarFont96: lerpDouble(avatarFont96, other.avatarFont96, t)!,
      avatarFont112: lerpDouble(avatarFont112, other.avatarFont112, t)!,
      avatarFont128: lerpDouble(avatarFont128, other.avatarFont128, t)!,
      avatarRadius28: lerpDouble(avatarRadius28, other.avatarRadius28, t)!,
      avatarRadius40: lerpDouble(avatarRadius40, other.avatarRadius40, t)!,
      avatarRadius48: lerpDouble(avatarRadius48, other.avatarRadius48, t)!,
      avatarRadius64: lerpDouble(avatarRadius64, other.avatarRadius64, t)!,
      avatarRadius96: lerpDouble(avatarRadius96, other.avatarRadius96, t)!,
      avatarRadius112: lerpDouble(avatarRadius112, other.avatarRadius112, t)!,
      avatarRadius128: lerpDouble(avatarRadius128, other.avatarRadius128, t)!,
      avatarLineHeight: lerpDouble(
        avatarLineHeight,
        other.avatarLineHeight,
        t,
      )!,
      avatarTracking: lerpDouble(avatarTracking, other.avatarTracking, t)!,
    );
  }
}
