import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/setup_fixture.dart';

final setupDeUseCase = WidgetbookUseCase(
  name: 'de',
  builder: SetupDeUseCase.build,
);

abstract final class SetupDeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(SetupDeUseCase),
    child: SetupFixture(format: TournamentFormatDisplay.doubleElimination),
  );
}
