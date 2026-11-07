import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/navigation_fixture.dart';

final navigationFocusedUseCase = WidgetbookUseCase(
  name: 'focused',
  builder: NavigationFocusedUseCase.build,
);

abstract final class NavigationFocusedUseCase {
  static Widget build(BuildContext context) =>
      const NavigationFixture(state: WidgetState.focused);
}
