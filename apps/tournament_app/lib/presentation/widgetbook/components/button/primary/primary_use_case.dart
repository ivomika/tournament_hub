import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_states_preview.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';

final primaryButtonUseCase = WidgetbookUseCase(
  name: 'primary',
  builder: PrimaryButtonUseCase.build,
);

abstract final class PrimaryButtonUseCase {
  static Widget build(BuildContext context) =>
      const ButtonStatesPreview(kind: AppButtonKind.primary);
}
