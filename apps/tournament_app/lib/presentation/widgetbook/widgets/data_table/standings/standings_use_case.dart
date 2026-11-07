import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/data_table/table_fixture.dart';

final tableStandingsUseCase = WidgetbookUseCase(
  name: 'Standings',
  builder: TableStandingsUseCase.build,
);

abstract final class TableStandingsUseCase {
  static Widget build(BuildContext context) => const TableFixture();
}
