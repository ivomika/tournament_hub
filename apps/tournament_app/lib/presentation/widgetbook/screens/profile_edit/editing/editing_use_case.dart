import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/profile_edit_fixture.dart';

final profileEditEditingUseCase = WidgetbookUseCase(
  name: 'editing',
  builder: ProfileEditEditingUseCase.build,
);

abstract final class ProfileEditEditingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ProfileEditEditingUseCase),
    child: ProfileEditFixture(phase: ProfileEditPhase.editing),
  );
}
