import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/setup_fixture.dart';

final setupSeUseCase = WidgetbookUseCase(
  name: 'se',
  builder: SetupSeUseCase.build,
);

abstract final class SetupSeUseCase {
  static Widget build(BuildContext context) =>
      SetupFixture(format: TournamentFormatDisplay.singleElimination);
}
