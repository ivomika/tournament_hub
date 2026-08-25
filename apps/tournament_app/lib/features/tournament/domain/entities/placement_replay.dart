import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/elimination_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/placement_replay_match_view.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_conflict_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class PlacementReplay extends Equatable {
  PlacementReplay({
    required Iterable<TournamentParticipantId> participantIds,
    this.replayNumber = 1,
    Map<TournamentMatchId, EliminationMatchResult> results = const {},
  }) : participantIds = List.unmodifiable(participantIds),
       results = Map.unmodifiable(results),
       schedule = _createSchedule(participantIds, replayNumber);

  final List<TournamentParticipantId> participantIds;
  final int replayNumber;
  final TournamentSchedule schedule;
  final Map<TournamentMatchId, EliminationMatchResult> results;

  List<PlacementReplayMatchView> get matches => [
    for (final scheduled in schedule.rounds.expand((round) => round.matches))
      PlacementReplayMatchView(
        scheduledMatch: scheduled,
        result: results[scheduled.id],
      ),
  ];

  bool get allMatchesCompleted => matches.every((match) => match.isCompleted);

  List<TournamentParticipantId> get tiedParticipantIds {
    if (!allMatchesCompleted) return const [];
    final stats = _statistics();
    final grouped = <int, List<TournamentParticipantId>>{};
    for (final participantId in participantIds) {
      final value = stats[participantId]!;
      grouped.putIfAbsent(value, () => []).add(participantId);
    }
    return [
      for (final group in grouped.values)
        if (group.length > 1) ...group,
    ];
  }

  List<TournamentParticipantId>? get uniqueOrder {
    if (!allMatchesCompleted || tiedParticipantIds.isNotEmpty) return null;
    final stats = _statistics();
    return [...participantIds]..sort((left, right) {
      return stats[right]!.compareTo(stats[left]!);
    });
  }

  PlacementReplay recordResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    final match = matches.firstWhere(
      (item) => item.scheduledMatch.id == matchId,
      orElse: () => throw const TournamentConflictException(
        'Матч не принадлежит placement replay.',
      ),
    );
    if (match.isCompleted) {
      if (match.result!.updateId == updateId) return this;
      throw const TournamentConflictException(
        'Завершённый replay-матч нужно исправлять отдельно.',
      );
    }
    final updated = EliminationMatchResult(
      matchId: matchId,
      firstParticipantId: match.scheduledMatch.firstParticipantId,
      secondParticipantId: match.scheduledMatch.secondParticipantId,
      winnerId: winnerId,
      updateId: updateId,
    );
    return PlacementReplay(
      participantIds: participantIds,
      replayNumber: replayNumber,
      results: {...results, matchId: updated},
    );
  }

  PlacementReplay createNextForTiedParticipants() {
    final tied = tiedParticipantIds;
    if (tied.length < 2) {
      throw const TournamentConflictException(
        'Новый placement replay нужен только при сохранившемся равенстве.',
      );
    }
    return PlacementReplay(
      participantIds: participantIds,
      replayNumber: replayNumber + 1,
    );
  }

  Map<TournamentParticipantId, int> _statistics() {
    final wins = {for (final id in participantIds) id: 0};
    for (final match in matches) {
      final result = match.result!;
      wins[result.winnerId] = wins[result.winnerId]! + 1;
    }
    return wins;
  }

  static TournamentSchedule _createSchedule(
    Iterable<TournamentParticipantId> participantIds,
    int replayNumber,
  ) {
    final original = const RoundRobinTournamentRules().createSchedule(
      participantIds,
    );
    return TournamentSchedule(
      participantIds: original.participantIds,
      rounds: [
        for (final round in original.rounds)
          TournamentRound(
            number: round.number,
            byeParticipantId: round.byeParticipantId,
            matches: [
              for (final match in round.matches)
                ScheduledTournamentMatch(
                  id: TournamentMatchId(
                    'placement-$replayNumber-${match.id.value}',
                  ),
                  firstParticipantId: match.firstParticipantId,
                  secondParticipantId: match.secondParticipantId,
                ),
            ],
          ),
      ],
    );
  }

  @override
  List<Object> get props => [participantIds, replayNumber, results];
}
