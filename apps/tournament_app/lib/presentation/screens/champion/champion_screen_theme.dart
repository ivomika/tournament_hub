import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class ChampionScreenTheme extends AppScreenLayoutTheme {
  ChampionScreenTheme.of(BuildContext context) : super.of(context) {
    final appearance = Theme.of(context),
        runtimeSpacing = appearance.extension<AppSpacing>()!;
    final base = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.stacked,
      MediaQuery.sizeOf(context).width,
    );
    championIdentity = base.copyWith(
      avatar: base.avatar.copyWith(
        extent: desktop ? championDesktopAvatar : championMobileAvatar,
        typography: base.avatar.typography.copyWith(
          fontSize: desktop
              ? championDesktopNameSize
              : appearance.textTheme.displayLarge!.fontSize,
        ),
      ),
      primary: base.primary.copyWith(
        fontSize: desktop ? championDesktopNameSize : championMobileNameSize,
      ),
      secondary: desktop
          ? caption
          : appearance.textTheme.bodyMedium!.copyWith(
              fontSize: appearance.textTheme.titleLarge!.fontSize,
            ),
      leading: centerCross,
      textAlign: centerText,
      gap: runtimeSpacing.space16,
      textGap: runtimeSpacing.space16,
    );
    contextTitle = appearance.textTheme.headlineSmall!.copyWith(
      fontSize: championContextTitleSize,
    );
    contextAlignment = Alignment(topLeft.x, bottomAlign.y);
    heroGap = runtimeSpacing.space32;
    award = appearance.textTheme.labelLarge!.copyWith(
      color: appearance.colorScheme.primary,
    );
  }
  late final AppIdentityTheme championIdentity;
  late final double heroGap;
  late final TextStyle award, contextTitle;
  late final Alignment contextAlignment;
}
