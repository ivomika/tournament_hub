import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/bracket_fixture.dart';

final bracketCurrentUseCase = WidgetbookUseCase(
  name: 'current',
  builder: BracketCurrentUseCase.build,
);

abstract final class BracketCurrentUseCase {
  static Widget build(BuildContext context) =>
      const BracketFixture(state: AppBracketState.current);
}
