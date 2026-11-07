import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';

final headerLongUseCase = WidgetbookUseCase(
  name: 'long',
  builder: HeaderLongUseCase.build,
);

abstract final class HeaderLongUseCase {
  static Widget build(BuildContext context) =>
      const HeaderFixture(sample: HeaderSample.long);
}
