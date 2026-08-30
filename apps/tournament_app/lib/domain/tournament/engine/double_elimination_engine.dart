import '../tournament_ids.dart';
import 'format_engine.dart';
import 'single_elimination_engine.dart';

final class DoubleEliminationState extends FormatEngineState {
  const DoubleEliminationState({
    required this.participants,
    required this.matches,
    required this.wave,
    required this.losses,
    required this.eliminatedByStage,
    required this.outcome,
    required this.seed,
    this.withdrawnParticipants = const {},
  });

  @override
  TournamentFormat get format => TournamentFormat.doubleElimination;
  @override
  String get rulesetVersion => tournamentRulesetV1;
  @override
  final List<TournamentParticipantId> participants;
  @override
  final int seed;
  @override
  final List<TournamentMatch> matches;
  final int wave;
  final Map<TournamentParticipantId, int> losses;
  final List<List<TournamentParticipantId>> eliminatedByStage;
  final Set<TournamentParticipantId> withdrawnParticipants;
  @override
  final TournamentEngineOutcome? outcome;
}

final class DoubleEliminationEngine implements TournamentFormatEngine {
  const DoubleEliminationEngine({this.settings = const EliminationSettings()});

  final EliminationSettings settings;

  @override
  TournamentFormat get format => TournamentFormat.doubleElimination;
  @override
  String get rulesetVersion => tournamentRulesetV1;

  @override
  DoubleEliminationState create({
    required List<TournamentParticipantId> participants,
    required int seed,
  }) {
    validateParticipants(participants);
    settings.validate();
    final ordered = seededOrder(participants, seed);
    final losses = {for (final participant in ordered) participant: 0};
    return _scheduleWave(
      participants: List.unmodifiable(participants),
      matches: const [],
      wave: 1,
      losses: losses,
      eliminatedByStage: const [],
      preferredOrder: ordered,
      seed: seed,
    );
  }

  @override
  DoubleEliminationState submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) => _resolveWithdrawals(
    _submitResult(state: state, matchId: matchId, result: result),
  );

  DoubleEliminationState _submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) {
    if (state is! DoubleEliminationState) {
      throw ArgumentError('Double Elimination state expected.');
    }
    if (state.isComplete) throw StateError('Tournament is already complete.');
    final current = state.currentMatch;
    if (current == null || current.id != matchId) {
      throw StateError('Result must target the current match.');
    }
    validateResult(current, result);
    final matches = state.matches
        .map((match) => match.id == matchId ? match.finish(result) : match)
        .toList();
    final losses = Map<TournamentParticipantId, int>.of(state.losses);
    losses[result.loserId] = losses[result.loserId]! + 1;
    final eliminated = state.eliminatedByStage
        .map((group) => List<TournamentParticipantId>.of(group))
        .toList();
    if (losses[result.loserId] == 2) {
      while (eliminated.length < state.wave) {
        eliminated.add([]);
      }
      eliminated[state.wave - 1].add(result.loserId);
    }

    if (matches.any(
      (match) => match.status == TournamentMatchStatus.upcoming,
    )) {
      return DoubleEliminationState(
        participants: state.participants,
        matches: activateFirstUpcoming(matches),
        wave: state.wave,
        losses: Map.unmodifiable(losses),
        eliminatedByStage: _freeze(eliminated),
        outcome: null,
        withdrawnParticipants: state.withdrawnParticipants,
        seed: state.seed,
      );
    }

    if (current.stage == TournamentMatchStage.bracketReset) {
      return _completed(state, matches, losses, eliminated, result.winnerId);
    }
    if (current.stage == TournamentMatchStage.finalMatch) {
      final loserLosses = losses[result.loserId]!;
      if (loserLosses >= 2) {
        return _completed(state, matches, losses, eliminated, result.winnerId);
      }
      final reset = TournamentMatch(
        id: 'de-reset',
        round: state.wave + 1,
        order: matches.length,
        stage: TournamentMatchStage.bracketReset,
        firstTo: settings.finalFirstTo,
        firstParticipantId: current.firstParticipantId,
        secondParticipantId: current.secondParticipantId,
        status: TournamentMatchStatus.current,
      );
      return DoubleEliminationState(
        participants: state.participants,
        matches: List.unmodifiable([...matches, reset]),
        wave: state.wave + 1,
        losses: Map.unmodifiable(losses),
        eliminatedByStage: _freeze(eliminated),
        outcome: null,
        withdrawnParticipants: state.withdrawnParticipants,
        seed: state.seed,
      );
    }

    return _scheduleWave(
      participants: state.participants,
      matches: matches,
      wave: state.wave + 1,
      losses: losses,
      eliminatedByStage: eliminated,
      preferredOrder: state.participants,
      withdrawnParticipants: state.withdrawnParticipants,
      seed: state.seed,
    );
  }

  @override
  DoubleEliminationState withdrawParticipant({
    required FormatEngineState state,
    required TournamentParticipantId participantId,
  }) {
    if (state is! DoubleEliminationState) {
      throw ArgumentError('Double Elimination state expected.');
    }
    if (state.isComplete) throw StateError('Tournament is already complete.');
    if (!state.participants.contains(participantId)) {
      throw const FormatException('Unknown participant.');
    }
    if (state.withdrawnParticipants.contains(participantId)) return state;
    return _resolveWithdrawals(
      DoubleEliminationState(
        participants: state.participants,
        matches: state.matches,
        wave: state.wave,
        losses: state.losses,
        eliminatedByStage: state.eliminatedByStage,
        outcome: state.outcome,
        seed: state.seed,
        withdrawnParticipants: Set.unmodifiable({
          ...state.withdrawnParticipants,
          participantId,
        }),
      ),
    );
  }

  @override
  DoubleEliminationState correctResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) {
    if (state is! DoubleEliminationState) {
      throw ArgumentError('Double Elimination state expected.');
    }
    return replayWithCorrectedResult(
      engine: this,
      state: state,
      matchId: matchId,
      replacement: result,
    ) as DoubleEliminationState;
  }

  DoubleEliminationState _resolveWithdrawals(DoubleEliminationState state) {
    var resolved = state;
    while (!resolved.isComplete) {
      final current = resolved.currentMatch;
      if (current == null) break;
      final firstOut = resolved.withdrawnParticipants.contains(
        current.firstParticipantId,
      );
      final secondOut = resolved.withdrawnParticipants.contains(
        current.secondParticipantId,
      );
      if (!firstOut && !secondOut) break;
      if (firstOut && secondOut) {
        throw StateError('A battle cannot contain two withdrawn participants.');
      }
      resolved = _submitResult(
        state: resolved,
        matchId: current.id,
        result: TechnicalMatchResult(
          winnerId: firstOut
              ? current.secondParticipantId
              : current.firstParticipantId,
          loserId: firstOut
              ? current.firstParticipantId
              : current.secondParticipantId,
          reason: TechnicalResultReason.withdrawal,
        ),
      );
    }
    return resolved;
  }

  DoubleEliminationState _scheduleWave({
    required List<TournamentParticipantId> participants,
    required List<TournamentMatch> matches,
    required int wave,
    required Map<TournamentParticipantId, int> losses,
    required List<List<TournamentParticipantId>> eliminatedByStage,
    required List<TournamentParticipantId> preferredOrder,
    required int seed,
    Set<TournamentParticipantId> withdrawnParticipants = const {},
  }) {
    final active = preferredOrder.where((id) => losses[id]! < 2).toList();
    if (active.length == 2) {
      final first = active.firstWhere(
        (id) => losses[id] == 0,
        orElse: () => active.first,
      );
      final second = active.firstWhere((id) => id != first);
      final finalMatch = TournamentMatch(
        id: 'de-final',
        round: wave,
        order: matches.length,
        stage: TournamentMatchStage.finalMatch,
        firstTo: settings.finalFirstTo,
        firstParticipantId: first,
        secondParticipantId: second,
        status: TournamentMatchStatus.current,
      );
      return DoubleEliminationState(
        participants: participants,
        matches: List.unmodifiable([...matches, finalMatch]),
        wave: wave,
        losses: Map.unmodifiable(losses),
        eliminatedByStage: _freeze(eliminatedByStage),
        outcome: null,
        seed: seed,
        withdrawnParticipants: Set.unmodifiable(withdrawnParticipants),
      );
    }

    final created = <TournamentMatch>[];
    for (final lossCount in [0, 1]) {
      final bracket = active.where((id) => losses[id] == lossCount).toList();
      for (var index = 0; index + 1 < bracket.length; index += 2) {
        created.add(
          TournamentMatch(
            id: 'de-w$wave-${lossCount == 0 ? 'w' : 'l'}-m${index ~/ 2 + 1}',
            round: wave,
            order: matches.length + created.length,
            stage: lossCount == 0
                ? TournamentMatchStage.winners
                : TournamentMatchStage.losers,
            firstTo: settings.mainFirstTo,
            firstParticipantId: bracket[index],
            secondParticipantId: bracket[index + 1],
            status: TournamentMatchStatus.upcoming,
          ),
        );
      }
    }
    if (created.isEmpty) {
      throw StateError('Double Elimination progression cannot create a match.');
    }
    return DoubleEliminationState(
      participants: participants,
      matches: activateFirstUpcoming([...matches, ...created]),
      wave: wave,
      losses: Map.unmodifiable(losses),
      eliminatedByStage: _freeze(eliminatedByStage),
      outcome: null,
      seed: seed,
      withdrawnParticipants: Set.unmodifiable(withdrawnParticipants),
    );
  }

  DoubleEliminationState _completed(
    DoubleEliminationState state,
    List<TournamentMatch> matches,
    Map<TournamentParticipantId, int> losses,
    List<List<TournamentParticipantId>> eliminated,
    TournamentParticipantId champion,
  ) {
    final placements = <TournamentPlacement>[
      TournamentPlacement(participantId: champion, from: 1, to: 1),
    ];
    var place = 2;
    for (final group in eliminated.reversed) {
      final withoutChampion = group.where((id) => id != champion).toList();
      if (withoutChampion.isEmpty) continue;
      final to = place + withoutChampion.length - 1;
      placements.addAll(
        withoutChampion.map(
          (id) => TournamentPlacement(participantId: id, from: place, to: to),
        ),
      );
      place = to + 1;
    }
    for (final participant in state.participants) {
      if (placements.any((place) => place.participantId == participant)) {
        continue;
      }
      placements.add(
        TournamentPlacement(participantId: participant, from: place, to: place),
      );
      place++;
    }
    return DoubleEliminationState(
      participants: state.participants,
      matches: List.unmodifiable(matches),
      wave: state.wave,
      losses: Map.unmodifiable(losses),
      eliminatedByStage: _freeze(eliminated),
      withdrawnParticipants: state.withdrawnParticipants,
      outcome: TournamentEngineOutcome(
        championId: champion,
        ranking: List.unmodifiable(placements),
      ),
      seed: state.seed,
    );
  }
}

List<List<TournamentParticipantId>> _freeze(
  Iterable<List<TournamentParticipantId>> groups,
) => List.unmodifiable(
  groups.map((group) => List<TournamentParticipantId>.unmodifiable(group)),
);
