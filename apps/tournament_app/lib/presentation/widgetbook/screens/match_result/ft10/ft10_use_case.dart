import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultFt10UseCase = WidgetbookUseCase(
  name: 'ft10',
  builder: MatchResultFt10UseCase.build,
);

abstract final class MatchResultFt10UseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.ft10),
    sample: MatchResultSample.ft10,
  );
}
