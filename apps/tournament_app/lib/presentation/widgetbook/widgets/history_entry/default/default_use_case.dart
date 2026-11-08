import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/component_preview.dart';
import 'package:tournament_app/presentation/design_system/widgets/history_entry/app_history_entry.dart';

final historyEntryDefaultUseCase = WidgetbookUseCase(
  name: 'default',
  builder: HistoryEntryDefaultUseCase.build,
);

abstract final class HistoryEntryDefaultUseCase {
  static Widget build(BuildContext context) =>
      const ComponentPreview(padded: true, child: HistoryEntryFixture());
}

class HistoryEntryFixture extends StatelessWidget {
  const HistoryEntryFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => AppHistoryEntry(
    name: 'Пятничный турнир',
    dateLabel: '14 октября · DE',
    winnerCharacter: 'Kitana',
    winnerName: 'Мария',
    initials: 'KT',
    onOpen: action,
    prominent: true,
  );
}
