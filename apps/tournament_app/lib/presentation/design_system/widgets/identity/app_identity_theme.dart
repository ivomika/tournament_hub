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
  });
  factory AppIdentityTheme.of(
    BuildContext context,
    AppIdentityKind kind,
    AppIdentityLayout layout,
    double availableWidth,
  ) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppIdentityMetrics>()!,
        a = t.extension<AppAvatarMetrics>()!,
        r = t.extension<AppResponsive>()!,
        type = t.extension<AppTypeRoles>()!,
        control = t.extension<AppControlMetrics>()!;
    final stack = layout == AppIdentityLayout.stacked,
        participant = kind == AppIdentityKind.participant;
    final size = participant
        ? (stack ? AppAvatarSize.large : AppAvatarSize.medium)
        : (stack ? AppAvatarSize.portrait : AppAvatarSize.large);
    final shape = participant && !stack
        ? AppAvatarShape.round
        : AppAvatarShape.tile;
    final source = AppAvatarTheme.of(context, size, shape);
    final primary = participant
        ? type.interfaceStyle(
            t.textTheme.bodyMedium!.copyWith(
              fontSize: stack
                  ? m.cardNameSize
                  : t.textTheme.bodyMedium!.fontSize,
              fontWeight: t.textTheme.labelLarge!.fontWeight,
              height: m.participantLine,
              letterSpacing: type.normalTracking,
            ),
          )
        : t.textTheme.headlineLarge!.copyWith(
            fontSize: stack
                ? (availableWidth * m.containerFactor).clamp(
                    t.textTheme.labelLarge!.fontSize!,
                    t.textTheme.titleLarge!.fontSize!,
                  )
                : t.textTheme.titleLarge!.fontSize,
            height: stack ? m.stackedLine : t.textTheme.headlineLarge!.height,
            letterSpacing: type.normalTracking,
          );
    final avatar = participant
        ? AppAvatarTheme(
            extent: stack ? r.avatarLarge : r.avatarMedium,
            contentAlignment: a.contentAlignment,
            tileRadius: BorderRadius.circular(
              stack ? m.cardAvatarRadius : a.avatarRadius48,
            ),
            background: source.background,
            foreground: t.colorScheme.onSurfaceVariant,
            typography: type.interfaceStyle(
              t.textTheme.bodyMedium!.copyWith(
                fontSize: stack
                    ? m.cardAvatarFont
                    : t.textTheme.bodyMedium!.fontSize,
                fontWeight: t.textTheme.labelLarge!.fontWeight,
                height: a.avatarLineHeight,
                letterSpacing: type.normalTracking,
                leadingDistribution: a.leadingDistribution,
              ),
            ),
          )
        : source;
    return AppIdentityTheme(
      avatar: avatar,
      size: size,
      shape: shape,
      primary: primary.copyWith(color: t.colorScheme.onSurface),
      secondary: type.interfaceStyle(
        (stack ? t.textTheme.labelLarge! : t.textTheme.bodySmall!).copyWith(
          color: t.colorScheme.onSurfaceVariant,
          fontWeight: control.regularWeight,
          fontVariations: control.regularVariations,
          letterSpacing: type.normalTracking,
        ),
      ),
      gap: participant && stack
          ? s.space24
          : stack
          ? s.space8
          : s.space16,
      textGap: s.space8,
      leading: m.leading,
      stretch: m.stretch,
      center: control.centerCross,
      textAlign: m.textLeading,
    );
  }
  final AppAvatarTheme avatar;
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final TextStyle primary, secondary;
  final double gap, textGap;
  final CrossAxisAlignment leading, stretch, center;
  final TextAlign textAlign;
}
