import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class SetupScreenTheme extends AppScreenLayoutTheme {
  SetupScreenTheme.of(BuildContext context) : super.of(context) {
    final s = Theme.of(context).extension<AppSpacing>()!;
    panePadding = EdgeInsets.all(s.space24);
    layoutGap = desktop ? s.space20 : s.space24;
    formatStyle = desktop ? Theme.of(context).textTheme.displayLarge! : heading;
  }
  late final EdgeInsets panePadding;
  late final double layoutGap;
  late final TextStyle formatStyle;
}
