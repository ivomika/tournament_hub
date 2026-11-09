import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/profile_edit_fixture.dart';

final profileEditErrorUseCase = WidgetbookUseCase(
  name: 'error',
  builder: ProfileEditErrorUseCase.build,
);

abstract final class ProfileEditErrorUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileEditErrorUseCase),
    child: ProfileEditFixture(phase: ProfileEditPhase.saveError),
  );
}
