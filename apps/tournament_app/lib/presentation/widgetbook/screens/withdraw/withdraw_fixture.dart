import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/screens/withdraw/withdraw_screen.dart';
import 'package:tournament_app/presentation/screens/withdraw/withdraw_screen_state.dart';

class WithdrawFixture extends StatelessWidget {
  const WithdrawFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => WithdrawScreen(
    state: WithdrawScreenState(
      description: FoundationLocalizations.of(context).screenWithdrawNote,
      player: const PlayerDisplay(
        character: "Scorpion",
        name: "Алексей",
        initials: "SC",
      ),
      title: FoundationLocalizations.of(context).screenWithdrawTitle("Алексея"),
    ),
    onConfirm: action,
    onCancel: action,
  );
}
