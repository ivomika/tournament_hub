import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';

final headerEditUseCase = WidgetbookUseCase(
  name: 'edit',
  builder: HeaderEditUseCase.build,
);

abstract final class HeaderEditUseCase {
  static Widget build(BuildContext context) =>
      const HeaderFixture(sample: HeaderSample.edit);
}
