import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_fixture.dart';

final motionReducedUseCase = WidgetbookUseCase(
  name: 'reduced reveal',
  builder: MotionReducedUseCase.build,
);

abstract final class MotionReducedUseCase {
  static Widget build(BuildContext context) =>
      const MotionFixture(reduced: true);
}
