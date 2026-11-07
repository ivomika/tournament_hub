import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';

final headerBackUseCase = WidgetbookUseCase(
  name: 'back',
  builder: HeaderBackUseCase.build,
);

abstract final class HeaderBackUseCase {
  static Widget build(BuildContext context) =>
      const HeaderFixture(sample: HeaderSample.back);
}
