import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/home/home_fixture.dart';

final homeEmptyUseCase = WidgetbookUseCase(
  name: 'empty',
  builder: HomeEmptyUseCase.build,
);

abstract final class HomeEmptyUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(HomeEmptyUseCase),
    child: HomeFixture(active: false),
  );
}
