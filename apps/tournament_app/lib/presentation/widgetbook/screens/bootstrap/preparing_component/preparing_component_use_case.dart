import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapPreparingComponentUseCase = WidgetbookUseCase(
  name: 'preparing-component',
  builder: BootstrapPreparingComponentUseCase.build,
);

abstract final class BootstrapPreparingComponentUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapPreparingComponentUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.loading,
      currentStep: BootstrapCurrentStep.component,
    ),
  );
}
