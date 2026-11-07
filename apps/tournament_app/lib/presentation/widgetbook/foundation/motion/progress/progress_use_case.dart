import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_fixture.dart';

final motionProgressUseCase = WidgetbookUseCase(
  name: 'Material3 progress',
  builder: MotionProgressUseCase.build,
);

abstract final class MotionProgressUseCase {
  static Widget build(BuildContext context) => const MotionProgressFixture();
}
