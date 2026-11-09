import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';

class AppAvatarTheme {
  const AppAvatarTheme({
    required this.extent,
    required this.contentAlignment,
    required this.tileRadius,
    required this.background,
    required this.foreground,
    required this.typography,
  });
  factory AppAvatarTheme.of(
    BuildContext context,
    AppAvatarSize size,
    AppAvatarShape shape,
  ) {
    final theme = Theme.of(context);
    final scale = ThemeExtensions.require<AppResponsive>(theme);
    final metrics = ThemeExtensions.require<AppAvatarMetrics>(theme);
    final (extent, fontSize, radius) = switch (size) {
      AppAvatarSize.extraSmall => (
        scale.avatarExtraSmall,
        metrics.avatarFont28,
        metrics.avatarRadius28,
      ),
      AppAvatarSize.small => (
        scale.avatarSmall,
        metrics.avatarFont40,
        metrics.avatarRadius40,
      ),
      AppAvatarSize.medium => (
        scale.avatarMedium,
        metrics.avatarFont48,
        metrics.avatarRadius48,
      ),
      AppAvatarSize.large => (
        scale.avatarLarge,
        metrics.avatarFont64,
        metrics.avatarRadius64,
      ),
      AppAvatarSize.profile => (
        scale.avatarProfile,
        metrics.avatarFont96,
        metrics.avatarRadius96,
      ),
      AppAvatarSize.portrait => (
        scale.avatarPortrait,
        metrics.avatarFont112,
        metrics.avatarRadius112,
      ),
      AppAvatarSize.hero => (
        scale.avatarHero,
        metrics.avatarFont128,
        metrics.avatarRadius128,
      ),
    };
    final foreground = switch (shape) {
      AppAvatarShape.tile => theme.colorScheme.onSurfaceVariant,
      AppAvatarShape.round => theme.colorScheme.primary,
    };
    return AppAvatarTheme(
      extent: extent,
      contentAlignment: metrics.contentAlignment,
      tileRadius: BorderRadius.circular(radius),
      background: theme.colorScheme.surfaceContainerHigh,
      foreground: foreground,
      typography: theme.textTheme.headlineLarge!.copyWith(
        fontSize: fontSize,
        height: metrics.avatarLineHeight,
        leadingDistribution: metrics.leadingDistribution,
        letterSpacing: metrics.avatarTracking,
      ),
    );
  }
  AppAvatarTheme copyWith({
    double? extent,
    Alignment? contentAlignment,
    BorderRadius? tileRadius,
    Color? background,
    Color? foreground,
    TextStyle? typography,
  }) => AppAvatarTheme(
    extent: extent ?? this.extent,
    contentAlignment: contentAlignment ?? this.contentAlignment,
    tileRadius: tileRadius ?? this.tileRadius,
    background: background ?? this.background,
    foreground: foreground ?? this.foreground,
    typography: typography ?? this.typography,
  );
  final Alignment contentAlignment;
  final double extent;
  final BorderRadius tileRadius;
  final Color background;
  final Color foreground;
  final TextStyle typography;
}
