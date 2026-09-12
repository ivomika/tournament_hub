import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/first_to.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_result.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_slot.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_state.dart';
import 'package:tournament_app/domain/tournament/value_objects/normal_match_result.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class Match extends Equatable {
  Match({
    required this.id,
    required this.order,
    required this.round,
    required String stage,
    required Iterable<MatchSlot> slots,
    required this.firstTo,
    this.state = MatchState.upcoming,
    this.result,
  }) : stage = _requireStage(stage),
       _slots = UnmodifiableListView(List.of(slots)) {
    if (_slots.length != 2) {
      throw ArgumentError.value(
        slots,
        'slots',
        'Match должен иметь ровно два slot.',
      );
    }
    if (result != null && state != MatchState.finished) {
      throw ArgumentError('Result возможен только у Finished Match.');
    }
    if (result == null && state == MatchState.finished) {
      throw ArgumentError('Finished Match обязан иметь result.');
    }
    if (state == MatchState.current && !hasTwoResolvedParticipants) {
      throw ArgumentError('Current Match требует двух Participant.');
    }
    _validateResult(result);
  }

  final MatchId id;
  final int order;
  final int round;
  final String stage;
  final FirstTo firstTo;
  final MatchState state;
  final MatchResult? result;
  final UnmodifiableListView<MatchSlot> _slots;

  TournamentId get tournamentId => id.tournamentId;
  List<MatchSlot> get slots => _slots;

  bool get hasTwoResolvedParticipants =>
      _slots.every((slot) => slot.resolvedParticipantId != null) &&
      _slots[0].resolvedParticipantId != _slots[1].resolvedParticipantId;

  Match start() {
    if (state != MatchState.upcoming || !hasTwoResolvedParticipants) {
      throw StateError(
        'В Current может перейти только готовый Upcoming Match.',
      );
    }
    return _copy(state: MatchState.current);
  }

  Match finish(MatchResult nextResult) {
    if (state != MatchState.current) {
      throw StateError('Result можно записать только для Current Match.');
    }
    _validateResult(nextResult);
    if (nextResult is NormalMatchResult) {
      final normalResult = nextResult;
      if (normalResult.winnerScore != firstTo.winsRequired ||
          normalResult.loserScore >= firstTo.winsRequired) {
        throw ArgumentError(
          'Score NormalMatchResult не соответствует FirstTo.',
        );
      }
    }
    return _copy(state: MatchState.finished, result: nextResult);
  }

  Match _copy({required MatchState state, MatchResult? result}) => Match(
    id: id,
    order: order,
    round: round,
    stage: stage,
    slots: _slots,
    firstTo: firstTo,
    state: state,
    result: result,
  );

  void _validateResult(MatchResult? candidate) {
    if (candidate == null) return;
    final participantIds = _slots
        .map((slot) => slot.resolvedParticipantId)
        .whereType<ParticipantId>()
        .toSet();
    if (!participantIds.contains(candidate.winnerId) ||
        !participantIds.contains(candidate.loserId)) {
      throw ArgumentError(
        'Result должен относиться к Participant этого Match.',
      );
    }
  }

  static String _requireStage(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, 'stage', 'Stage не может быть пустым.');
    }
    return normalized;
  }

  @override
  List<Object?> get props => [
    id,
    order,
    round,
    stage,
    _slots,
    firstTo,
    state,
    result,
  ];
}
