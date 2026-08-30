import '../tournament_ids.dart';

const tournamentRulesetV1 = 'tournament-format-engine/v1';

enum TournamentFormat { doubleElimination, singleElimination, roundRobin }

enum TournamentMatchStatus { upcoming, current, finished }

enum TournamentMatchStage {
  main,
  winners,
  losers,
  finalMatch,
  bracketReset,
  tieBreak,
}

enum TechnicalResultReason { forfeit, withdrawal }

sealed class TournamentMatchResult {
  const TournamentMatchResult({required this.winnerId, required this.loserId});

  final TournamentParticipantId winnerId;
  final TournamentParticipantId loserId;
}

final class NormalMatchResult extends TournamentMatchResult {
  const NormalMatchResult({
    required super.winnerId,
    required super.loserId,
    required this.winnerScore,
    required this.loserScore,
  });

  final int winnerScore;
  final int loserScore;
}

final class TechnicalMatchResult extends TournamentMatchResult {
  const TechnicalMatchResult({
    required super.winnerId,
    required super.loserId,
    required this.reason,
  });

  final TechnicalResultReason reason;
}

final class TournamentMatch {
  const TournamentMatch({
    required this.id,
    required this.round,
    required this.order,
    required this.stage,
    required this.firstTo,
    required this.firstParticipantId,
    required this.secondParticipantId,
    required this.status,
    this.result,
  });

  final String id;
  final int round;
  final int order;
  final TournamentMatchStage stage;
  final int firstTo;
  final TournamentParticipantId firstParticipantId;
  final TournamentParticipantId secondParticipantId;
  final TournamentMatchStatus status;
  final TournamentMatchResult? result;

  TournamentMatch finish(TournamentMatchResult value) => TournamentMatch(
    id: id,
    round: round,
    order: order,
    stage: stage,
    firstTo: firstTo,
    firstParticipantId: firstParticipantId,
    secondParticipantId: secondParticipantId,
    status: TournamentMatchStatus.finished,
    result: value,
  );

  TournamentMatch makeCurrent() => TournamentMatch(
    id: id,
    round: round,
    order: order,
    stage: stage,
    firstTo: firstTo,
    firstParticipantId: firstParticipantId,
    secondParticipantId: secondParticipantId,
    status: TournamentMatchStatus.current,
    result: result,
  );
}

final class TournamentPlacement {
  const TournamentPlacement({
    required this.participantId,
    required this.from,
    required this.to,
  });

  final TournamentParticipantId participantId;
  final int from;
  final int to;

  bool get isExact => from == to;
}

final class TournamentEngineOutcome {
  const TournamentEngineOutcome({
    required this.championId,
    required this.ranking,
  });

  final TournamentParticipantId championId;
  final List<TournamentPlacement> ranking;
}

abstract class FormatEngineState {
  const FormatEngineState();

  TournamentFormat get format;
  String get rulesetVersion;
  List<TournamentParticipantId> get participants;
  List<TournamentMatch> get matches;
  TournamentEngineOutcome? get outcome;

  TournamentMatch? get currentMatch {
    final current = matches.where(
      (match) => match.status == TournamentMatchStatus.current,
    );
    return current.isEmpty ? null : current.single;
  }

  bool get isComplete => outcome != null;
}

abstract interface class TournamentFormatEngine {
  TournamentFormat get format;
  String get rulesetVersion;

  FormatEngineState create({
    required List<TournamentParticipantId> participants,
    required int seed,
  });

  FormatEngineState submitResult({
    required FormatEngineState state,
    required String matchId,
    required TournamentMatchResult result,
  });

  FormatEngineState withdrawParticipant({
    required FormatEngineState state,
    required TournamentParticipantId participantId,
  });
}

final class TournamentFormatEngineRegistry {
  TournamentFormatEngineRegistry(Iterable<TournamentFormatEngine> engines)
    : _engines = {
        for (final engine in engines)
          (engine.format, engine.rulesetVersion): engine,
      } {
    if (_engines.length != engines.length) {
      throw const FormatException('Duplicate format engine registration.');
    }
  }

  final Map<(TournamentFormat, String), TournamentFormatEngine> _engines;

  TournamentFormatEngine resolve(
    TournamentFormat format,
    String rulesetVersion,
  ) {
    final engine = _engines[(format, rulesetVersion)];
    if (engine == null) {
      throw StateError('Unsupported ruleset: $format/$rulesetVersion.');
    }
    return engine;
  }
}

void validateParticipants(List<TournamentParticipantId> participants) {
  if (participants.length < 2) {
    throw const FormatException('At least two participants are required.');
  }
  if (participants.toSet().length != participants.length) {
    throw const FormatException('Participant IDs must be unique.');
  }
  final tournamentIds = participants.map((id) => id.tournamentId).toSet();
  if (tournamentIds.length != 1) {
    throw const FormatException('Participants must belong to one tournament.');
  }
}

void validateResult(TournamentMatch match, TournamentMatchResult result) {
  if (match.status != TournamentMatchStatus.current) {
    throw StateError('Only the current match can be finished.');
  }
  final expected = {match.firstParticipantId, match.secondParticipantId};
  if (result.winnerId == result.loserId ||
      !expected.contains(result.winnerId) ||
      !expected.contains(result.loserId)) {
    throw const FormatException('Result participants do not match the battle.');
  }
  if (result case NormalMatchResult normal) {
    if (normal.winnerScore != match.firstTo ||
        normal.loserScore < 0 ||
        normal.loserScore >= match.firstTo) {
      throw FormatException(
        'Normal score must end at FT${match.firstTo} without a draw.',
      );
    }
  }
}

List<TournamentParticipantId> seededOrder(
  List<TournamentParticipantId> source,
  int seed,
) {
  final result = List<TournamentParticipantId>.of(source);
  var state = seed & 0x7fffffff;
  if (state == 0) state = 0x13579b;
  int nextInt(int max) {
    state ^= (state << 13) & 0x7fffffff;
    state ^= state >> 17;
    state ^= (state << 5) & 0x7fffffff;
    return (state & 0x7fffffff) % max;
  }

  for (var index = result.length - 1; index > 0; index--) {
    final swapWith = nextInt(index + 1);
    final value = result[index];
    result[index] = result[swapWith];
    result[swapWith] = value;
  }
  return result;
}

List<TournamentMatch> activateFirstUpcoming(List<TournamentMatch> matches) {
  if (matches.any((match) => match.status == TournamentMatchStatus.current)) {
    return List.unmodifiable(matches);
  }
  var activated = false;
  return List.unmodifiable(
    matches.map((match) {
      if (!activated && match.status == TournamentMatchStatus.upcoming) {
        activated = true;
        return match.makeCurrent();
      }
      return match;
    }),
  );
}
