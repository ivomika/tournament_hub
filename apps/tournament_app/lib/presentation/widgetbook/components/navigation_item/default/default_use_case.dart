import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/navigation_fixture.dart';

final navigationDefaultUseCase = WidgetbookUseCase(
  name: 'default',
  builder: NavigationDefaultUseCase.build,
);

abstract final class NavigationDefaultUseCase {
  static Widget build(BuildContext context) => const NavigationFixture();
}
