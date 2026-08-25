import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/placement_replay.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationTournament extends Equatable {
  DoubleEliminationTournament({
    required this.draft,
    required Iterable<FighterAssignment> fighterAssignments,
    required this.bracket,
    Map<String, List<PlacementReplay>> placementReplays = const {},
  }) : fighterAssignments = List.unmodifiable(fighterAssignments),
       placementReplays = Map.unmodifiable({
         for (final entry in placementReplays.entries)
           entry.key: List<PlacementReplay>.unmodifiable(entry.value),
       }) {
    final participantIds = draft.participants
        .map((participant) => participant.id)
        .toSet();
    final assignedIds = this.fighterAssignments
        .map((assignment) => assignment.participantId)
        .toSet();
    final fighterIds = this.fighterAssignments
        .map((assignment) => assignment.fighterId)
        .toSet();
    if (participantIds.length != bracket.topology.participants.length ||
        !participantIds.containsAll(bracket.topology.participants) ||
        assignedIds.length != participantIds.length ||
        !assignedIds.containsAll(participantIds) ||
        fighterIds.length != this.fighterAssignments.length) {
      throw const TournamentValidationException(
        'Состояние Double Elimination не соответствует составу турнира.',
      );
    }
  }

  final TournamentDraft draft;
  final List<FighterAssignment> fighterAssignments;
  final DoubleEliminationBracket bracket;
  final Map<String, List<PlacementReplay>> placementReplays;

  List<TournamentParticipantId>? get finalPlacements {
    if (!bracket.isCompleted) return null;
    final result = <TournamentParticipantId>[];
    for (final group in bracket.placementGroups) {
      if (group.length == 1) {
        result.add(group.single);
        continue;
      }
      final replays = placementReplays[_groupId(group)];
      final order = replays?.last.uniqueOrder;
      if (order == null) return null;
      result.addAll(order);
    }
    return List.unmodifiable(result);
  }

  bool get isCompleted => finalPlacements != null;

  DoubleEliminationTournament recordBracketResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    final updated = bracket.recordResult(
      matchId: matchId,
      winnerId: winnerId,
      updateId: updateId,
    );
    return _replaceBracket(updated, preserveReplays: true);
  }

  DoubleEliminationTournament correctBracketResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    final updated = bracket.correctResult(
      matchId: matchId,
      winnerId: winnerId,
      updateId: updateId,
    );
    return _replaceBracket(updated, preserveReplays: false);
  }

  DoubleEliminationTournament recordPlacementResult({
    required Iterable<TournamentParticipantId> group,
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    final groupId = _groupId(group);
    final replays = [...?placementReplays[groupId]];
    if (replays.isEmpty) {
      throw const TournamentValidationException(
        'Для этой группы нет активного placement replay.',
      );
    }
    var updated = replays.removeLast().recordResult(
      matchId: matchId,
      winnerId: winnerId,
      updateId: updateId,
    );
    replays.add(updated);
    if (updated.allMatchesCompleted && updated.tiedParticipantIds.isNotEmpty) {
      updated = updated.createNextForTiedParticipants();
      replays.add(updated);
    }
    return DoubleEliminationTournament(
      draft: draft,
      fighterAssignments: fighterAssignments,
      bracket: bracket,
      placementReplays: {...placementReplays, groupId: replays},
    );
  }

  DoubleEliminationTournament _replaceBracket(
    DoubleEliminationBracket updated, {
    required bool preserveReplays,
  }) {
    final replays = preserveReplays
        ? Map<String, List<PlacementReplay>>.from(placementReplays)
        : <String, List<PlacementReplay>>{};
    if (updated.isCompleted) {
      for (final group in updated.sharedPlacementGroups) {
        replays.putIfAbsent(
          _groupId(group),
          () => [PlacementReplay(participantIds: group)],
        );
      }
      final validIds = updated.sharedPlacementGroups.map(_groupId).toSet();
      replays.removeWhere((id, _) => !validIds.contains(id));
    }
    return DoubleEliminationTournament(
      draft: draft,
      fighterAssignments: fighterAssignments,
      bracket: updated,
      placementReplays: replays,
    );
  }

  static String _groupId(Iterable<TournamentParticipantId> group) {
    final values = group.map((id) => id.value).toList()..sort();
    return values.join('|');
  }

  @override
  List<Object> get props => [
    draft,
    fighterAssignments,
    bracket,
    placementReplays,
  ];
}
