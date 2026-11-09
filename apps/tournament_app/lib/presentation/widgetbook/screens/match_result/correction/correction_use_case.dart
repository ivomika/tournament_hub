import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultCorrectionUseCase = WidgetbookUseCase(
  name: 'correction',
  builder: MatchResultCorrectionUseCase.build,
);

abstract final class MatchResultCorrectionUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(MatchResultCorrectionUseCase),
    child: MatchResultFixture(
      key: const ValueKey(MatchResultSample.correction),
      sample: MatchResultSample.correction,
    ),
  );
}
