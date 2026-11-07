import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/dialog_fixture.dart';

final dialogDefaultUseCase = WidgetbookUseCase(
  name: 'default',
  builder: DialogDefaultUseCase.build,
);

abstract final class DialogDefaultUseCase {
  static Widget build(BuildContext context) => const DialogFixture();
}
