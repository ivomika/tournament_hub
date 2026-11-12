import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapProfileUnavailableUseCase = WidgetbookUseCase(
  name: 'profile-unavailable',
  builder: BootstrapProfileUnavailableUseCase.build,
);

abstract final class BootstrapProfileUnavailableUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapProfileUnavailableUseCase),
    child: const BootstrapFixture(
      phase: BootstrapPhase.error,
      problem: BootstrapProblem.profileUnavailable,
    ),
  );
}
