import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

final revealedRosterUseCase = WidgetbookUseCase(
  name: 'revealed',
  builder: RevealedRosterUseCase.build,
);

abstract final class RevealedRosterUseCase {
  static Widget build(BuildContext context) =>
      const RosterFixture(revealed: true);
}
