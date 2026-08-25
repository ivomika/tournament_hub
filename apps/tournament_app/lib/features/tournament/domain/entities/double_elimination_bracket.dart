import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/bracket_slot_source.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_view.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_topology.dart';
import 'package:tournament_app/features/tournament/domain/entities/elimination_match_result.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_conflict_exception.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_slot_source_type.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationBracket extends Equatable {
  DoubleEliminationBracket({
    required this.topology,
    Map<TournamentMatchId, EliminationMatchResult> results = const {},
  }) : results = Map.unmodifiable(results) {
    final definitionIds = topology.matches.map((match) => match.id).toSet();
    if (!definitionIds.containsAll(this.results.keys)) {
      throw const TournamentValidationException(
        'Результат относится к неизвестному матчу bracket.',
      );
    }
    _buildViews(validateStoredResults: true);
  }

  final DoubleEliminationTopology topology;
  final Map<TournamentMatchId, EliminationMatchResult> results;

  List<DoubleEliminationMatchView> get matches => _buildViews();

  TournamentParticipantId? get championId {
    final views = matches;
    final reset = views.firstWhere(
      (view) => view.definition.stage == BracketStage.grandFinalReset,
    );
    if (reset.status == BracketMatchStatus.completed) return reset.winnerId;
    final grandFinal = views.firstWhere(
      (view) => view.definition.stage == BracketStage.grandFinal,
    );
    if (grandFinal.status == BracketMatchStatus.completed &&
        grandFinal.winnerId == grandFinal.firstParticipantId) {
      return grandFinal.winnerId;
    }
    return null;
  }

  bool get isCompleted => championId != null;

  Map<TournamentParticipantId, int> get lossCount {
    final losses = {
      for (final participant in topology.participants) participant: 0,
    };
    for (final view in matches) {
      if (view.status == BracketMatchStatus.completed && view.loserId != null) {
        losses[view.loserId!] = losses[view.loserId!]! + 1;
      }
    }
    return Map.unmodifiable(losses);
  }

  List<List<TournamentParticipantId>> get sharedPlacementGroups {
    return [
      for (final group in placementGroups)
        if (group.length > 1) group,
    ];
  }

  List<List<TournamentParticipantId>> get placementGroups {
    if (!isCompleted) return const [];
    final secondLossGroups = <String, List<TournamentParticipantId>>{};
    final losses = {
      for (final participant in topology.participants) participant: 0,
    };
    for (final view in matches) {
      final loser = view.loserId;
      if (view.status != BracketMatchStatus.completed || loser == null) {
        continue;
      }
      losses[loser] = losses[loser]! + 1;
      if (losses[loser] == 2 && loser != championId) {
        final key = '${view.definition.stage.name}:${view.definition.round}';
        secondLossGroups.putIfAbsent(key, () => []).add(loser);
      }
    }
    return [
      [championId!],
      for (final group in secondLossGroups.values.toList().reversed)
        List<TournamentParticipantId>.unmodifiable(group),
    ];
  }

  DoubleEliminationBracket recordResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    final view = matches.firstWhere(
      (item) => item.definition.id == matchId,
      orElse: () => throw const TournamentValidationException(
        'Матч не принадлежит Double Elimination bracket.',
      ),
    );
    if (view.status == BracketMatchStatus.completed &&
        view.result!.updateId == updateId) {
      return this;
    }
    if (view.status != BracketMatchStatus.ready) {
      throw const TournamentConflictException(
        'Результат можно ввести только для готового матча.',
      );
    }
    final result = EliminationMatchResult(
      matchId: matchId,
      firstParticipantId: view.firstParticipantId!,
      secondParticipantId: view.secondParticipantId!,
      winnerId: winnerId,
      updateId: updateId,
    );
    return DoubleEliminationBracket(
      topology: topology,
      results: {...results, matchId: result},
    );
  }

  DoubleEliminationBracket correctResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    if (!results.containsKey(matchId)) {
      throw const TournamentConflictException(
        'Исправлять можно только сохранённый результат.',
      );
    }
    final affectedIds = _descendantIds(matchId)..add(matchId);
    final retained = Map<TournamentMatchId, EliminationMatchResult>.from(
      results,
    )..removeWhere((id, _) => affectedIds.contains(id));
    return DoubleEliminationBracket(
      topology: topology,
      results: retained,
    ).recordResult(matchId: matchId, winnerId: winnerId, updateId: updateId);
  }

  Set<TournamentMatchId> _descendantIds(TournamentMatchId matchId) {
    final descendants = <TournamentMatchId>{};
    var changed = true;
    while (changed) {
      changed = false;
      for (final definition in topology.matches) {
        if (descendants.contains(definition.id)) continue;
        final sources = definition.sourceMatchIds;
        if (sources.contains(matchId) || sources.any(descendants.contains)) {
          descendants.add(definition.id);
          changed = true;
        }
      }
    }
    return descendants;
  }

  List<DoubleEliminationMatchView> _buildViews({
    bool validateStoredResults = false,
  }) {
    final viewsById = <TournamentMatchId, DoubleEliminationMatchView>{};
    for (final definition in topology.matches) {
      if (definition.stage == BracketStage.grandFinalReset) {
        final grandFinal = viewsById[definition.firstSource.matchId];
        final needsReset =
            grandFinal?.status == BracketMatchStatus.completed &&
            grandFinal!.winnerId == grandFinal.secondParticipantId;
        if (!needsReset) {
          viewsById[definition.id] = DoubleEliminationMatchView(
            definition: definition,
            status: BracketMatchStatus.skipped,
          );
          continue;
        }
      }
      final first = _resolve(definition.firstSource, viewsById);
      final second = _resolve(definition.secondSource, viewsById);
      if (!first.isResolved || !second.isResolved) {
        viewsById[definition.id] = DoubleEliminationMatchView(
          definition: definition,
          status: BracketMatchStatus.waiting,
        );
        continue;
      }
      if (first.participantId == null && second.participantId == null) {
        viewsById[definition.id] = DoubleEliminationMatchView(
          definition: definition,
          status: BracketMatchStatus.skipped,
        );
        continue;
      }
      if (first.participantId == null || second.participantId == null) {
        final winner = first.participantId ?? second.participantId;
        viewsById[definition.id] = DoubleEliminationMatchView(
          definition: definition,
          status: BracketMatchStatus.automatic,
          firstParticipantId: first.participantId,
          secondParticipantId: second.participantId,
          winnerId: winner,
        );
        continue;
      }
      if (first.participantId == second.participantId) {
        throw const TournamentValidationException(
          'Участник не может встретиться сам с собой в bracket.',
        );
      }
      final stored = results[definition.id];
      final hasExpectedPair =
          stored != null &&
          stored.firstParticipantId == first.participantId &&
          stored.secondParticipantId == second.participantId;
      if (stored != null && !hasExpectedPair && validateStoredResults) {
        throw const TournamentValidationException(
          'Сохранённый результат не соответствует рассчитанным slots.',
        );
      }
      final result = hasExpectedPair ? stored : null;
      viewsById[definition.id] = DoubleEliminationMatchView(
        definition: definition,
        status: result == null
            ? BracketMatchStatus.ready
            : BracketMatchStatus.completed,
        firstParticipantId: first.participantId,
        secondParticipantId: second.participantId,
        result: result,
        winnerId: result?.winnerId,
        loserId: result?.loserId,
      );
    }
    return List.unmodifiable(
      topology.matches.map((definition) => viewsById[definition.id]!),
    );
  }

  _ResolvedSlot _resolve(
    BracketSlotSource source,
    Map<TournamentMatchId, DoubleEliminationMatchView> viewsById,
  ) {
    if (source.type == BracketSlotSourceType.seed) {
      return _ResolvedSlot(
        isResolved: true,
        participantId: topology.seededSlots[source.seedIndex!],
      );
    }
    final sourceView = viewsById[source.matchId];
    if (sourceView == null ||
        (sourceView.status != BracketMatchStatus.completed &&
            sourceView.status != BracketMatchStatus.automatic &&
            sourceView.status != BracketMatchStatus.skipped)) {
      return const _ResolvedSlot(isResolved: false);
    }
    return _ResolvedSlot(
      isResolved: true,
      participantId: source.type == BracketSlotSourceType.winner
          ? sourceView.winnerId
          : sourceView.loserId,
    );
  }

  @override
  List<Object> get props => [topology, results];
}

final class _ResolvedSlot {
  const _ResolvedSlot({required this.isResolved, this.participantId});

  final bool isResolved;
  final TournamentParticipantId? participantId;
}
