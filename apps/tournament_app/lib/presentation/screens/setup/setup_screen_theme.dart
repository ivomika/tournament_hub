import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class SetupScreenTheme extends AppScreenLayoutTheme {
  SetupScreenTheme.of(BuildContext context) : super.of(context) {
    final runtimeSpacing = Theme.of(context).extension<AppSpacing>()!;
    formatHeight = utilityHeight * textScaleFactor;
    panePadding = EdgeInsets.all(runtimeSpacing.space24);
    layoutGap = desktop ? runtimeSpacing.space20 : runtimeSpacing.space24;
    formatStyle = desktop ? Theme.of(context).textTheme.displayLarge! : heading;
  }
  late final EdgeInsets panePadding;
  late final double layoutGap, formatHeight;
  late final TextStyle formatStyle;
}
