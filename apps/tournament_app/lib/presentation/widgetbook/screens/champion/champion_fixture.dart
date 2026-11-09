import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/screens/champion/champion_screen.dart';
import 'package:tournament_app/presentation/screens/champion/champion_screen_state.dart';

class ChampionFixture extends StatelessWidget {
  const ChampionFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => ChampionScreen(
    state: const ChampionScreenState(
      title: 'Пятничный турнир',
      winner: PlayerDisplay(character: 'Kitana', name: 'Мария', initials: 'KT'),
    ),
    onBack: action,
    onShare: action,
    onResults: action,
  );
}
