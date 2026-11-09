import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/results_fixture.dart';

final resultsRrUseCase = WidgetbookUseCase(
  name: 'rr',
  builder: ResultsRrUseCase.build,
);

abstract final class ResultsRrUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ResultsRrUseCase),
    child: ResultsFixture(sample: ResultsSample.rr),
  );
}
