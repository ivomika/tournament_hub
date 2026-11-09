import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/results_fixture.dart';

final resultsSeUseCase = WidgetbookUseCase(
  name: 'se',
  builder: ResultsSeUseCase.build,
);

abstract final class ResultsSeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ResultsSeUseCase),
    child: ResultsFixture(sample: ResultsSample.se),
  );
}
