import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/home/home_fixture.dart';

final homeActiveUseCase = WidgetbookUseCase(
  name: 'active',
  builder: HomeActiveUseCase.build,
);

abstract final class HomeActiveUseCase {
  static Widget build(BuildContext context) => HomeFixture(active: true);
}
