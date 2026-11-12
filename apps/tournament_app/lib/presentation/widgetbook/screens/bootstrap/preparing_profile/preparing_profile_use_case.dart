import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapPreparingProfileUseCase = WidgetbookUseCase(
  name: 'preparing-profile',
  builder: BootstrapPreparingProfileUseCase.build,
);

abstract final class BootstrapPreparingProfileUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapPreparingProfileUseCase),
    child: const BootstrapFixture(
      phase: BootstrapPhase.loading,
      currentStep: BootstrapCurrentStep.profile,
    ),
  );
}
