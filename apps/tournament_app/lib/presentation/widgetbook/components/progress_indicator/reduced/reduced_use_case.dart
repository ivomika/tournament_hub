import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/progress_fixture.dart';

final progressReducedUseCase = WidgetbookUseCase(
  name: 'reduced',
  builder: ProgressReducedUseCase.build,
);

abstract final class ProgressReducedUseCase {
  static Widget build(BuildContext context) =>
      const ProgressFixture(reduced: true);
}
