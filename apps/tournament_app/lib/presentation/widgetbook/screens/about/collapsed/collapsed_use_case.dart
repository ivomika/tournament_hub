import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/about/about_fixture.dart';

final aboutCollapsedUseCase = WidgetbookUseCase(
  name: 'collapsed',
  builder: AboutCollapsedUseCase.build,
);

abstract final class AboutCollapsedUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(AboutCollapsedUseCase),
    child: AboutFixture(expanded: false),
  );
}
