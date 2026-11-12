import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/registration_fixture.dart';

final registrationSavingUseCase = WidgetbookUseCase(
  name: 'saving',
  builder: RegistrationSavingUseCase.build,
);

abstract final class RegistrationSavingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(RegistrationSavingUseCase),
    child: const RegistrationFixture(
      state: RegistrationScreenState(
        name: 'Иван',
        phase: RegistrationPhase.saving,
      ),
    ),
  );
}
