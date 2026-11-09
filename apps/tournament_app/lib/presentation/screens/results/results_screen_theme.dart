import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class ResultsScreenTheme extends AppScreenLayoutTheme {
  ResultsScreenTheme.of(BuildContext context) : super.of(context) {
    final t = Theme.of(context), s = t.extension<AppSpacing>()!;
    contextTitle = t.textTheme.headlineLarge!.copyWith(
      fontSize: desktop
          ? resultsContextTitleSize
          : t.textTheme.titleLarge!.fontSize,
    );
    linkPadding = EdgeInsets.symmetric(
      horizontal: s.space24,
      vertical: s.space4,
    );
  }
  late final TextStyle contextTitle;
  late final EdgeInsets linkPadding;
}
