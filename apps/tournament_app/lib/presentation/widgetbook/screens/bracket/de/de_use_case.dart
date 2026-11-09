import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bracket/bracket_fixture.dart';

final bracketDeUseCase = WidgetbookUseCase(
  name: 'de',
  builder: BracketDeUseCase.build,
);

abstract final class BracketDeUseCase {
  static Widget build(BuildContext context) => BracketFixture(
    sample: BracketSample.de,
    key: const ValueKey(BracketSample.de),
  );
}
