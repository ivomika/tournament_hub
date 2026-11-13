import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/profile_edit_fixture.dart';

final profileEditSavingUseCase = WidgetbookUseCase(
  name: 'saving',
  builder: ProfileEditSavingUseCase.build,
);

abstract final class ProfileEditSavingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileEditSavingUseCase),
    child: const ProfileEditFixture(
      phase: ProfileEditPhase.saving,
      name: 'Иван Михайлов',
    ),
  );
}
