import 'package:tournament_app/presentation/widgetbook/components/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/navigation_fixture.dart';

final navigationHoveredUseCase = WidgetbookUseCase(
  name: 'hovered',
  builder: NavigationHoveredUseCase.build,
);

abstract final class NavigationHoveredUseCase {
  static Widget build(BuildContext context) => const ComponentPreview(
    padded: true,
    child: NavigationFixture(state: WidgetState.hovered),
  );
}
