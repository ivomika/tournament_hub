import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';
import 'package:tournament_app/presentation/screens/match_result/match_result_screen.dart';
import 'package:tournament_app/presentation/screens/match_result/match_result_screen_state.dart';

enum MatchResultSample {
  choice,
  ft2,
  ft3,
  ft10,
  correction,
  error,
  technicalRr,
  technicalDe,
}

class MatchResultFixture extends StatefulWidget {
  const MatchResultFixture({required this.sample, super.key});
  final MatchResultSample sample;
  @override
  State<MatchResultFixture> createState() => _FixtureState();
}

class _FixtureState extends State<MatchResultFixture> {
  late final controller = TextEditingController(
    text: widget.sample == MatchResultSample.ft10 ? '7' : '1',
  );
  void action() {}
  void scoreChanged(String value) {}
  void winner(MatchSide value) {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    final sample = widget.sample,
        correction = sample == MatchResultSample.correction,
        error = sample == MatchResultSample.error,
        technical =
            sample == MatchResultSample.technicalRr ||
            sample == MatchResultSample.technicalDe;
    final ResultEntry entry = technical
        ? TechnicalResultEntry(
            leftOutcome: l.screenTechnicalWin,
            rightOutcome: l.screenTechnicalLoss,
            leftTone: AppStatusTone.accent,
            rightTone: AppStatusTone.error,
            note: sample == MatchResultSample.technicalRr
                ? l.screenTechnicalRrNote
                : l.screenTechnicalDeNote,
          )
        : sample == MatchResultSample.choice
        ? const ChoiceResultEntry(MatchSide.left)
        : SteppedResultEntry(
            fixedScore: sample == MatchResultSample.ft10
                ? '10'
                : sample == MatchResultSample.ft3
                ? '3'
                : '2',
            fixedSide: MatchSide.left,
          );
    return MatchResultScreen(
      state: MatchResultScreenState(
        title: correction ? l.screenCorrection : l.screenResult,
        saveLabel: correction
            ? l.screenResultCorrect
            : error
            ? l.screenRetrySave
            : l.screenSaveResult,
        cancelLabel: correction
            ? l.screenCancelCorrection
            : l.screenCancelResult,
        tournamentTitle: 'Пятничный турнир',
        left: const PlayerDisplay(
          character: 'Sub-Zero',
          name: 'Иван',
          initials: 'SZ',
        ),
        right: const PlayerDisplay(
          character: 'Scorpion',
          name: 'Алексей',
          initials: 'SC',
        ),
        entry: entry,
        inputLabel: l.stepperScoreLabel,
        errorText: error ? l.screenResultSaveError : null,
        details: technical
            ? null
            : correction
            ? ResultExplanationDetails(
                title: l.screenAboutCorrection,
                expanded: false,
                onToggle: action,
                text: l.screenCorrectionNote,
              )
            : ResultActionsDetails(
                title: l.screenOtherActions,
                expanded: false,
                onToggle: action,
                onTechnical: action,
                onWithdraw: action,
              ),
      ),
      loserController: technical || sample == MatchResultSample.choice
          ? null
          : controller,
      onCancel: action,
      onSave: action,
      onWinnerChanged: winner,
      onDecrease: action,
      onIncrease: action,
      onScoreChanged: scoreChanged,
    );
  }
}
