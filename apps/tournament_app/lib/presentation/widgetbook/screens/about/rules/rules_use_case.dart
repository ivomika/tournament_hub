import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/about/about_fixture.dart';

final aboutRulesUseCase = WidgetbookUseCase(
  name: 'rules',
  builder: AboutRulesUseCase.build,
);

abstract final class AboutRulesUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(AboutRulesUseCase),
    child: AboutFixture(expanded: true),
  );
}
