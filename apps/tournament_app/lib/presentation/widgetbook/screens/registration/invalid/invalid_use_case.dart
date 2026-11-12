import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/registration_fixture.dart';

final registrationInvalidUseCase = WidgetbookUseCase(
  name: 'invalid',
  builder: RegistrationInvalidUseCase.build,
);

abstract final class RegistrationInvalidUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(RegistrationInvalidUseCase),
    child: const RegistrationFixture(
      state: RegistrationScreenState(
        name: '',
        phase: RegistrationPhase.invalidName,
      ),
    ),
  );
}
