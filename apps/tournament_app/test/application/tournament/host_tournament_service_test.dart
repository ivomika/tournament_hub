import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/tournament/host_tournament_service.dart';
import 'package:tournament_hub_app/domain/game/fighter.dart';
import 'package:tournament_hub_app/domain/game/game_definition.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';
import 'package:tournament_hub_app/domain/tournament/engine/tournament_engines.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_models.dart';
import 'package:tournament_hub_app/infrastructure/database/tournament_hub_database.dart'
    hide LocalProfile;
import 'package:tournament_hub_app/infrastructure/persistence/drift_active_tournament_store.dart';
import 'package:tournament_hub_app/infrastructure/persistence/drift_tournament_history_store.dart';

void main() {
  late TournamentHubDatabase database;
  late DriftActiveTournamentStore active;
  late DriftTournamentHistoryStore history;
  late HostTournamentService service;
  var id = 0;

  setUp(() {
    database = TournamentHubDatabase.memory();
    active = DriftActiveTournamentStore(database);
    history = DriftTournamentHistoryStore(database);
    id = 0;
    service = HostTournamentService(
      active,
      history,
      createTournamentFormatEngineRegistryV1(),
      _game(),
      () => DateTime.utc(2026, 8, 30, 12, 0, id),
      (prefix) => '$prefix-${++id}',
    );
  });

  tearDown(() => database.close());

  test(
    'Host completes offline Draft to Finished with restart recovery',
    () async {
      final profile = LocalProfile(id: 'profile-1', nickname: 'Организатор');
      var session = await service.createDraft(
        profile: profile,
        title: 'Friday Fight',
        formatId: 'single-elimination',
      );
      expect(
        (await service.loadActive())!.tournament.lifecycle,
        TournamentLifecycle.draft,
      );

      session = await service.open(session);
      session = await service.addLocalProfile(session, profile: profile);
      for (final nickname in ['Соня', 'Джакс', 'Китана']) {
        session = await service.addGuest(session, nickname: nickname);
      }
      expect(
        (await service.loadActive())!.tournament.participants,
        hasLength(4),
      );
      expect(
        (await service.loadActive())!.tournament.lifecycle,
        TournamentLifecycle.open,
      );

      final removedGuest = session.tournament.participants.last;
      session = await service.removeParticipant(
        session,
        participantId: removedGuest.id,
      );
      expect(session.tournament.participants, hasLength(3));
      session = await service.addGuest(session, nickname: 'Милина');

      session = await service.startDistribution(session, assignmentSeed: 10);
      expect(
        (await service.loadActive())!.tournament.lifecycle,
        TournamentLifecycle.distribution,
      );
      session = await service.backToOpen(session);
      expect(session.tournament.assignments, isNull);
      expect((await service.loadActive())!.tournament.assignments, isNull);
      session = await service.startDistribution(session, assignmentSeed: 10);
      final firstAssignments = session.tournament.assignments!;
      session = await service.rerollAll(session, assignmentSeed: 20);
      expect(
        session.tournament.participants.every(
          (participant) =>
              firstAssignments.forParticipant(participant.id).fighter.id !=
              session.tournament.assignments!
                  .forParticipant(participant.id)
                  .fighter
                  .id,
        ),
        isTrue,
      );

      session = await service.startRunning(session, bracketSeed: 42);
      expect(
        () => service.rerollAll(session, assignmentSeed: 30),
        throwsA(isA<Exception>()),
      );
      session = (await service.loadActive())!;
      expect(session.engineState!.currentMatch, isNotNull);
      final first = session.engineState!.currentMatch!;
      session = await service.submitResult(
        session,
        result: NormalMatchResult(
          winnerId: first.firstParticipantId,
          loserId: first.secondParticipantId,
          winnerScore: first.firstTo,
          loserScore: 0,
        ),
      );
      session = await service.correctResult(
        session,
        matchId: first.id,
        result: NormalMatchResult(
          winnerId: first.secondParticipantId,
          loserId: first.firstParticipantId,
          winnerScore: first.firstTo,
          loserScore: 0,
        ),
      );
      final events = await active.readEventsAfter(
        tournamentId: session.tournament.id,
        sequence: 0,
      );
      expect(events.last.type, 'result_corrected');

      var guard = 0;
      while (!session.engineState!.isComplete && guard++ < 20) {
        final match = session.engineState!.currentMatch!;
        session = await service.submitResult(
          session,
          result: NormalMatchResult(
            winnerId: match.firstParticipantId,
            loserId: match.secondParticipantId,
            winnerScore: match.firstTo,
            loserScore: 0,
          ),
        );
      }
      expect(session.engineState!.outcome, isNotNull);

      session = await service.finish(session);
      expect(session.tournament.lifecycle, TournamentLifecycle.finished);
      expect(
        session.tournament.finalOutcome!.championId,
        session.engineState!.outcome!.championId,
      );
      expect(await service.loadActive(), isNull);
      expect(await history.readAll(), hasLength(1));
    },
  );

  test('Cancelled stores facts without invented ranking', () async {
    final session = await service.createDraft(
      profile: LocalProfile(id: 'profile-1', nickname: 'Host'),
      title: 'Cancelled cup',
      formatId: 'round-robin',
    );

    final cancelled = await service.cancel(
      session,
      reason: 'Организатор отменил',
    );

    expect(cancelled.tournament.lifecycle, TournamentLifecycle.cancelled);
    expect(cancelled.tournament.cancellation, isNotNull);
    expect(cancelled.tournament.finalOutcome, isNull);
    expect(await service.loadActive(), isNull);
    final stored = (await history.readAll()).single.snapshot;
    expect(stored.lifecycle, 'cancelled');
    expect(stored.payload['outcome'], isNull);
  });

  test('Draft settings survive persistence round-trip', () async {
    final profile = LocalProfile(id: 'profile-1', nickname: 'Host');
    var session = await service.createDraft(
      profile: profile,
      title: 'Draft',
      formatId: 'double-elimination',
    );

    session = await service.updateDraft(
      session,
      title: 'Local Cup',
      formatId: 'round-robin',
    );
    final restored = await service.loadActive();

    expect(restored!.tournament.title, 'Local Cup');
    expect(restored.tournament.formatId, 'round-robin');
    expect(session.tournament, restored.tournament);
    expect(
      () => service.updateDraft(
        session,
        title: 'Unsupported',
        formatId: 'unknown',
      ),
      throwsA(isA<FormatException>()),
    );
  });
}

GameDefinition _game() => GameDefinition(
  gameId: 'mk11-ultimate',
  rosterName: 'Test roster',
  fighters: [
    for (var index = 0; index < 12; index++)
      Fighter(
        id: FighterId('fighter-$index'),
        displayName: 'Fighter $index',
        assetPath: 'assets/fighters/fighter-$index.png',
      ),
  ],
);
