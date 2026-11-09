import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tournament_fixture.dart';

final tournamentSeUseCase = WidgetbookUseCase(
  name: 'se',
  builder: TournamentSeUseCase.build,
);

abstract final class TournamentSeUseCase {
  static Widget build(BuildContext context) =>
      TournamentFixture(sample: TournamentSample.se);
}
