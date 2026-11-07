import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/responsive_fixture.dart';

final responsiveTextScaleUseCase = WidgetbookUseCase(
  name: 'text_scale',
  builder: ResponsiveTextScaleUseCase.build,
);

abstract final class ResponsiveTextScaleUseCase {
  static Widget build(BuildContext context) =>
      const ResponsiveFixture(scaled: true);
}
