import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/history/history_fixture.dart';

final historyEmptyUseCase = WidgetbookUseCase(
  name: 'empty',
  builder: HistoryEmptyUseCase.build,
);

abstract final class HistoryEmptyUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(HistoryEmptyUseCase),
    child: HistoryFixture(empty: true),
  );
}
