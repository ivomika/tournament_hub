import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/dialog_fixture.dart';

final dialogDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: DialogDisabledUseCase.build,
);

abstract final class DialogDisabledUseCase {
  static Widget build(BuildContext context) =>
      const DialogFixture(disabled: true);
}
