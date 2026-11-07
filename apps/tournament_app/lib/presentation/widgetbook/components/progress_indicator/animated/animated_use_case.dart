import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/progress_fixture.dart';

final progressAnimatedUseCase = WidgetbookUseCase(
  name: 'animated',
  builder: ProgressAnimatedUseCase.build,
);

abstract final class ProgressAnimatedUseCase {
  static Widget build(BuildContext context) => const ProgressFixture();
}
