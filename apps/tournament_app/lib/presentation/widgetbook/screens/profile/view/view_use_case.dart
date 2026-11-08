import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile/profile_fixture.dart';

final profileViewUseCase = WidgetbookUseCase(
  name: 'view',
  builder: ProfileViewUseCase.build,
);

abstract final class ProfileViewUseCase {
  static Widget build(BuildContext context) => ProfileFixture(newcomer: false);
}
