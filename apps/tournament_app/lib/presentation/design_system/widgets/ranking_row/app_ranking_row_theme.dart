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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!;
    padding = desktop
        ? EdgeInsets.all(s.space24)
        : EdgeInsets.symmetric(vertical: s.space8);
    minHeight = desktop
        ? (featured ? rankFeaturedHeight : rankRegularHeight)
        : (featured ? r.avatarProfile : r.touchControlHeight);
    decoration = BoxDecoration(
      color: desktop ? (featured ? raised : surface) : background,
      borderRadius: radius,
      border: desktop && featured
          ? Border.all(
              color: t.colorScheme.primary,
              width: t.extension<AppBorderMetrics>()!.hairline,
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
      primary: t.textTheme.bodyMedium!.copyWith(
        fontSize: desktop
            ? (featured ? rankFeaturedName : homeMetaSize)
            : t.textTheme.bodyMedium!.fontSize,
        fontWeight: t.textTheme.labelLarge!.fontWeight,
      ),
      textGap: s.space4,
    );
    valueStyle = placement == AppRankValuePlacement.trailing
        ? t.textTheme.headlineLarge!.copyWith(
            fontSize: t.textTheme.titleLarge!.fontSize,
          )
        : featured
        ? t.textTheme.headlineLarge!.copyWith(
            fontSize: desktop
                ? rankFeaturedValue
                : t.textTheme.headlineLarge!.fontSize,
            color: t.colorScheme.primary,
          )
        : t.textTheme.labelLarge!.copyWith(
            color: t.colorScheme.onSurfaceVariant,
          );
    final painter = TextPainter(
      text: TextSpan(text: value, style: valueStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    valueWidth = math.max(s.space32, painter.width.ceilToDouble());
    painter.dispose();
  }
  late final EdgeInsets padding;
  late final double minHeight, valueWidth;
  late final BoxDecoration decoration;
  late final AppIdentityTheme identity;
  late final TextStyle valueStyle;
}
