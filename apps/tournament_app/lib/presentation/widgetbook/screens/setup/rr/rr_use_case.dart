import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/setup_fixture.dart';

final setupRrUseCase = WidgetbookUseCase(
  name: 'rr',
  builder: SetupRrUseCase.build,
);

abstract final class SetupRrUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(SetupRrUseCase),
    child: SetupFixture(format: TournamentFormatDisplay.roundRobin),
  );
}
