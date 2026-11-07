import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

final defaultRosterUseCase = WidgetbookUseCase(
  name: 'default',
  builder: DefaultRosterUseCase.build,
);

abstract final class DefaultRosterUseCase {
  static Widget build(BuildContext context) => const RosterFixture();
}
