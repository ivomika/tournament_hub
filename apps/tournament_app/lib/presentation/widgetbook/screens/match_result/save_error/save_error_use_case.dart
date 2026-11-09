import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultSaveErrorUseCase = WidgetbookUseCase(
  name: 'save_error',
  builder: MatchResultSaveErrorUseCase.build,
);

abstract final class MatchResultSaveErrorUseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.error),
    sample: MatchResultSample.error,
  );
}
