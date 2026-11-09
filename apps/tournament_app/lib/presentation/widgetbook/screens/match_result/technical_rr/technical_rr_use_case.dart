import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultTechnicalRrUseCase = WidgetbookUseCase(
  name: 'technical_rr',
  builder: MatchResultTechnicalRrUseCase.build,
);

abstract final class MatchResultTechnicalRrUseCase {
  static Widget build(BuildContext context) => MatchResultFixture(
    key: const ValueKey(MatchResultSample.technicalRr),
    sample: MatchResultSample.technicalRr,
  );
}
