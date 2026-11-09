import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bracket/bracket_fixture.dart';

final bracketSeUseCase = WidgetbookUseCase(
  name: 'se',
  builder: BracketSeUseCase.build,
);

abstract final class BracketSeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BracketSeUseCase),
    child: BracketFixture(
      sample: BracketSample.se,
      key: const ValueKey(BracketSample.se),
    ),
  );
}
