import '../../../domain/game/fighter.dart';
import '../../../domain/tournament/engine/tournament_engines.dart';
import '../../../domain/tournament/fighter_assignment.dart';
import '../../../domain/tournament/host_tournament.dart';
import '../../../domain/tournament/tournament_ids.dart';
import '../../../domain/tournament/tournament_models.dart';
import '../../persistence/models/persisted_tournament_snapshot.dart';
import '../models/host_tournament_session.dart';

abstract final class HostTournamentSnapshotMapper {
  static const schemaVersion = 1;
  static const rulesetVersion = 1;

  static PersistedTournamentSnapshot toSnapshot(
    HostTournamentSession session, {
    required int revision,
  }) {
    final tournament = session.tournament;
    return PersistedTournamentSnapshot(
      schemaVersion: schemaVersion,
      tournamentId: tournament.id,
      revision: revision,
      formatId: tournament.formatId,
      rulesetVersion: tournament.rulesetVersion,
      lifecycle: tournament.lifecycle.name,
      createdAtUtc: tournament.createdAtUtc,
      updatedAtUtc: tournament.updatedAtUtc,
      payload: {
        'localProfileId': session.localProfileId,
        'domainRevision': tournament.revision,
        'lastSequence': session.lastSequence,
        'title': tournament.title,
        'gameId': tournament.gameId,
        'participants': [
          for (final participant in tournament.participants)
            {
              'id': participant.id.value,
              'nickname': participant.nickname,
              'source': participant.source.name,
              'profileId': participant.profileId,
            },
        ],
        'assignments': tournament.assignments == null
            ? null
            : [
                for (final assignment in tournament.assignments!.values)
                  {
                    'participantId': assignment.participantId.value,
                    'fighterId': assignment.fighter.id.value,
                    'fighterName': assignment.fighter.displayName,
                    'assetPath': assignment.fighter.assetPath,
                  },
              ],
        'engine': session.engineState == null
            ? null
            : {
                'seed': session.engineState!.seed,
                'results': [
                  for (final match in session.engineState!.matches)
                    if (match.result != null) _result(match),
                ],
              },
        'outcome': tournament.finalOutcome == null
            ? null
            : {
                'championId': tournament.finalOutcome!.championId.value,
                'ranking': [
                  for (final id in tournament.finalOutcome!.ranking) id.value,
                ],
              },
        'cancellation': tournament.cancellation == null
            ? null
            : {
                'reason': tournament.cancellation!.reason,
                'cancelledAtUtc': tournament.cancellation!.cancelledAtUtc
                    .toIso8601String(),
              },
      },
    );
  }

  static HostTournamentSession fromSnapshot(
    PersistedTournamentSnapshot snapshot,
    TournamentFormatEngineRegistry registry,
  ) {
    if (snapshot.schemaVersion != schemaVersion ||
        snapshot.rulesetVersion != rulesetVersion) {
      throw const FormatException('Unsupported Host tournament snapshot.');
    }
    final payload = snapshot.payload;
    final participants = _list(payload, 'participants')
        .map((raw) {
          final value = _map(raw);
          return TournamentParticipant(
            id: TournamentParticipantId(
              snapshot.tournamentId,
              _string(value, 'id'),
            ),
            nickname: _string(value, 'nickname'),
            source: TournamentParticipantSource.values.byName(
              _string(value, 'source'),
            ),
            profileId: value['profileId'] as String?,
          );
        })
        .toList(growable: false);
    final byId = {
      for (final participant in participants)
        participant.id.value: participant.id,
    };
    final rawAssignments = payload['assignments'];
    final assignments = rawAssignments == null
        ? null
        : FighterAssignmentSet(
            (rawAssignments as List<Object?>).map((raw) {
              final value = _map(raw);
              return FighterAssignment(
                participantId: byId[_string(value, 'participantId')]!,
                fighter: Fighter(
                  id: FighterId(_string(value, 'fighterId')),
                  displayName: _string(value, 'fighterName'),
                  assetPath: _string(value, 'assetPath'),
                ),
              );
            }),
          );
    final lifecycle = TournamentLifecycle.values.byName(snapshot.lifecycle);
    final outcomeMap = payload['outcome'] == null
        ? null
        : _map(payload['outcome']);
    final cancellationMap = payload['cancellation'] == null
        ? null
        : _map(payload['cancellation']);
    final tournament = HostTournament.restore(
      id: snapshot.tournamentId,
      revision: _integer(payload, 'domainRevision'),
      title: _string(payload, 'title'),
      gameId: _string(payload, 'gameId'),
      formatId: snapshot.formatId,
      rulesetVersion: snapshot.rulesetVersion,
      lifecycle: lifecycle,
      participants: participants,
      assignments: assignments,
      createdAtUtc: snapshot.createdAtUtc,
      updatedAtUtc: snapshot.updatedAtUtc,
      finalOutcome: outcomeMap == null
          ? null
          : TournamentFinalOutcome(
              championId: byId[_string(outcomeMap, 'championId')]!,
              ranking: _list(
                outcomeMap,
                'ranking',
              ).map((value) => byId[value as String]!).toList(growable: false),
            ),
      cancellation: cancellationMap == null
          ? null
          : TournamentCancellation(
              reason: _string(cancellationMap, 'reason'),
              cancelledAtUtc: DateTime.parse(
                _string(cancellationMap, 'cancelledAtUtc'),
              ),
            ),
    );
    return HostTournamentSession(
      tournament: tournament,
      localProfileId: _string(payload, 'localProfileId'),
      storageRevision: snapshot.revision,
      lastSequence: _integer(payload, 'lastSequence'),
      engineState: _restoreEngine(snapshot, payload, participants, registry),
    );
  }

  static FormatEngineState? _restoreEngine(
    PersistedTournamentSnapshot snapshot,
    Map<String, Object?> payload,
    List<TournamentParticipant> participants,
    TournamentFormatEngineRegistry registry,
  ) {
    final rawEngine = payload['engine'];
    if (rawEngine == null) return null;
    final enginePayload = _map(rawEngine);
    final engine = registry.resolve(
      _format(snapshot.formatId),
      tournamentRulesetV1,
    );
    var state = engine.create(
      participants: participants.map((value) => value.id).toList(),
      seed: _integer(enginePayload, 'seed'),
    );
    for (final raw in _list(enginePayload, 'results')) {
      final resultPayload = _map(raw);
      final matchId = _string(resultPayload, 'matchId');
      final existing = state.matches
          .where((match) => match.id == matchId)
          .firstOrNull;
      if (existing?.result != null) continue;
      final result = _decodeResult(
        resultPayload,
        byId: {
          for (final participant in participants)
            participant.id.value: participant.id,
        },
      );
      if (result is TechnicalMatchResult &&
          result.reason == TechnicalResultReason.withdrawal) {
        state = engine.withdrawParticipant(
          state: state,
          participantId: result.loserId,
        );
      } else {
        state = engine.submitResult(
          state: state,
          matchId: matchId,
          result: result,
        );
      }
    }
    return state;
  }

  static Map<String, Object?> _result(TournamentMatch match) {
    final result = match.result!;
    return {
      'matchId': match.id,
      'winnerId': result.winnerId.value,
      'loserId': result.loserId.value,
      'type': result is NormalMatchResult ? 'normal' : 'technical',
      if (result is NormalMatchResult) ...{
        'winnerScore': result.winnerScore,
        'loserScore': result.loserScore,
      },
      if (result is TechnicalMatchResult) 'reason': result.reason.name,
    };
  }

  static TournamentMatchResult _decodeResult(
    Map<String, Object?> payload, {
    required Map<String, TournamentParticipantId> byId,
  }) {
    final winner = byId[_string(payload, 'winnerId')]!;
    final loser = byId[_string(payload, 'loserId')]!;
    if (_string(payload, 'type') == 'normal') {
      return NormalMatchResult(
        winnerId: winner,
        loserId: loser,
        winnerScore: _integer(payload, 'winnerScore'),
        loserScore: _integer(payload, 'loserScore'),
      );
    }
    return TechnicalMatchResult(
      winnerId: winner,
      loserId: loser,
      reason: TechnicalResultReason.values.byName(_string(payload, 'reason')),
    );
  }

  static TournamentFormat _format(String id) => switch (id) {
    'double-elimination' => TournamentFormat.doubleElimination,
    'single-elimination' => TournamentFormat.singleElimination,
    'round-robin' => TournamentFormat.roundRobin,
    _ => throw FormatException('Unsupported format: $id.'),
  };

  static Map<String, Object?> _map(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const FormatException('Snapshot object expected.');
    }
    return value;
  }

  static List<Object?> _list(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! List<Object?>) {
      throw FormatException('$key list expected.');
    }
    return value;
  }

  static String _string(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('$key string expected.');
    }
    return value;
  }

  static int _integer(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! int || value < 0) {
      throw FormatException('$key integer expected.');
    }
    return value;
  }
}
