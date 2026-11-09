import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/result_locked/result_locked_screen.dart';
import 'package:tournament_app/presentation/screens/result_locked/result_locked_screen_state.dart';

class ResultLockedFixture extends StatelessWidget {
  const ResultLockedFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => ResultLockedScreen(
    state: ResultLockedScreenState(
      title: 'Пятничный турнир',
      matchLabel: 'Матч 1',
      pairingLabel: 'Sub-Zero · Иван — Scorpion · Алексей',
      reason: FoundationLocalizations.of(context).screenLockedReason,
    ),
    onBack: action,
    onShare: action,
    onCorrect: null,
  );
}
