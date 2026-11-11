import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapIncompatibleVersionUseCase = WidgetbookUseCase(
  name: 'incompatible-version',
  builder: BootstrapIncompatibleVersionUseCase.build,
);

abstract final class BootstrapIncompatibleVersionUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapIncompatibleVersionUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.incompatibleVersion,
      onRetry: null,
    ),
  );
}
