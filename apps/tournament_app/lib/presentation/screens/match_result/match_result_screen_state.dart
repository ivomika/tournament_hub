import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';

enum MatchSide { left, right }

@immutable
sealed class ResultEntry {
  const ResultEntry();
}

class ChoiceResultEntry extends ResultEntry {
  const ChoiceResultEntry(this.value);
  final MatchSide value;
}

class SteppedResultEntry extends ResultEntry {
  const SteppedResultEntry({required this.fixedScore, required this.fixedSide});
  final String fixedScore;
  final MatchSide fixedSide;
}

class TechnicalResultEntry extends ResultEntry {
  const TechnicalResultEntry({
    required this.leftOutcome,
    required this.rightOutcome,
    required this.leftTone,
    required this.rightTone,
    required this.note,
  });
  final String leftOutcome, rightOutcome, note;
  final AppStatusTone leftTone, rightTone;
}

@immutable
sealed class ResultDetails {
  const ResultDetails({
    required this.title,
    required this.expanded,
    required this.onToggle,
  });
  final String title;
  final bool expanded;
  final VoidCallback? onToggle;
}

class ResultActionsDetails extends ResultDetails {
  const ResultActionsDetails({
    required super.title,
    required super.expanded,
    required super.onToggle,
    required this.onTechnical,
    required this.onWithdraw,
  });
  final VoidCallback? onTechnical, onWithdraw;
}

class ResultExplanationDetails extends ResultDetails {
  const ResultExplanationDetails({
    required super.title,
    required super.expanded,
    required super.onToggle,
    required this.text,
  });
  final String text;
}

@immutable
class MatchResultScreenState {
  const MatchResultScreenState({
    required this.title,
    required this.saveLabel,
    required this.cancelLabel,
    required this.tournamentTitle,
    required this.left,
    required this.right,
    required this.entry,
    required this.inputLabel,
    this.errorText,
    this.details,
  });
  final String title, saveLabel, cancelLabel, tournamentTitle, inputLabel;
  final PlayerDisplay left, right;
  final ResultEntry entry;
  final String? errorText;
  final ResultDetails? details;
}
