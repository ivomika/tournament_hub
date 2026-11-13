import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/profile_edit_fixture.dart';

final profileEditInvalidUseCase = WidgetbookUseCase(
  name: 'invalid',
  builder: ProfileEditInvalidUseCase.build,
);

abstract final class ProfileEditInvalidUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileEditInvalidUseCase),
    child: const ProfileEditFixture(
      phase: ProfileEditPhase.invalidName,
      name: '',
    ),
  );
}
