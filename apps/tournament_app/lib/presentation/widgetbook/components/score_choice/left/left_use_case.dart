import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/score_choice_fixture.dart';

final scoreChoiceLeftUseCase = WidgetbookUseCase(
  name: 'left',
  builder: ScoreChoiceLeftUseCase.build,
);

abstract final class ScoreChoiceLeftUseCase {
  static Widget build(BuildContext context) =>
      const ScoreChoiceFixture(selected: ScoreChoiceValue.left);
}
