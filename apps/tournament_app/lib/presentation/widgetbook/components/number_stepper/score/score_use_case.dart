import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/widgetbook/components/number_stepper/stepper_fixture.dart';

final stepperScoreUseCase = WidgetbookUseCase(
  name: 'score',
  builder: StepperScoreUseCase.build,
);

abstract final class StepperScoreUseCase {
  static Widget build(BuildContext context) =>
      const StepperFixture(kind: AppStepperKind.input);
}
