import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tie/tie_fixture.dart';

final tieEqualPointsUseCase = WidgetbookUseCase(
  name: 'equal_points',
  builder: TieEqualPointsUseCase.build,
);

abstract final class TieEqualPointsUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(TieEqualPointsUseCase),
    child: TieFixture(),
  );
}
