import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class ResultsScreenTheme extends AppScreenLayoutTheme {
  ResultsScreenTheme.of(BuildContext context) : super.of(context) {
    final appearance = Theme.of(context),
        runtimeSpacing = appearance.extension<AppSpacing>()!;
    contextTitle = appearance.textTheme.headlineLarge!.copyWith(
      fontSize: desktop
          ? resultsContextTitleSize
          : appearance.textTheme.titleLarge!.fontSize,
    );
    linkPadding = EdgeInsets.symmetric(
      horizontal: runtimeSpacing.space24,
      vertical: runtimeSpacing.space4,
    );
  }
  late final TextStyle contextTitle;
  late final EdgeInsets linkPadding;
}
