import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapPreparingNavigationUseCase = WidgetbookUseCase(
  name: 'preparing-navigation',
  builder: BootstrapPreparingNavigationUseCase.build,
);

abstract final class BootstrapPreparingNavigationUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapPreparingNavigationUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.loading,
      currentStep: BootstrapCurrentStep.navigation,
    ),
  );
}
