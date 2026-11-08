import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/roster/roster_fixture.dart';

final rosterGuestsUseCase = WidgetbookUseCase(
  name: 'guests',
  builder: RosterGuestsUseCase.build,
);

abstract final class RosterGuestsUseCase {
  static Widget build(BuildContext context) => RosterFixture();
}
