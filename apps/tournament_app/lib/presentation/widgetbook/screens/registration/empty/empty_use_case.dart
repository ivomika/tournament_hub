import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/registration_fixture.dart';

final registrationEmptyUseCase = WidgetbookUseCase(
  name: 'empty',
  builder: RegistrationEmptyUseCase.build,
);

abstract final class RegistrationEmptyUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(RegistrationEmptyUseCase),
    child: const RegistrationFixture(
      state: RegistrationScreenState(
        name: '',
        phase: RegistrationPhase.editing,
      ),
    ),
  );
}
