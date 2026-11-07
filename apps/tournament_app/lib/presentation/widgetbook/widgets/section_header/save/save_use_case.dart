import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';

final headerSaveUseCase = WidgetbookUseCase(
  name: 'save',
  builder: HeaderSaveUseCase.build,
);

abstract final class HeaderSaveUseCase {
  static Widget build(BuildContext context) =>
      const HeaderFixture(sample: HeaderSample.save);
}
