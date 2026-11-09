import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class ChampionScreenTheme extends AppScreenLayoutTheme {
  ChampionScreenTheme.of(BuildContext context) : super.of(context) {
    final t = Theme.of(context), s = t.extension<AppSpacing>()!;
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
              : t.textTheme.displayLarge!.fontSize,
        ),
      ),
      primary: base.primary.copyWith(
        fontSize: desktop ? championDesktopNameSize : championMobileNameSize,
      ),
      secondary: desktop
          ? caption
          : t.textTheme.bodyMedium!.copyWith(
              fontSize: t.textTheme.titleLarge!.fontSize,
            ),
      leading: centerCross,
      textAlign: centerText,
      gap: s.space16,
      textGap: s.space16,
    );
    contextTitle=t.textTheme.headlineSmall!.copyWith(fontSize:championContextTitleSize);
contextAlignment=Alignment(topLeft.x,bottomAlign.y);
heroGap = s.space32;
    award = t.textTheme.labelLarge!.copyWith(color: t.colorScheme.primary);
  }
  late final AppIdentityTheme championIdentity;
  late final double heroGap;
  late final TextStyle award,contextTitle;
late final Alignment contextAlignment;
}
