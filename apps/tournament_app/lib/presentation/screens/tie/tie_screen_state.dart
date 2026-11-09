import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';

@immutable
class TieScreenState {
  TieScreenState({
    required this.note,
    required this.rulesExpanded,
    required Iterable<AppTableColumn> columns,
    required Iterable<AppTableRow> rows,
  }) : columns = List.unmodifiable(columns),
       rows = List.unmodifiable(rows);
  final String note;
  final bool rulesExpanded;
  final List<AppTableColumn> columns;
  final List<AppTableRow> rows;
}
