import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_fixture.dart';

final nestedSurfaceUseCase = WidgetbookUseCase(
  name: 'nested',
  builder: NestedSurfaceUseCase.build,
);

abstract final class NestedSurfaceUseCase {
  static Widget build(BuildContext context) =>
      const SurfaceFixture(nested: true);
}
