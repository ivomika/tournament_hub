import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapCancelledUseCase = WidgetbookUseCase(
  name: 'cancelled',
  builder: BootstrapCancelledUseCase.build,
);

abstract final class BootstrapCancelledUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapCancelledUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.cancelled,
      onRetry: null,
    ),
  );
}
