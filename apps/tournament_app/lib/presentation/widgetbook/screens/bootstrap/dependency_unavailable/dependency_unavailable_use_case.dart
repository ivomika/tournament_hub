import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapDependencyUnavailableUseCase = WidgetbookUseCase(
  name: 'dependency-unavailable',
  builder: BootstrapDependencyUnavailableUseCase.build,
);

abstract final class BootstrapDependencyUnavailableUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapDependencyUnavailableUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.dependencyUnavailable,
    ),
  );
}
