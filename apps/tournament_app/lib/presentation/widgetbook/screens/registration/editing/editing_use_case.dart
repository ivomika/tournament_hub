import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/registration_fixture.dart';

final registrationEditingUseCase = WidgetbookUseCase(
  name: 'editing',
  builder: RegistrationEditingUseCase.build,
);

abstract final class RegistrationEditingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(RegistrationEditingUseCase),
    child: const RegistrationFixture(
      state: RegistrationScreenState(
        name: 'Иван',
        phase: RegistrationPhase.editing,
      ),
    ),
  );
}
