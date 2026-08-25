import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_bout.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/normal_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_conflict_exception.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentMatch extends Equatable {
  TournamentMatch._({
    required this.scheduledMatch,
    required Iterable<MatchBout> bouts,
    required Iterable<MatchUpdateId> appliedUpdateIds,
    this._technicalResult,
  }) : bouts = List.unmodifiable(bouts),
       appliedUpdateIds = Set.unmodifiable(appliedUpdateIds);

  factory TournamentMatch.planned(ScheduledTournamentMatch scheduledMatch) {
    return TournamentMatch._(
      scheduledMatch: scheduledMatch,
      bouts: const [],
      appliedUpdateIds: const {},
    );
  }

  factory TournamentMatch.restore({
    required ScheduledTournamentMatch scheduledMatch,
    required Iterable<MatchBout> bouts,
    required Iterable<MatchUpdateId> appliedUpdateIds,
    TechnicalMatchResult? technicalResult,
  }) {
    final match = TournamentMatch._(
      scheduledMatch: scheduledMatch,
      bouts: bouts,
      appliedUpdateIds: appliedUpdateIds,
      technicalResult: technicalResult,
    );
    for (final bout in match.bouts) {
      match._validateParticipant(bout.winnerId);
    }
    if (match.bouts.length > 3 ||
        (match.bouts.isNotEmpty && technicalResult != null)) {
      throw const TournamentValidationException(
        'Сохранённое состояние матча некорректно.',
      );
    }
    if (technicalResult != null) {
      match._validateParticipant(technicalResult.winnerId);
      final firstWins =
          technicalResult.winnerId == scheduledMatch.firstParticipantId;
      if (technicalResult.firstParticipantScore != (firstWins ? 2 : 0) ||
          technicalResult.secondParticipantScore != (firstWins ? 0 : 2)) {
        throw const TournamentValidationException(
          'Технический результат должен иметь счёт 2:0 в пользу победителя.',
        );
      }
    }
    var firstWins = 0;
    var secondWins = 0;
    for (final (index, bout) in match.bouts.indexed) {
      if (bout.number != index + 1 || firstWins == 2 || secondWins == 2) {
        throw const TournamentValidationException(
          'Порядок сохранённых схваток матча некорректен.',
        );
      }
      if (bout.winnerId == scheduledMatch.firstParticipantId) {
        firstWins += 1;
      } else {
        secondWins += 1;
      }
    }
    return match;
  }

  final ScheduledTournamentMatch scheduledMatch;
  final List<MatchBout> bouts;
  final Set<MatchUpdateId> appliedUpdateIds;
  final TechnicalMatchResult? _technicalResult;

  MatchResult? get result => _technicalResult ?? _normalResult;
  bool get isCompleted => result != null;

  TournamentMatch recordBout({
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    if (appliedUpdateIds.contains(updateId)) return this;
    if (isCompleted) {
      throw const TournamentConflictException(
        'Завершённый матч можно изменить только через исправление результата.',
      );
    }
    _validateParticipant(winnerId);
    return TournamentMatch._(
      scheduledMatch: scheduledMatch,
      bouts: [
        ...bouts,
        MatchBout(number: bouts.length + 1, winnerId: winnerId),
      ],
      appliedUpdateIds: {...appliedUpdateIds, updateId},
    );
  }

  TournamentMatch correctResult({
    required Iterable<TournamentParticipantId> boutWinners,
    required MatchUpdateId updateId,
  }) {
    if (appliedUpdateIds.contains(updateId)) return this;
    var corrected = TournamentMatch.planned(scheduledMatch);
    var index = 0;
    for (final winnerId in boutWinners) {
      corrected = corrected.recordBout(
        winnerId: winnerId,
        updateId: MatchUpdateId('${updateId.value}-bout-${++index}'),
      );
    }
    if (!corrected.isCompleted) {
      throw const TournamentValidationException(
        'Исправленный результат должен завершать матч.',
      );
    }
    return TournamentMatch._(
      scheduledMatch: scheduledMatch,
      bouts: corrected.bouts,
      appliedUpdateIds: {...appliedUpdateIds, updateId},
    );
  }

  TournamentMatch applyTechnicalResult({
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    if (appliedUpdateIds.contains(updateId)) return this;
    _validateParticipant(winnerId);
    final firstWins = winnerId == scheduledMatch.firstParticipantId;
    return TournamentMatch._(
      scheduledMatch: scheduledMatch,
      bouts: const [],
      appliedUpdateIds: {...appliedUpdateIds, updateId},
      technicalResult: TechnicalMatchResult(
        winnerId: winnerId,
        firstParticipantScore: firstWins ? 2 : 0,
        secondParticipantScore: firstWins ? 0 : 2,
      ),
    );
  }

  NormalMatchResult? get _normalResult {
    final firstWins = bouts
        .where((bout) => bout.winnerId == scheduledMatch.firstParticipantId)
        .length;
    final secondWins = bouts.length - firstWins;
    if (firstWins < 2 && secondWins < 2) return null;
    return NormalMatchResult(
      winnerId: firstWins == 2
          ? scheduledMatch.firstParticipantId
          : scheduledMatch.secondParticipantId,
      firstParticipantScore: firstWins,
      secondParticipantScore: secondWins,
    );
  }

  void _validateParticipant(TournamentParticipantId participantId) {
    if (participantId != scheduledMatch.firstParticipantId &&
        participantId != scheduledMatch.secondParticipantId) {
      throw const TournamentValidationException(
        'Победитель схватки должен быть участником матча.',
      );
    }
  }

  @override
  List<Object?> get props => [
    scheduledMatch,
    bouts,
    appliedUpdateIds,
    _technicalResult,
  ];
}
