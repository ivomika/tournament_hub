import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapRetryingNavigationUseCase = WidgetbookUseCase(
  name: 'retrying-navigation',
  builder: BootstrapRetryingNavigationUseCase.build,
);

abstract final class BootstrapRetryingNavigationUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapRetryingNavigationUseCase),
    child: BootstrapFixture(
      phase: BootstrapPhase.retrying,
      currentStep: BootstrapCurrentStep.navigation,
    ),
  );
}
