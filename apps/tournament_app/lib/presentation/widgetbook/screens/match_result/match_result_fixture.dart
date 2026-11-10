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

  String _resolveFixedScore(MatchResultSample sample) {
    if (sample == MatchResultSample.ft10) return '10';
    if (sample == MatchResultSample.ft3) return '3';
    return '2';
  }

  ResultEntry _resolveEntry(
    FoundationLocalizations localizations,
    MatchResultSample sample,
    bool technical,
  ) {
    if (technical) {
      return TechnicalResultEntry(
        leftOutcome: localizations.screenTechnicalWin,
        rightOutcome: localizations.screenTechnicalLoss,
        leftTone: AppStatusTone.accent,
        rightTone: AppStatusTone.error,
        note: sample == MatchResultSample.technicalRr
            ? localizations.screenTechnicalRrNote
            : localizations.screenTechnicalDeNote,
      );
    }
    if (sample == MatchResultSample.choice) {
      return const ChoiceResultEntry(MatchSide.left);
    }
    return SteppedResultEntry(
      fixedScore: _resolveFixedScore(sample),
      fixedSide: MatchSide.left,
    );
  }

  String _resolveSaveLabel(
    FoundationLocalizations localizations,
    bool correction,
    bool error,
  ) {
    if (correction) return localizations.screenResultCorrect;
    if (error) return localizations.screenRetrySave;
    return localizations.screenSaveResult;
  }

  ResultDetails? _resolveDetails(
    FoundationLocalizations localizations,
    bool technical,
    bool correction,
  ) {
    if (technical) return null;
    if (correction) {
      return ResultExplanationDetails(
        title: localizations.screenAboutCorrection,
        expanded: false,
        onToggle: action,
        text: localizations.screenCorrectionNote,
      );
    }
    return ResultActionsDetails(
      title: localizations.screenOtherActions,
      expanded: false,
      onToggle: action,
      onTechnical: action,
      onWithdraw: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    final sample = widget.sample,
        correction = sample == MatchResultSample.correction,
        error = sample == MatchResultSample.error,
        technical =
            sample == MatchResultSample.technicalRr ||
            sample == MatchResultSample.technicalDe;
    final entry = _resolveEntry(localizations, sample, technical);
    return MatchResultScreen(
      state: MatchResultScreenState(
        title: correction
            ? localizations.screenCorrection
            : localizations.screenResult,
        saveLabel: _resolveSaveLabel(localizations, correction, error),
        cancelLabel: correction
            ? localizations.screenCancelCorrection
            : localizations.screenCancelResult,
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
        inputLabel: localizations.stepperScoreLabel,
        errorText: error ? localizations.screenResultSaveError : null,
        details: _resolveDetails(localizations, technical, correction),
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
