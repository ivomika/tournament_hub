import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/results_fixture.dart';

final resultsDeUseCase = WidgetbookUseCase(
  name: 'de',
  builder: ResultsDeUseCase.build,
);

abstract final class ResultsDeUseCase {
  static Widget build(BuildContext context) =>
      ResultsFixture(sample: ResultsSample.de);
}
