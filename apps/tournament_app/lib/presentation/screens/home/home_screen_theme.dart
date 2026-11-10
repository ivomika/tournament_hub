import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class HomeScreenTheme extends AppScreenLayoutTheme {
  HomeScreenTheme.of(BuildContext context) : super.of(context) {
    final s = Theme.of(context).extension<AppSpacing>()!;
    emptyPadding = EdgeInsets.all(desktop ? simplePadding : s.space0);
    emptyActionPadding = EdgeInsets.only(
      left: desktop ? s.space32 : s.space0,
      right: desktop ? s.space32 : s.space0,
      bottom: desktop ? s.space32 : s.space0,
    );
    ornamentLine = s.space48;
    ornamentColor = Theme.of(context).colorScheme.outline;
    trophySize = AppIconSize.large;
    homeGap = desktop
        ? Theme.of(context).extension<AppSpacing>()!.space20
        : gap;
    meta = body.copyWith(fontSize: homeMetaSize);
    stageStyle = Theme.of(context).textTheme.bodyLarge!
        .copyWith(color: muted.color);
    heroPadding = EdgeInsets.all(
      Theme.of(context).extension<AppSpacing>()!.space48,
    );
  }
  late final EdgeInsets heroPadding, emptyPadding, emptyActionPadding;
  late final double ornamentLine;
  late final Color ornamentColor;
  late final AppIconSize trophySize;
  late final double homeGap;
  late final TextStyle meta, stageStyle;
}
