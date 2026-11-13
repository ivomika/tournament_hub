import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/profile_edit_fixture.dart';

final profileEditNavigationErrorUseCase = WidgetbookUseCase(
  name: 'navigation-error',
  builder: ProfileEditNavigationErrorUseCase.build,
);

abstract final class ProfileEditNavigationErrorUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileEditNavigationErrorUseCase),
    child: const ProfileEditFixture(
      phase: ProfileEditPhase.navigationError,
      name: 'Иван Михайлов',
    ),
  );
}
