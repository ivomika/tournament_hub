import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class HomeScreenTheme extends AppScreenLayoutTheme {
  HomeScreenTheme.of(BuildContext context) : super.of(context) {
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
  late final EdgeInsets heroPadding;
  late final double homeGap;
  late final TextStyle meta, stageStyle;
}
