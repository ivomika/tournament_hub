import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';

class TournamentScreenTheme extends AppScreenLayoutTheme {
  TournamentScreenTheme.of(BuildContext context) : super.of(context) {
    final appearance = Theme.of(context);
    final base = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.stacked,
      MediaQuery.sizeOf(context).width,
    );
    currentIdentity = base.copyWith(
      avatar: base.avatar.copyWith(
        extent: desktop ? matchDesktopAvatar : matchMobileAvatar,
      ),
      leading: centerCross,
      textAlign: centerText,
      primary: base.primary.copyWith(
        fontSize: desktop
            ? matchDesktopNameSize
            : (MediaQuery.sizeOf(context).width * matchMobileNameFactor).clamp(
                appearance.textTheme.bodyMedium!.fontSize!,
                appearance.textTheme.titleLarge!.fontSize!,
              ),
      ),
    );
    final next = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.inline,
      MediaQuery.sizeOf(context).width,
    );
    nextIdentity = next.copyWith(
      avatar: next.avatar.copyWith(
        extent: desktop
            ? appearance.extension<AppResponsive>()!.avatarMedium
            : appearance.extension<AppResponsive>()!.avatarSmall,
      ),
      primary: appearance.textTheme.bodyMedium!.copyWith(
        fontSize: desktop
            ? appearance.textTheme.bodyMedium!.fontSize
            : appearance.textTheme.labelLarge!.fontSize,
        fontWeight: appearance.textTheme.labelLarge!.fontWeight,
      ),
    );
    points = appearance.textTheme.bodySmall!.copyWith(
      color: appearance.colorScheme.primary,
    );
  }
  late final AppIdentityTheme currentIdentity, nextIdentity;
  late final TextStyle points;
}
