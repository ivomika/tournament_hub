import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/progress_fixture.dart';

final progressFixedPhaseUseCase = WidgetbookUseCase(
  name: 'fixed_phase',
  builder: ProgressFixedPhaseUseCase.build,
);

abstract final class ProgressFixedPhaseUseCase {
  static Widget build(BuildContext context) =>
      const ProgressFixture(frozen: true);
}
