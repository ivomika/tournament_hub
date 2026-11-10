import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_state.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

final utilityDistributionUseCase = WidgetbookUseCase(
  name: 'distribution',
  builder: UtilityDistributionUseCase.build,
);

abstract final class UtilityDistributionUseCase {
  static void action() {}
  static Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return UtilityScreen(
      state: UtilityScreenState(
        phase: UtilityPhase.loading,
        title: l.screenDistribution,
        heading: l.screenWhoCharacter,
        accent: '',
        note: l.screenNoRepeats,
        progressLabel: l.screenDealing,
      ),
      onBack: action,
      onRetry: null,
    );
  }
}
