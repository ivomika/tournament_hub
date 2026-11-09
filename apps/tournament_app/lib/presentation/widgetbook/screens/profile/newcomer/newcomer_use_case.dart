import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile/profile_fixture.dart';

final profileNewcomerUseCase = WidgetbookUseCase(
  name: 'newcomer',
  builder: ProfileNewcomerUseCase.build,
);

abstract final class ProfileNewcomerUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileNewcomerUseCase),
    child: ProfileFixture(newcomer: true),
  );
}
