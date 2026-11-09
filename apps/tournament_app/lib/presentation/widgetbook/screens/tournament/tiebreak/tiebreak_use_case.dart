import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tournament_fixture.dart';

final tournamentTiebreakUseCase = WidgetbookUseCase(
  name: 'tiebreak',
  builder: TournamentTiebreakUseCase.build,
);

abstract final class TournamentTiebreakUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(TournamentTiebreakUseCase),
    child: TournamentFixture(sample: TournamentSample.tiebreak),
  );
}
