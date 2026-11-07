import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';

final stackedIdentityUseCase = WidgetbookUseCase(
  name: 'stacked',
  builder: StackedIdentityUseCase.build,
);

abstract final class StackedIdentityUseCase {
  static Widget build(BuildContext context) =>
      const IdentityFixture(layout: AppIdentityLayout.stacked);
}
