import '../../domain/game/game_definition.dart';
import '../../domain/profile/local_profile.dart';
import '../../domain/tournament/engine/tournament_engines.dart';
import '../../domain/tournament/fighter_assignment_policy.dart';
import '../../domain/tournament/host_tournament.dart';
import '../../domain/tournament/tournament_ids.dart';
import '../../domain/tournament/tournament_models.dart';
import '../persistence/models/persisted_command_result.dart';
import '../persistence/models/persisted_history_snapshot.dart';
import '../persistence/models/persisted_tournament_event.dart';
import '../persistence/ports/active_tournament_store.dart';
import '../persistence/ports/tournament_history_store.dart';
import 'mappers/host_tournament_snapshot_mapper.dart';
import 'models/host_tournament_session.dart';

typedef UtcClock = DateTime Function();
typedef StableIdGenerator = String Function(String prefix);

final class HostTournamentService {
  HostTournamentService(
    this._activeStore,
    this._historyStore,
    this._engineRegistry,
    this._game,
    this._clock,
    this._idGenerator, [
    this._assignmentPolicy = const FighterAssignmentPolicy(),
  ]);

  final ActiveTournamentStore _activeStore;
  final TournamentHistoryStore _historyStore;
  final TournamentFormatEngineRegistry _engineRegistry;
  final GameDefinition _game;
  final UtcClock _clock;
  final StableIdGenerator _idGenerator;
  final FighterAssignmentPolicy _assignmentPolicy;

  Future<HostTournamentSession?> loadActive() async {
    final snapshot = await _activeStore.readActive();
    return snapshot == null
        ? null
        : HostTournamentSnapshotMapper.fromSnapshot(snapshot, _engineRegistry);
  }

  Future<HostTournamentSession> createDraft({
    required LocalProfile profile,
    required String title,
    required String formatId,
  }) async {
    _engine(formatId);
    if (await _activeStore.readActive() != null) {
      throw StateError('An active tournament already exists.');
    }
    final now = _clock().toUtc();
    final tournament = HostTournament.createDraft(
      id: _idGenerator('tournament'),
      title: title,
      formatId: formatId,
      nowUtc: now,
    );
    return _commitActive(
      previous: HostTournamentSession(
        tournament: tournament,
        localProfileId: profile.id,
        storageRevision: 0,
        lastSequence: 0,
      ),
      nextTournament: tournament,
      eventType: 'tournament_created',
      payload: {'formatId': formatId},
      expectedRevision: 0,
    );
  }

  Future<HostTournamentSession> updateDraft(
    HostTournamentSession session, {
    required String title,
    required String formatId,
  }) {
    _engine(formatId);
    return _mutateTournament(
      session,
      eventType: 'draft_updated',
      payload: {'formatId': formatId},
      mutate: (value, now) =>
          value.updateDraft(title: title, formatId: formatId, nowUtc: now),
    );
  }

  Future<HostTournamentSession> open(HostTournamentSession session) =>
      _mutateTournament(
        session,
        eventType: 'lobby_opened',
        mutate: (value, now) => value.open(nowUtc: now),
      );

  Future<HostTournamentSession> addGuest(
    HostTournamentSession session, {
    required String nickname,
  }) => _mutateTournament(
    session,
    eventType: 'guest_added',
    mutate: (value, now) => value.addGuest(
      guestId: GuestId(value.id, _idGenerator('guest')),
      nickname: nickname,
      nowUtc: now,
    ),
  );

  Future<HostTournamentSession> addLocalProfile(
    HostTournamentSession session, {
    required LocalProfile profile,
  }) => _mutateTournament(
    session,
    eventType: 'local_profile_added',
    mutate: (value, now) => value.addLocalProfile(
      profileId: profile.id,
      nickname: profile.nickname,
      nowUtc: now,
    ),
  );

  Future<HostTournamentSession> removeParticipant(
    HostTournamentSession session, {
    required TournamentParticipantId participantId,
  }) => _mutateTournament(
    session,
    eventType: 'participant_removed',
    payload: {'participantId': participantId.value},
    mutate: (value, now) =>
        value.removeParticipant(participantId: participantId, nowUtc: now),
  );

  Future<HostTournamentSession> startDistribution(
    HostTournamentSession session, {
    required int assignmentSeed,
  }) {
    final now = _clock().toUtc();
    var tournament = session.tournament.startDistribution(nowUtc: now);
    final assignments = _assignmentPolicy.assign(
      participants: tournament.participants.map((value) => value.id).toList(),
      game: _game,
      seed: assignmentSeed,
    );
    tournament = tournament.assignFighters(
      assignmentSet: assignments,
      nowUtc: now,
    );
    return _commitActive(
      previous: session,
      nextTournament: tournament,
      eventType: 'distribution_started',
      payload: {'assignmentSeed': assignmentSeed},
    );
  }

  Future<HostTournamentSession> rerollAll(
    HostTournamentSession session, {
    required int assignmentSeed,
  }) {
    final previous = session.tournament.assignments;
    if (previous == null) throw StateError('Assignments are not created.');
    final assignments = _assignmentPolicy.rerollAll(
      previous: previous,
      participants: session.tournament.participants
          .map((value) => value.id)
          .toList(),
      game: _game,
      seed: assignmentSeed,
    );
    final tournament = session.tournament.assignFighters(
      assignmentSet: assignments,
      nowUtc: _clock().toUtc(),
    );
    return _commitActive(
      previous: session,
      nextTournament: tournament,
      eventType: 'fighters_rerolled',
      payload: {'assignmentSeed': assignmentSeed},
    );
  }

  Future<HostTournamentSession> backToOpen(HostTournamentSession session) =>
      _mutateTournament(
        session,
        eventType: 'distribution_reopened',
        mutate: (value, now) => value.backToOpen(nowUtc: now),
        clearEngineState: true,
      );

  Future<HostTournamentSession> startRunning(
    HostTournamentSession session, {
    required int bracketSeed,
  }) {
    final tournament = session.tournament.startRunning(
      nowUtc: _clock().toUtc(),
    );
    final engine = _engine(tournament.formatId);
    final state = engine.create(
      participants: tournament.participants.map((value) => value.id).toList(),
      seed: bracketSeed,
    );
    return _commitActive(
      previous: session,
      nextTournament: tournament,
      nextEngineState: state,
      eventType: 'tournament_started',
      payload: {'bracketSeed': bracketSeed},
    );
  }

  Future<HostTournamentSession> submitResult(
    HostTournamentSession session, {
    required TournamentMatchResult result,
  }) {
    final state = _requireEngineState(session);
    final next = _engine(session.tournament.formatId).submitResult(
      state: state,
      matchId: state.currentMatch!.id,
      result: result,
    );
    return _commitActive(
      previous: session,
      nextTournament: session.tournament,
      nextEngineState: next,
      eventType: 'match_finished',
      payload: {'matchId': state.currentMatch!.id},
    );
  }

  Future<HostTournamentSession> correctResult(
    HostTournamentSession session, {
    required String matchId,
    required TournamentMatchResult result,
  }) {
    final next = _engine(session.tournament.formatId).correctResult(
      state: _requireEngineState(session),
      matchId: matchId,
      result: result,
    );
    return _commitActive(
      previous: session,
      nextTournament: session.tournament,
      nextEngineState: next,
      eventType: 'result_corrected',
      payload: {'matchId': matchId},
    );
  }

  Future<HostTournamentSession> withdraw(
    HostTournamentSession session, {
    required TournamentParticipantId participantId,
  }) {
    final next = _engine(session.tournament.formatId).withdrawParticipant(
      state: _requireEngineState(session),
      participantId: participantId,
    );
    return _commitActive(
      previous: session,
      nextTournament: session.tournament,
      nextEngineState: next,
      eventType: 'participant_withdrawn',
      payload: {'participantId': participantId.value},
    );
  }

  Future<HostTournamentSession> finish(HostTournamentSession session) {
    final state = _requireEngineState(session);
    final engineOutcome = state.outcome;
    if (engineOutcome == null) throw StateError('Final ranking is not ready.');
    final tournament = session.tournament.finish(
      outcome: TournamentFinalOutcome(
        championId: engineOutcome.championId,
        ranking: engineOutcome.ranking
            .map((value) => value.participantId)
            .toList(),
      ),
      nowUtc: _clock().toUtc(),
    );
    return _commitTerminal(
      session.copyWith(tournament: tournament),
      eventType: 'tournament_finished',
    );
  }

  Future<HostTournamentSession> cancel(
    HostTournamentSession session, {
    required String reason,
  }) => _commitTerminal(
    session.copyWith(
      tournament: session.tournament.cancel(
        reason: reason,
        nowUtc: _clock().toUtc(),
      ),
    ),
    eventType: 'tournament_cancelled',
  );

  Future<HostTournamentSession> _mutateTournament(
    HostTournamentSession session, {
    required String eventType,
    required HostTournament Function(HostTournament, DateTime) mutate,
    Map<String, Object?> payload = const {},
    bool clearEngineState = false,
  }) => _commitActive(
    previous: session,
    nextTournament: mutate(session.tournament, _clock().toUtc()),
    eventType: eventType,
    payload: payload,
    clearEngineState: clearEngineState,
  );

  Future<HostTournamentSession> _commitActive({
    required HostTournamentSession previous,
    required HostTournament nextTournament,
    required String eventType,
    Map<String, Object?> payload = const {},
    int? expectedRevision,
    FormatEngineState? nextEngineState,
    bool clearEngineState = false,
  }) async {
    final revision = (expectedRevision ?? previous.storageRevision) + 1;
    final sequence = previous.lastSequence + 1;
    final next = previous.copyWith(
      tournament: nextTournament,
      storageRevision: revision,
      lastSequence: sequence,
      engineState: nextEngineState,
      clearEngineState: clearEngineState,
    );
    final commandId = _idGenerator('command');
    final result = await _activeStore.commitMutation(
      expectedRevision: expectedRevision ?? previous.storageRevision,
      snapshot: HostTournamentSnapshotMapper.toSnapshot(
        next,
        revision: revision,
      ),
      events: [
        PersistedTournamentEvent(
          eventId: _idGenerator('event'),
          tournamentId: nextTournament.id,
          sequence: sequence,
          revision: revision,
          eventVersion: 1,
          type: eventType,
          timestampUtc: _clock().toUtc(),
          payload: payload,
        ),
      ],
      commandResult: PersistedCommandResult(
        commandId: commandId,
        tournamentId: nextTournament.id,
        revision: revision,
        payload: {'eventType': eventType},
      ),
    );
    if (result.status == ActiveCommitStatus.duplicateCommand) {
      return (await loadActive())!;
    }
    return next;
  }

  Future<HostTournamentSession> _commitTerminal(
    HostTournamentSession session, {
    required String eventType,
  }) async {
    final revision = session.storageRevision + 1;
    final sequence = session.lastSequence + 1;
    final terminal = session.copyWith(
      storageRevision: revision,
      lastSequence: sequence,
    );
    final event = PersistedTournamentEvent(
      eventId: _idGenerator('event'),
      tournamentId: session.tournament.id,
      sequence: sequence,
      revision: revision,
      eventVersion: 1,
      type: eventType,
      timestampUtc: _clock().toUtc(),
      payload: const {},
    );
    await _historyStore.commitTerminal(
      history: PersistedHistorySnapshot(
        snapshot: HostTournamentSnapshotMapper.toSnapshot(
          terminal,
          revision: revision,
        ),
        finishedAtUtc: session.tournament.updatedAtUtc,
      ),
      terminalEvent: event,
    );
    return terminal;
  }

  FormatEngineState _requireEngineState(HostTournamentSession session) {
    final state = session.engineState;
    if (state == null) throw StateError('Tournament engine is not started.');
    return state;
  }

  TournamentFormatEngine _engine(String formatId) =>
      _engineRegistry.resolve(switch (formatId) {
        'double-elimination' => TournamentFormat.doubleElimination,
        'single-elimination' => TournamentFormat.singleElimination,
        'round-robin' => TournamentFormat.roundRobin,
        _ => throw FormatException('Unsupported format: $formatId.'),
      }, tournamentRulesetV1);
}
