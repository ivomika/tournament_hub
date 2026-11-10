import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class AppHistoryEntryTheme extends AppScreenLayoutTheme {
  AppHistoryEntryTheme.of(BuildContext context, bool prominent)
    : super.of(context) {
    final runtimeSpacing = Theme.of(context).extension<AppSpacing>()!,
        runtimeBorderMetrics = Theme.of(context).extension<AppBorderMetrics>()!;
    minHeight = _resolveHeight(prominent);
    padding = EdgeInsets.symmetric(
      horizontal: desktop ? runtimeSpacing.space32 : zero,
      vertical: runtimeSpacing.space24,
    );
    decoration = BoxDecoration(
      color: desktop ? surface : background,
      borderRadius: desktop ? radius : null,
      border: desktop
          ? null
          : Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: runtimeBorderMetrics.hairline,
              ),
            ),
    );
    final base = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.inline,
      MediaQuery.sizeOf(context).width,
      avatarSize: desktop ? AppAvatarSize.medium : null,
    );
    identity = desktop
        ? base.copyWith(primary: base.primary.copyWith(fontSize: homeMetaSize))
        : base;
  }
  double _resolveHeight(bool prominent) {
    if (!desktop) return zero;
    if (prominent) {
      return historyProminentHeight;
    } else {
      return historyCardHeight;
    }
  }

  late final double minHeight;
  late final EdgeInsets padding;
  late final BoxDecoration decoration;
  late final AppIdentityTheme identity;
}
