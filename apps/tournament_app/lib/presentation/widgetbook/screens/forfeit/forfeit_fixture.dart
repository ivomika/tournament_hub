import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/screens/forfeit/forfeit_screen.dart';
import 'package:tournament_app/presentation/screens/forfeit/forfeit_screen_state.dart';

class ForfeitFixture extends StatelessWidget {
  const ForfeitFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => ForfeitScreen(
    state: ForfeitScreenState(
      description: FoundationLocalizations.of(context).screenForfeitNote,
      player: const PlayerDisplay(
        character: "Scorpion",
        name: "Алексей",
        initials: "SC",
      ),
      title: FoundationLocalizations.of(context).screenForfeitTitle("Алексею"),
    ),
    onConfirm: action,
    onCancel: action,
  );
}
