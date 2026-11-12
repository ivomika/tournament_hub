import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/registration_fixture.dart';

final registrationErrorUseCase = WidgetbookUseCase(
  name: 'error',
  builder: RegistrationErrorUseCase.build,
);

abstract final class RegistrationErrorUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(RegistrationErrorUseCase),
    child: const RegistrationFixture(
      state: RegistrationScreenState(
        name: 'Иван',
        phase: RegistrationPhase.saveError,
      ),
    ),
  );
}
