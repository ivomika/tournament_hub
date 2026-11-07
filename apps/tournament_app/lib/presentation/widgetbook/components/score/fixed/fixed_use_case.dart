import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/score_fixture.dart';

final scoreFixedUseCase = WidgetbookUseCase(
  name: 'fixed',
  builder: ScoreFixedUseCase.build,
);

abstract final class ScoreFixedUseCase {
  static Widget build(BuildContext context) =>
      const ScoreFixture(kind: AppScoreKind.fixed, sample: ScoreSample.result);
}
