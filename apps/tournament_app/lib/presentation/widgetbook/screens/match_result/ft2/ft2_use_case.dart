import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultFt2UseCase = WidgetbookUseCase(
  name: 'ft2',
  builder: MatchResultFt2UseCase.build,
);

abstract final class MatchResultFt2UseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.ft2),
    sample: MatchResultSample.ft2,
  );
}
