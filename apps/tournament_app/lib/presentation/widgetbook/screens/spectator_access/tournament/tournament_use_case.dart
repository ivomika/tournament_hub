import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/spectator_access_fixture.dart';

final spectatorAccessTournamentUseCase = WidgetbookUseCase(
  name: 'tournament',
  builder: SpectatorAccessTournamentUseCase.build,
);

abstract final class SpectatorAccessTournamentUseCase {
  static Widget build(BuildContext context) =>
      SpectatorAccessFixture(address: true);
}
