import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tournament_fixture.dart';

final tournamentRrUseCase = WidgetbookUseCase(
  name: 'rr',
  builder: TournamentRrUseCase.build,
);

abstract final class TournamentRrUseCase {
  static Widget build(BuildContext context) =>
      TournamentFixture(sample: TournamentSample.rr);
}
