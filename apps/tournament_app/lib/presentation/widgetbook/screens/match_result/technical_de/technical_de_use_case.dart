import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/match_result_fixture.dart';

final matchResultTechnicalDeUseCase = WidgetbookUseCase(
  name: 'technical_de',
  builder: MatchResultTechnicalDeUseCase.build,
);

abstract final class MatchResultTechnicalDeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(MatchResultTechnicalDeUseCase),
    child: MatchResultFixture(
      key: const ValueKey(MatchResultSample.technicalDe),
      sample: MatchResultSample.technicalDe,
    ),
  );
}
