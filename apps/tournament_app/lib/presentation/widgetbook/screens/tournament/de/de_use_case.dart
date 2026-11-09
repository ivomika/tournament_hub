import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tournament_fixture.dart';

final tournamentDeUseCase = WidgetbookUseCase(
  name: 'de',
  builder: TournamentDeUseCase.build,
);

abstract final class TournamentDeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(TournamentDeUseCase),
    child: TournamentFixture(sample: TournamentSample.de),
  );
}
