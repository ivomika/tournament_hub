import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

final disabledRosterUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: DisabledRosterUseCase.build,
);

abstract final class DisabledRosterUseCase {
  static Widget build(BuildContext context) =>
      const RosterFixture(disabled: true);
}
