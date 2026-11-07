import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/score_fixture.dart';

final scoreTwoDigitsUseCase = WidgetbookUseCase(
  name: 'two_digits',
  builder: ScoreTwoDigitsUseCase.build,
);

abstract final class ScoreTwoDigitsUseCase {
  static Widget build(BuildContext context) => const ScoreFixture(
    kind: AppScoreKind.pair,
    sample: ScoreSample.twoDigits,
  );
}
