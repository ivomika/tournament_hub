import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/score_choice_fixture.dart';

final scoreChoiceRightUseCase = WidgetbookUseCase(
  name: 'right',
  builder: ScoreChoiceRightUseCase.build,
);

abstract final class ScoreChoiceRightUseCase {
  static Widget build(BuildContext context) =>
      const ScoreChoiceFixture(selected: ScoreChoiceValue.right);
}
