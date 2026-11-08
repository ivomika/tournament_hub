import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/home/home_screen.dart';
import 'package:tournament_app/presentation/screens/home/home_screen_state.dart';

class HomeFixture extends StatelessWidget {
  const HomeFixture({required this.active, super.key});
  final bool active;
  static void action() {}
  @override
  Widget build(BuildContext context) => HomeScreen(
    state: HomeScreenState(
      active: active
          ? HomeTournament(
              name: 'Пятничный турнир',
              formatLabel: 'Double Elimination',
              participantCountLabel: '· 8 участников',
              stage: 'Верхняя сетка · Раунд 2',
              stageHighlights: const [false, true, false, false],
            )
          : null,
    ),
    onHistory: action,
    onProfile: action,
    onCreate: action,
    onContinue: action,
  );
}
