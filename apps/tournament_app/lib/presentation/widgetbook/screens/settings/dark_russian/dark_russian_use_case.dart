import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/settings/settings_fixture.dart';

final settingsDarkRussianUseCase = WidgetbookUseCase(
  name: 'dark_russian',
  builder: SettingsDarkRussianUseCase.build,
);

abstract final class SettingsDarkRussianUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(SettingsDarkRussianUseCase),
    child: SettingsFixture(),
  );
}
