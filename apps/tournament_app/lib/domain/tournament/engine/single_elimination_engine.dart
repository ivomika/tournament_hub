import '../tournament_ids.dart';
import 'format_engine.dart';

final class EliminationSettings {
  const EliminationSettings({this.mainFirstTo = 1, int? finalFirstTo})
    : finalFirstTo = finalFirstTo ?? mainFirstTo;

  final int mainFirstTo;
  final int finalFirstTo;

  void validate() {
    if (mainFirstTo <= 0 || finalFirstTo <= 0) {
      throw const FormatException('First To settings must be positive.');
    }
  }
}

final class SingleEliminationState extends FormatEngineState {
  const SingleEliminationState({
    required this.participants,
    required this.matches,
    required this.round,
    required this.roundEntrants,
    required this.roundWinners,
    required this.eliminatedByRound,
    required this.outcome,
    this.withdrawnParticipants = const {},
  });

  @override
  TournamentFormat get format => TournamentFormat.singleElimination;
  @override
  String get rulesetVersion => tournamentRulesetV1;
  @override
  final List<TournamentParticipantId> participants;
  @override
  final List<TournamentMatch> matches;
  final int round;
  final List<TournamentParticipantId> roundEntrants;
  final List<TournamentParticipantId> roundWinners;
  final List<List<TournamentParticipantId>> eliminatedByRound;
  final Set<TournamentParticipantId> withdrawnParticipants;
  @override
  final TournamentEngineOutcome? outcome;
}

final class SingleEliminationEngine implements TournamentFormatEngine {
  const SingleEliminationEngine({this.settings = const EliminationSettings()});

  final EliminationSettings settings;

  @override
  TournamentFormat get format => TournamentFormat.singleElimination;
  @override
  String get rulesetVersion => tournamentRulesetV1;

  @override
  SingleEliminationState create({
    required List<TournamentParticipantId> participants,
    required int seed,
  }) {
    validateParticipants(participants);
    settings.validate();
    final entrants = seededOrder(participants, seed);
    return _scheduleRound(
      participants: List.unmodifiable(participants),
      previousMatches: const [],
      round: 1,
      entrants: entrants,
      eliminatedByRound: const [],
    );
  }

  @override
  SingleEliminationState submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) => _resolveWithdrawals(
    _submitResult(state: state, matchId: matchId, result: result),
  );

  SingleEliminationState _submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) {
    if (state is! SingleEliminationState) {
      throw ArgumentError('Single Elimination state expected.');
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
    final winners = [...state.roundWinners, result.winnerId];
    final eliminated = state.eliminatedByRound
        .map((group) => List<TournamentParticipantId>.of(group))
        .toList();
    while (eliminated.length < state.round) {
      eliminated.add([]);
    }
    eliminated[state.round - 1].add(result.loserId);

    final hasRoundMatches = matches.any(
      (match) =>
          match.round == state.round &&
          match.status != TournamentMatchStatus.finished,
    );
    if (hasRoundMatches) {
      return SingleEliminationState(
        participants: state.participants,
        matches: activateFirstUpcoming(matches),
        round: state.round,
        roundEntrants: state.roundEntrants,
        roundWinners: List.unmodifiable(winners),
        eliminatedByRound: _freezeGroups(eliminated),
        outcome: null,
        withdrawnParticipants: state.withdrawnParticipants,
      );
    }
    if (winners.length == 1) {
      return SingleEliminationState(
        participants: state.participants,
        matches: List.unmodifiable(matches),
        round: state.round,
        roundEntrants: state.roundEntrants,
        roundWinners: List.unmodifiable(winners),
        eliminatedByRound: _freezeGroups(eliminated),
        outcome: _outcome(winners.single, eliminated),
        withdrawnParticipants: state.withdrawnParticipants,
      );
    }
    return _scheduleRound(
      participants: state.participants,
      previousMatches: matches,
      round: state.round + 1,
      entrants: winners,
      eliminatedByRound: eliminated,
      withdrawnParticipants: state.withdrawnParticipants,
    );
  }

  @override
  SingleEliminationState withdrawParticipant({
    required FormatEngineState state,
    required TournamentParticipantId participantId,
  }) {
    if (state is! SingleEliminationState) {
      throw ArgumentError('Single Elimination state expected.');
    }
    if (state.isComplete) throw StateError('Tournament is already complete.');
    if (!state.participants.contains(participantId)) {
      throw const FormatException('Unknown participant.');
    }
    if (state.withdrawnParticipants.contains(participantId)) return state;
    return _resolveWithdrawals(
      SingleEliminationState(
        participants: state.participants,
        matches: state.matches,
        round: state.round,
        roundEntrants: state.roundEntrants,
        roundWinners: state.roundWinners,
        eliminatedByRound: state.eliminatedByRound,
        outcome: state.outcome,
        withdrawnParticipants: Set.unmodifiable({
          ...state.withdrawnParticipants,
          participantId,
        }),
      ),
    );
  }

  SingleEliminationState _resolveWithdrawals(SingleEliminationState state) {
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

  SingleEliminationState _scheduleRound({
    required List<TournamentParticipantId> participants,
    required List<TournamentMatch> previousMatches,
    required int round,
    required List<TournamentParticipantId> entrants,
    required List<List<TournamentParticipantId>> eliminatedByRound,
    Set<TournamentParticipantId> withdrawnParticipants = const {},
  }) {
    final winners = <TournamentParticipantId>[];
    final created = <TournamentMatch>[];
    for (var index = 0; index < entrants.length; index += 2) {
      if (index + 1 == entrants.length) {
        winners.add(entrants[index]);
        continue;
      }
      final isFinal = entrants.length == 2;
      created.add(
        TournamentMatch(
          id: 'se-r$round-m${created.length + 1}',
          round: round,
          order: previousMatches.length + created.length,
          stage: isFinal
              ? TournamentMatchStage.finalMatch
              : TournamentMatchStage.main,
          firstTo: isFinal ? settings.finalFirstTo : settings.mainFirstTo,
          firstParticipantId: entrants[index],
          secondParticipantId: entrants[index + 1],
          status: TournamentMatchStatus.upcoming,
        ),
      );
    }
    return SingleEliminationState(
      participants: participants,
      matches: activateFirstUpcoming([...previousMatches, ...created]),
      round: round,
      roundEntrants: List.unmodifiable(entrants),
      roundWinners: List.unmodifiable(winners),
      eliminatedByRound: _freezeGroups(eliminatedByRound),
      outcome: null,
      withdrawnParticipants: Set.unmodifiable(withdrawnParticipants),
    );
  }

  TournamentEngineOutcome _outcome(
    TournamentParticipantId champion,
    List<List<TournamentParticipantId>> eliminated,
  ) {
    final placements = <TournamentPlacement>[
      TournamentPlacement(participantId: champion, from: 1, to: 1),
    ];
    var place = 2;
    for (final group in eliminated.reversed) {
      if (group.isEmpty) continue;
      final to = place + group.length - 1;
      placements.addAll(
        group.map(
          (id) => TournamentPlacement(participantId: id, from: place, to: to),
        ),
      );
      place = to + 1;
    }
    return TournamentEngineOutcome(
      championId: champion,
      ranking: List.unmodifiable(placements),
    );
  }
}

List<List<TournamentParticipantId>> _freezeGroups(
  Iterable<List<TournamentParticipantId>> groups,
) => List.unmodifiable(
  groups.map((group) => List<TournamentParticipantId>.unmodifiable(group)),
);
