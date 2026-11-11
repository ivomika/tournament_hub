import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapTimedOutUseCase = WidgetbookUseCase(
  name: 'timed-out',
  builder: BootstrapTimedOutUseCase.build,
);

abstract final class BootstrapTimedOutUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapTimedOutUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.timedOut,
    ),
  );
}
