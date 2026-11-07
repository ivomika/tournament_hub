import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

final longRosterUseCase = WidgetbookUseCase(
  name: 'long',
  builder: LongRosterUseCase.build,
);

abstract final class LongRosterUseCase {
  static Widget build(BuildContext context) => const RosterFixture(long: true);
}
