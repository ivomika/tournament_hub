import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/history/history_screen.dart';
import 'package:tournament_app/presentation/screens/history/history_screen_state.dart';

class HistoryFixture extends StatelessWidget {
  const HistoryFixture({required this.empty, super.key});
  final bool empty;
  static void action() {}
  @override
  Widget build(BuildContext context) => HistoryScreen(
    state: HistoryScreenState(
      periodLabel: 'Октябрь 2026',
      featured: empty
          ? null
          : HistoryEntry(
              name: 'Пятничный турнир',
              dateLabel: '14 октября · DE',
              winnerCharacter: 'Kitana',
              winnerName: 'Мария',
              initials: 'KT',
              onOpen: action,
            ),
      entries: empty
          ? []
          : [
              const HistoryEntry(
                name: 'Вечерний кубок',
                dateLabel: '11 октября · DE',
                winnerCharacter: 'Sub-Zero',
                winnerName: 'Иван',
                initials: 'SZ',
                onOpen: null,
              ),
              const HistoryEntry(
                name: 'Субботняя лига',
                dateLabel: '8 октября · SE',
                winnerCharacter: 'Sub-Zero',
                winnerName: 'Иван',
                initials: 'SZ',
                onOpen: null,
              ),
            ],
    ),
    onBack: action,
    onCreate: action,
  );
}
