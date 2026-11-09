import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/history/history_fixture.dart';

final historyListUseCase = WidgetbookUseCase(
  name: 'list',
  builder: HistoryListUseCase.build,
);

abstract final class HistoryListUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(HistoryListUseCase),
    child: HistoryFixture(empty: false),
  );
}
