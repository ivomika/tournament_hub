import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/responsive_fixture.dart';

final responsiveConsumersUseCase = WidgetbookUseCase(
  name: 'consumers',
  builder: ResponsiveConsumersUseCase.build,
);

abstract final class ResponsiveConsumersUseCase {
  static Widget build(BuildContext context) =>
      const ResponsiveFixture(scaled: false);
}
