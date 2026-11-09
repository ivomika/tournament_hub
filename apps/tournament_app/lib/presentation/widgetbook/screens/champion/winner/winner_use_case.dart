import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/champion/champion_fixture.dart';

final championWinnerUseCase = WidgetbookUseCase(
  name: 'winner',
  builder: ChampionWinnerUseCase.build,
);

abstract final class ChampionWinnerUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ChampionWinnerUseCase),
    child: ChampionFixture(),
  );
}
