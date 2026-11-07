import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_fixture.dart';

final panelSurfaceUseCase = WidgetbookUseCase(
  name: 'panel',
  builder: PanelSurfaceUseCase.build,
);

abstract final class PanelSurfaceUseCase {
  static Widget build(BuildContext context) =>
      const SurfaceFixture(nested: false);
}
