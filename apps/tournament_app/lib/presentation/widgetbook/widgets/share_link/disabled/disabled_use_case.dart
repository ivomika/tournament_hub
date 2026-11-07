import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/share_fixture.dart';

final shareDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: ShareDisabledUseCase.build,
);

abstract final class ShareDisabledUseCase {
  static Widget build(BuildContext context) =>
      const ShareFixture(disabled: true);
}
