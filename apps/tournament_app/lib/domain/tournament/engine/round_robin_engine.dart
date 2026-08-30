import '../tournament_ids.dart';
import 'format_engine.dart';

abstract interface class RoundRobinTieResolver {
  List<List<TournamentParticipantId>> resolveIteration({
    required List<TournamentParticipantId> participants,
    required Iterable<TournamentMatch> matches,
  });
}

final class RepeatedMiniRoundRobinTieResolver implements RoundRobinTieResolver {
  const RepeatedMiniRoundRobinTieResolver();

  @override
  List<List<TournamentParticipantId>> resolveIteration({
    required List<TournamentParticipantId> participants,
    required Iterable<TournamentMatch> matches,
  }) {
    final wins = {for (final id in participants) id: 0};
    for (final match in matches) {
      final result = match.result;
      if (result != null) wins[result.winnerId] = wins[result.winnerId]! + 1;
    }
    final byWins = <int, List<TournamentParticipantId>>{};
    for (final participant in participants) {
      byWins.putIfAbsent(wins[participant]!, () => []).add(participant);
    }
    final ordered = byWins.keys.toList()..sort((a, b) => b.compareTo(a));
    return List.unmodifiable(
      ordered.map(
        (score) => List<TournamentParticipantId>.unmodifiable(byWins[score]!),
      ),
    );
  }
}

final class RoundRobinStanding {
  const RoundRobinStanding({
    required this.participantId,
    required this.points,
    required this.wins,
    required this.losses,
  });

  final TournamentParticipantId participantId;
  final int points;
  final int wins;
  final int losses;
}

final class RoundRobinRankingGroup {
  const RoundRobinRankingGroup({
    required this.participants,
    required this.iteration,
  });

  final List<TournamentParticipantId> participants;
  final int iteration;
  bool get isResolved => participants.length == 1;
}

final class RoundRobinState extends FormatEngineState {
  const RoundRobinState({
    required this.participants,
    required this.matches,
    required this.mainMatchCount,
    required this.rankingGroups,
    required this.outcome,
    this.withdrawnParticipants = const {},
  });

  @override
  TournamentFormat get format => TournamentFormat.roundRobin;
  @override
  String get rulesetVersion => tournamentRulesetV1;
  @override
  final List<TournamentParticipantId> participants;
  @override
  final List<TournamentMatch> matches;
  final int mainMatchCount;
  final List<RoundRobinRankingGroup> rankingGroups;
  final Set<TournamentParticipantId> withdrawnParticipants;
  @override
  final TournamentEngineOutcome? outcome;

  List<RoundRobinStanding> get standings {
    final values = {
      for (final participant in participants)
        participant: [0, 0, 0], // points, wins, losses
    };
    for (final match in matches.take(mainMatchCount)) {
      final result = match.result;
      if (result == null) continue;
      final winner = values[result.winnerId]!;
      final loser = values[result.loserId]!;
      winner[1]++;
      loser[2]++;
      if (result is TechnicalMatchResult) {
        winner[0] += 3;
      } else if (result is NormalMatchResult && result.loserScore == 0) {
        winner[0] += 3;
      } else {
        winner[0] += 2;
        loser[0] += 1;
      }
    }
    return List.unmodifiable(
      participants.map(
        (id) => RoundRobinStanding(
          participantId: id,
          points: values[id]![0],
          wins: values[id]![1],
          losses: values[id]![2],
        ),
      ),
    );
  }
}

final class RoundRobinEngine implements TournamentFormatEngine {
  const RoundRobinEngine({
    this.tieResolver = const RepeatedMiniRoundRobinTieResolver(),
  });

  final RoundRobinTieResolver tieResolver;

  @override
  TournamentFormat get format => TournamentFormat.roundRobin;
  @override
  String get rulesetVersion => tournamentRulesetV1;

  @override
  RoundRobinState create({
    required List<TournamentParticipantId> participants,
    required int seed,
  }) {
    validateParticipants(participants);
    final ordered = seededOrder(participants, seed);
    final matches = _pairSchedule(
      participants: ordered,
      stage: TournamentMatchStage.main,
      idPrefix: 'rr-main',
      firstOrder: 0,
      firstRound: 1,
    );
    return RoundRobinState(
      participants: List.unmodifiable(participants),
      matches: activateFirstUpcoming(matches),
      mainMatchCount: matches.length,
      rankingGroups: const [],
      outcome: null,
    );
  }

  @override
  RoundRobinState submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) => _resolveWithdrawals(
    _submitResult(state: state, matchId: matchId, result: result),
  );

  RoundRobinState _submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  }) {
    if (state is! RoundRobinState) {
      throw ArgumentError('Round Robin state expected.');
    }
    if (state.isComplete) throw StateError('Tournament is already complete.');
    final current = state.currentMatch;
    if (current == null || current.id != matchId) {
      throw StateError('Result must target the current match.');
    }
    validateResult(current, result);
    var matches = state.matches
        .map((match) => match.id == matchId ? match.finish(result) : match)
        .toList();
    if (matches.any(
      (match) => match.status == TournamentMatchStatus.upcoming,
    )) {
      return RoundRobinState(
        participants: state.participants,
        matches: activateFirstUpcoming(matches),
        mainMatchCount: state.mainMatchCount,
        rankingGroups: state.rankingGroups,
        outcome: null,
        withdrawnParticipants: state.withdrawnParticipants,
      );
    }

    var groups = state.rankingGroups;
    if (groups.isEmpty) {
      groups = _groupsFromMain(state, matches);
    } else {
      groups = _resolveCurrentTie(groups, matches, current);
    }
    final unresolvedIndex = groups.indexWhere((group) => !group.isResolved);
    if (unresolvedIndex < 0) {
      final ranking = <TournamentPlacement>[];
      for (var index = 0; index < groups.length; index++) {
        ranking.add(
          TournamentPlacement(
            participantId: groups[index].participants.single,
            from: index + 1,
            to: index + 1,
          ),
        );
      }
      return RoundRobinState(
        participants: state.participants,
        matches: List.unmodifiable(matches),
        mainMatchCount: state.mainMatchCount,
        rankingGroups: groups,
        withdrawnParticipants: state.withdrawnParticipants,
        outcome: TournamentEngineOutcome(
          championId: ranking.first.participantId,
          ranking: List.unmodifiable(ranking),
        ),
      );
    }

    final group = groups[unresolvedIndex];
    final created = _pairSchedule(
      participants: group.participants,
      stage: TournamentMatchStage.tieBreak,
      idPrefix: 'rr-tie-g$unresolvedIndex-i${group.iteration}',
      firstOrder: matches.length,
      firstRound:
          (matches
              .map((match) => match.round)
              .fold(0, (a, b) => a > b ? a : b)) +
          1,
    );
    matches = [...matches, ...created];
    return RoundRobinState(
      participants: state.participants,
      matches: activateFirstUpcoming(matches),
      mainMatchCount: state.mainMatchCount,
      rankingGroups: groups,
      outcome: null,
      withdrawnParticipants: state.withdrawnParticipants,
    );
  }

  @override
  RoundRobinState withdrawParticipant({
    required FormatEngineState state,
    required TournamentParticipantId participantId,
  }) {
    if (state is! RoundRobinState) {
      throw ArgumentError('Round Robin state expected.');
    }
    if (state.isComplete) throw StateError('Tournament is already complete.');
    if (!state.participants.contains(participantId)) {
      throw const FormatException('Unknown participant.');
    }
    if (state.withdrawnParticipants.contains(participantId)) return state;
    return _resolveWithdrawals(
      RoundRobinState(
        participants: state.participants,
        matches: state.matches,
        mainMatchCount: state.mainMatchCount,
        rankingGroups: state.rankingGroups,
        outcome: state.outcome,
        withdrawnParticipants: Set.unmodifiable({
          ...state.withdrawnParticipants,
          participantId,
        }),
      ),
    );
  }

  RoundRobinState _resolveWithdrawals(RoundRobinState state) {
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

  List<RoundRobinRankingGroup> _groupsFromMain(
    RoundRobinState state,
    List<TournamentMatch> matches,
  ) {
    final completed = RoundRobinState(
      participants: state.participants,
      matches: matches,
      mainMatchCount: state.mainMatchCount,
      rankingGroups: const [],
      outcome: null,
    );
    final byPoints = <int, List<TournamentParticipantId>>{};
    for (final standing in completed.standings) {
      byPoints
          .putIfAbsent(standing.points, () => [])
          .add(standing.participantId);
    }
    final ordered = byPoints.keys.toList()..sort((a, b) => b.compareTo(a));
    return List.unmodifiable(
      ordered.map(
        (points) => RoundRobinRankingGroup(
          participants: List.unmodifiable(byPoints[points]!),
          iteration: 1,
        ),
      ),
    );
  }

  List<RoundRobinRankingGroup> _resolveCurrentTie(
    List<RoundRobinRankingGroup> groups,
    List<TournamentMatch> matches,
    TournamentMatch lastMatch,
  ) {
    final groupIndex = groups.indexWhere((group) => !group.isResolved);
    final group = groups[groupIndex];
    final prefix = 'rr-tie-g$groupIndex-i${group.iteration}-';
    final iterationMatches = matches.where(
      (match) => match.id.startsWith(prefix),
    );
    final resolved = tieResolver.resolveIteration(
      participants: group.participants,
      matches: iterationMatches,
    );
    final replacement = resolved.map(
      (participants) => RoundRobinRankingGroup(
        participants: participants,
        iteration: participants.length == 1
            ? group.iteration
            : group.iteration + 1,
      ),
    );
    return List.unmodifiable([
      ...groups.take(groupIndex),
      ...replacement,
      ...groups.skip(groupIndex + 1),
    ]);
  }

  List<TournamentMatch> _pairSchedule({
    required List<TournamentParticipantId> participants,
    required TournamentMatchStage stage,
    required String idPrefix,
    required int firstOrder,
    required int firstRound,
  }) {
    final rotation = <TournamentParticipantId?>[...participants];
    if (rotation.length.isOdd) rotation.add(null);
    final rounds = rotation.length - 1;
    final created = <TournamentMatch>[];
    for (var round = 0; round < rounds; round++) {
      for (var pair = 0; pair < rotation.length ~/ 2; pair++) {
        final first = rotation[pair];
        final second = rotation[rotation.length - 1 - pair];
        if (first == null || second == null) continue;
        created.add(
          TournamentMatch(
            id: '$idPrefix-r${round + 1}-m${pair + 1}',
            round: firstRound + round,
            order: firstOrder + created.length,
            stage: stage,
            firstTo: 2,
            firstParticipantId: first,
            secondParticipantId: second,
            status: TournamentMatchStatus.upcoming,
          ),
        );
      }
      final tail = rotation.removeLast();
      rotation.insert(1, tail);
    }
    return List.unmodifiable(created);
  }
}
