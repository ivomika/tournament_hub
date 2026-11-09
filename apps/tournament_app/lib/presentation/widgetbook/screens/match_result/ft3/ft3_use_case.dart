import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultFt3UseCase = WidgetbookUseCase(
  name: 'ft3',
  builder: MatchResultFt3UseCase.build,
);

abstract final class MatchResultFt3UseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.ft3),
    sample: MatchResultSample.ft3,
  );
}
