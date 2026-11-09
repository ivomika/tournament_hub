import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_state.dart';

final utilityErrorUseCase = WidgetbookUseCase(
  name: 'error',
  builder: UtilityErrorUseCase.build,
);

abstract final class UtilityErrorUseCase {
  static void back() {}
  static void retry() {}
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(UtilityErrorUseCase),
    child: UtilityScreen(
      state: const UtilityScreenState(phase: UtilityPhase.error),
      onBack: back,
      onRetry: retry,
    ),
  );
}
