import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapRestartRequiredUseCase = WidgetbookUseCase(
  name: 'restart-required',
  builder: BootstrapRestartRequiredUseCase.build,
);

abstract final class BootstrapRestartRequiredUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapRestartRequiredUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.restartRequired,
      onRetry: null,
    ),
  );
}
