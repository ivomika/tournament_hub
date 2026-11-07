import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

final focusRosterUseCase = WidgetbookUseCase(
  name: 'focus',
  builder: FocusRosterUseCase.build,
);

abstract final class FocusRosterUseCase {
  static Widget build(BuildContext context) =>
      const RosterFixture(focused: true);
}
