import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_state.dart';

final utilityLoadingUseCase = WidgetbookUseCase(
  name: 'loading',
  builder: UtilityLoadingUseCase.build,
);

abstract final class UtilityLoadingUseCase {
  static void back() {}
  static Widget build(BuildContext context) => UtilityScreen(
    state: const UtilityScreenState(phase: UtilityPhase.loading),
    onBack: back,
    onRetry: null,
  );
}
