import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

enum AppRankValuePlacement { leading, trailing }

class AppRankingRowTheme extends AppScreenLayoutTheme {
  AppRankingRowTheme.of(
    BuildContext context,
    bool featured,
    AppRankValuePlacement placement,
    String value,
  ) : super.of(context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!;
    padding = desktop
        ? EdgeInsets.all(runtimeSpacing.space24)
        : EdgeInsets.symmetric(vertical: runtimeSpacing.space8);
    minHeight = _resolveHeight(featured, runtimeResponsive);
    decoration = BoxDecoration(
      color: _resolveBackground(featured),
      borderRadius: radius,
      border: desktop && featured
          ? Border.all(
              color: runtimeTheme.colorScheme.primary,
              width: runtimeTheme.extension<AppBorderMetrics>()!.hairline,
            )
          : null,
    );
    final base = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.inline,
      MediaQuery.sizeOf(context).width,
    );
    final avatar = AppAvatarTheme.of(
      context,
      featured ? AppAvatarSize.profile : AppAvatarSize.medium,
      AppAvatarShape.tile,
    );
    identity = base.copyWith(
      avatar: avatar,
      primary: runtimeTheme.textTheme.bodyMedium!.copyWith(
        fontSize: _resolveNameSize(featured, runtimeTheme),
        fontWeight: runtimeTheme.textTheme.labelLarge!.fontWeight,
      ),
      textGap: runtimeSpacing.space4,
    );
    valueStyle = _resolveValueStyle(placement, featured, runtimeTheme);
    final painter = TextPainter(
      text: TextSpan(text: value, style: valueStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    valueWidth = math.max(runtimeSpacing.space32, painter.width.ceilToDouble());
    painter.dispose();
  }

  double _resolveHeight(bool featured, AppResponsive responsive) {
    if (desktop) {
      if (featured) {
        return rankFeaturedHeight;
      } else {
        return rankRegularHeight;
      }
    }
    if (featured) {
      return responsive.avatarProfile;
    } else {
      return responsive.touchControlHeight;
    }
  }

  Color _resolveBackground(bool featured) {
    if (!desktop) return background;
    if (featured) {
      return raised;
    } else {
      return surface;
    }
  }

  double? _resolveNameSize(bool featured, ThemeData theme) {
    if (desktop) {
      if (featured) {
        return rankFeaturedName;
      } else {
        return homeMetaSize;
      }
    }
    return theme.textTheme.bodyMedium!.fontSize;
  }

  TextStyle _resolveValueStyle(
    AppRankValuePlacement placement,
    bool featured,
    ThemeData runtimeTheme,
  ) {
    if (placement == AppRankValuePlacement.trailing) {
      return runtimeTheme.textTheme.headlineLarge!.copyWith(
        fontSize: runtimeTheme.textTheme.titleLarge!.fontSize,
      );
    }
    if (featured) {
      return runtimeTheme.textTheme.headlineLarge!.copyWith(
        fontSize: desktop
            ? rankFeaturedValue
            : runtimeTheme.textTheme.headlineLarge!.fontSize,
        color: runtimeTheme.colorScheme.primary,
      );
    }
    return runtimeTheme.textTheme.labelLarge!.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
  }

  late final EdgeInsets padding;
  late final double minHeight, valueWidth;
  late final BoxDecoration decoration;
  late final AppIdentityTheme identity;
  late final TextStyle valueStyle;
}
