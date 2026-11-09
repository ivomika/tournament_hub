import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tournament_fixture.dart';

final tournamentTiebreakUseCase = WidgetbookUseCase(
  name: 'tiebreak',
  builder: TournamentTiebreakUseCase.build,
);

abstract final class TournamentTiebreakUseCase {
  static Widget build(BuildContext context) =>
      TournamentFixture(sample: TournamentSample.tiebreak);
}
