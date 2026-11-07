import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/score_choice_fixture.dart';

final scoreChoiceDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: ScoreChoiceDisabledUseCase.build,
);

abstract final class ScoreChoiceDisabledUseCase {
  static Widget build(BuildContext context) =>
      const ScoreChoiceFixture(disabled: true);
}
