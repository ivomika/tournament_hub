import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen_state.dart';
export 'package:tournament_app/presentation/screens/distribution/distribution_screen_state.dart';

class DistributionFixture extends StatelessWidget {
  const DistributionFixture({required this.phase, super.key});
  final DistributionPhase phase;
  static void action() {}
  @override
  Widget build(BuildContext context) => DistributionScreen(
    state: DistributionScreenState(
      phase: phase,
      players: const [
        PlayerDisplay(character: 'Sub-Zero', name: 'Иван', initials: 'SZ'),
        PlayerDisplay(character: 'Scorpion', name: 'Алексей', initials: 'SC'),
        PlayerDisplay(character: 'Kitana', name: 'Мария', initials: 'KT'),
        PlayerDisplay(character: 'Raiden', name: 'Олег', initials: 'RD'),
      ],
    ),
    onBack: action,
    onShare: action,
    onStart: action,
  );
}
