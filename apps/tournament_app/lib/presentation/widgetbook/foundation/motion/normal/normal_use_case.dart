import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_fixture.dart';

final motionNormalUseCase = WidgetbookUseCase(
  name: 'normal reveal',
  builder: MotionNormalUseCase.build,
);

abstract final class MotionNormalUseCase {
  static Widget build(BuildContext context) =>
      const MotionFixture(reduced: false);
}
