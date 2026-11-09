import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultFt1UseCase = WidgetbookUseCase(
  name: 'ft1',
  builder: MatchResultFt1UseCase.build,
);

abstract final class MatchResultFt1UseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.choice),
    sample: MatchResultSample.choice,
  );
}
