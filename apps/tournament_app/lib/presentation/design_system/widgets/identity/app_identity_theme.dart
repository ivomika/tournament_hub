import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';

enum AppIdentityKind { character, participant }

enum AppIdentityLayout { inline, stacked }

class AppIdentityTheme {
  const AppIdentityTheme({
    required this.avatar,
    required this.size,
    required this.shape,
    required this.primary,
    required this.secondary,
    required this.gap,
    required this.textGap,
    required this.leading,
    required this.stretch,
    required this.center,
    required this.textAlign,
    this.fillText = false,
    this.exactLineBoxes = false,
  });
  factory AppIdentityTheme.of(
    BuildContext context,
    AppIdentityKind kind,
    AppIdentityLayout layout,
    double availableWidth, {
    AppAvatarSize? avatarSize,
  }) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeIdentityMetrics = runtimeTheme.extension<AppIdentityMetrics>()!,
        runtimeAvatarMetrics = runtimeTheme.extension<AppAvatarMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        type = runtimeTheme.extension<AppTypeRoles>()!,
        control = runtimeTheme.extension<AppControlMetrics>()!;
    final stack = layout == AppIdentityLayout.stacked,
        participant = kind == AppIdentityKind.participant;
    final size = avatarSize ?? _resolveAvatarSize(participant, stack);
    final shape = participant && !stack
        ? AppAvatarShape.round
        : AppAvatarShape.tile;
    final source = AppAvatarTheme.of(context, size, shape);
    final compact =
        avatarSize == AppAvatarSize.extraSmall ||
        avatarSize == AppAvatarSize.small;
    final primary = _resolvePrimary(
      compact,
      avatarSize,
      stack,
      participant,
      availableWidth,
      runtimeTheme,
      type,
      runtimeIdentityMetrics,
    );
    final avatar = _resolveAvatar(
      participant,
      stack,
      source,
      runtimeTheme,
      type,
      runtimeIdentityMetrics,
      runtimeAvatarMetrics,
      runtimeResponsive,
    );
    return AppIdentityTheme(
      avatar: avatar,
      size: size,
      shape: shape,
      primary: primary.copyWith(color: runtimeTheme.colorScheme.onSurface),
      secondary: type.interfaceStyle(
        (stack
                ? runtimeTheme.textTheme.labelLarge!
                : runtimeTheme.textTheme.bodySmall!)
            .copyWith(
              color: runtimeTheme.colorScheme.onSurfaceVariant,
              fontWeight: control.regularWeight,
              fontVariations: control.regularVariations,
              letterSpacing: type.normalTracking,
            ),
      ),
      gap: _resolveGap(participant, stack, runtimeSpacing),
      textGap: runtimeSpacing.space8,
      leading: runtimeIdentityMetrics.leading,
      stretch: runtimeIdentityMetrics.stretch,
      center: control.centerCross,
      textAlign: runtimeIdentityMetrics.textLeading,
    );
  }

  static AppAvatarSize _resolveAvatarSize(bool participant, bool stack) {
    if (participant) {
      if (stack) {
        return AppAvatarSize.large;
      } else {
        return AppAvatarSize.medium;
      }
    }
    if (stack) {
      return AppAvatarSize.portrait;
    } else {
      return AppAvatarSize.large;
    }
  }

  static double _resolveGap(bool participant, bool stack, AppSpacing spacing) {
    if (participant && stack) return spacing.space16;
    if (stack) return spacing.space8;
    return spacing.space16;
  }

  static TextStyle _resolvePrimary(
    bool compact,
    AppAvatarSize? avatarSize,
    bool stack,
    bool participant,
    double availableWidth,
    ThemeData runtimeTheme,
    AppTypeRoles type,
    AppIdentityMetrics runtimeIdentityMetrics,
  ) {
    if (compact) return type.interfaceStyle(runtimeTheme.textTheme.labelLarge!);
    if (avatarSize == AppAvatarSize.large && stack) {
      return runtimeTheme.textTheme.headlineLarge!.copyWith(
        fontSize: runtimeIdentityMetrics.cardNameSize,
        height: runtimeIdentityMetrics.stackedLine,
        letterSpacing: type.normalTracking,
      );
    }
    if (participant) {
      return type.interfaceStyle(
        runtimeTheme.textTheme.bodyMedium!.copyWith(
          fontSize: stack
              ? runtimeIdentityMetrics.cardNameSize
              : runtimeTheme.textTheme.bodyMedium!.fontSize,
          fontWeight: runtimeTheme.textTheme.labelLarge!.fontWeight,
          height: runtimeIdentityMetrics.participantLine,
          letterSpacing: type.normalTracking,
        ),
      );
    }
    return runtimeTheme.textTheme.headlineLarge!.copyWith(
      fontSize: stack
          ? (availableWidth * runtimeIdentityMetrics.containerFactor).clamp(
              runtimeTheme.textTheme.labelLarge!.fontSize!,
              runtimeTheme.textTheme.titleLarge!.fontSize!,
            )
          : runtimeTheme.textTheme.titleLarge!.fontSize,
      height: stack
          ? runtimeIdentityMetrics.stackedLine
          : runtimeTheme.textTheme.headlineLarge!.height,
      letterSpacing: type.normalTracking,
    );
  }

  static AppAvatarTheme _resolveAvatar(
    bool participant,
    bool stack,
    AppAvatarTheme source,
    ThemeData runtimeTheme,
    AppTypeRoles type,
    AppIdentityMetrics runtimeIdentityMetrics,
    AppAvatarMetrics runtimeAvatarMetrics,
    AppResponsive runtimeResponsive,
  ) {
    if (!participant) return source;
    return AppAvatarTheme(
      extent: stack
          ? runtimeResponsive.avatarLarge
          : runtimeResponsive.avatarMedium,
      contentAlignment: runtimeAvatarMetrics.contentAlignment,
      tileRadius: BorderRadius.circular(
        stack
            ? runtimeIdentityMetrics.cardAvatarRadius
            : runtimeAvatarMetrics.avatarRadius48,
      ),
      background: source.background,
      foreground: runtimeTheme.colorScheme.onSurfaceVariant,
      typography: type.interfaceStyle(
        runtimeTheme.textTheme.bodyMedium!.copyWith(
          fontSize: stack
              ? runtimeIdentityMetrics.cardAvatarFont
              : runtimeTheme.textTheme.bodyMedium!.fontSize,
          fontWeight: runtimeTheme.textTheme.labelLarge!.fontWeight,
          height: runtimeAvatarMetrics.avatarLineHeight,
          letterSpacing: type.normalTracking,
          leadingDistribution: runtimeAvatarMetrics.leadingDistribution,
        ),
      ),
    );
  }

  AppIdentityTheme copyWith({
    AppAvatarTheme? avatar,
    AppAvatarSize? size,
    AppAvatarShape? shape,
    TextStyle? primary,
    TextStyle? secondary,
    double? gap,
    double? textGap,
    CrossAxisAlignment? leading,
    CrossAxisAlignment? stretch,
    CrossAxisAlignment? center,
    TextAlign? textAlign,
    bool? fillText,
    bool? exactLineBoxes,
  }) => AppIdentityTheme(
    avatar: avatar ?? this.avatar,
    size: size ?? this.size,
    shape: shape ?? this.shape,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    gap: gap ?? this.gap,
    textGap: textGap ?? this.textGap,
    leading: leading ?? this.leading,
    stretch: stretch ?? this.stretch,
    center: center ?? this.center,
    textAlign: textAlign ?? this.textAlign,
    fillText: fillText ?? this.fillText,
    exactLineBoxes: exactLineBoxes ?? this.exactLineBoxes,
  );
  final AppAvatarTheme avatar;
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final TextStyle primary, secondary;
  final double gap, textGap;
  final CrossAxisAlignment leading, stretch, center;
  final TextAlign textAlign;
  final bool fillText;
  final bool exactLineBoxes;
}
