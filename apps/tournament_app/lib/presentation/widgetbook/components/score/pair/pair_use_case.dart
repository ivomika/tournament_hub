import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/score_fixture.dart';

final scorePairUseCase = WidgetbookUseCase(
  name: 'pair',
  builder: ScorePairUseCase.build,
);

abstract final class ScorePairUseCase {
  static Widget build(BuildContext context) =>
      const ScoreFixture(kind: AppScoreKind.pair, sample: ScoreSample.initial);
}
